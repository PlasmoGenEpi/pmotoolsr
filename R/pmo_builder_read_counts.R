# PMO builder: read-count-by-stage tables -> read_counts_by_stage structure
#
# Ported from pmotools-python pmo_builder/read_count_by_stage_table_to_pmo.py.
# Name-based intermediate (library_sample_name / target_name); merge_to_pmo
# replaces the names with indices.

# Total raw read count and extra fields per library sample, keyed by name.
# `cfg` holds the builder's column arguments (see
# pmo_read_count_by_stage_table_to_pmo()).
#' @keywords internal
.rc_process_total_raw_count <- function(tbl, cfg) {
  cols <- list(library_sample_name_col = cfg$library_sample_name_col,
               total_raw_count_col = cfg$total_raw_count_col)
  .check_columns_exist(tbl, cols, "total_raw_count_table")
  .check_required_values(tbl, cols, "total_raw_count_table")
  samples <- .as_text(tbl[[cfg$library_sample_name_col]])
  totals <- .as_counts(tbl[[cfg$total_raw_count_col]],
                       .arg_label("total_raw_count_col", cfg$total_raw_count_col))
  if (any(duplicated(samples))) {
    stop("Duplicate library sample names found in total_raw_count_table: ",
         paste(unique(samples[duplicated(samples)]), collapse = ", "))
  }
  sample_data <- list()
  for (i in seq_len(nrow(tbl))) {
    info <- list(total_raw_count = totals[i])
    for (col in cfg$additional_library_sample_cols) {
      if (.has_value(tbl[[col]][i])) info[[col]] <- tbl[[col]][i]
    }
    sample_data[[samples[i]]] <- info
  }
  sample_data
}

# Read counts nested as reads[[sample]][[target]][[stage]]. In wide format each
# stage has its own count column, named in cfg$stage_col; in long format the
# stage is in cfg$stage_col and the count in cfg$read_count_col.
#' @keywords internal
.rc_process_reads_by_stage <- function(tbl, cfg) {
  cols <- list(library_sample_name_col = cfg$library_sample_name_col,
               target_name_col = cfg$target_name_col, stage_col = cfg$stage_col)
  hint <- NULL
  if (!cfg$wide) {
    if (length(cfg$stage_col) != 1) {
      stop("In long format stage_col must name one column; pass wide = TRUE ",
           "if these are count columns, one per stage.", call. = FALSE)
    }
    cols$read_count_col <- cfg$read_count_col
    if (!(cfg$read_count_col %in% names(tbl))) {
      hint <- paste0("If \"", cfg$stage_col, "\" is a count column (wide ",
                     "format with one stage), pass wide = TRUE")
    }
  }
  .check_columns_exist(tbl, cols, "reads_by_stage_table", hint = hint)
  .check_required_values(tbl, cols, "reads_by_stage_table")

  samples <- .as_text(tbl[[cfg$library_sample_name_col]])
  targets <- .as_text(tbl[[cfg$target_name_col]])
  count_arg <- if (cfg$wide) "stage_col" else "read_count_col"
  count_cols <- if (cfg$wide) cfg$stage_col else cfg$read_count_col
  counts <- lapply(stats::setNames(count_cols, count_cols), function(col) {
    .as_counts(tbl[[col]], .arg_label(count_arg, col))
  })
  stage_names <- if (!cfg$wide) .as_text(tbl[[cfg$stage_col]])

  reads_data <- list()
  for (i in seq_len(nrow(tbl))) {
    for (count_col in count_cols) {
      stage <- if (cfg$wide) count_col else stage_names[i]
      stage_data <- list(stage = stage, reads = counts[[count_col]][i])
      for (col in cfg$additional_target_cols) {
        if (.has_value(tbl[[col]][i])) stage_data[[col]] <- tbl[[col]][i]
      }
      reads_data[[samples[i]]][[targets[i]]][[stage]] <- stage_data
    }
  }
  reads_data
}

#' @keywords internal
.rc_build_output <- function(sample_data, reads_data, run_name) {
  by_sample <- list()
  for (sname in names(sample_data)) {
    info <- sample_data[[sname]]
    entry <- list(library_sample_name = sname,
                  total_raw_count = info$total_raw_count)
    for (k in names(info)) {
      if (k != "total_raw_count") entry[[k]] <- info[[k]]
    }
    if (!is.null(reads_data) && !is.null(reads_data[[sname]])) {
      targets <- reads_data[[sname]]
      rcft <- list()
      for (tname in names(targets)) {
        stages <- unname(targets[[tname]])
        rcft[[length(rcft) + 1L]] <- list(target_name = tname, stages = stages)
      }
      if (length(rcft) > 0) entry$read_counts_for_targets <- rcft
    }
    by_sample[[length(by_sample) + 1L]] <- entry
  }
  out <- list(read_counts_by_library_sample_by_stage = by_sample)
  if (!is.null(run_name)) out$bioinformatics_run_name <- run_name
  out
}

#' Convert read-count tables into the PMO read_counts_by_stage structure
#'
#' @param total_raw_count_table A data.frame with one row per library sample
#'   giving its total raw read count.
#' @param bioinformatics_run_name Either a column name in
#'   `total_raw_count_table` (one set built per unique value) or a single run
#'   name, or `NULL`.
#' @param reads_by_stage_table Optional data.frame of per-sample, per-target,
#'   per-stage read counts. In long format `stage_col` names the column holding
#'   the stage and `read_count_col` the count. In wide format each stage has
#'   its own count column, and `stage_col` names those columns (see `wide`).
#' @param library_sample_name_col,target_name_col,total_raw_count_col,stage_col,read_count_col
#'   Column names.
#' @param additional_library_sample_cols,additional_target_cols Optional extra
#'   columns to carry through.
#' @param wide `TRUE` if `reads_by_stage_table` is in wide format, with one
#'   count column per stage named in `stage_col`. The default is `TRUE` when
#'   `stage_col` names more than one column. Set it to `TRUE` for a wide table
#'   with a single stage column (pmotools-python tells the two apart by whether
#'   `stage_col` is a list or a string, which R cannot).
#' @return A list of read-count sets (one per run; always a list).
#' @examples
#' totals <- data.frame(library_sample_name = c("l1", "l2"),
#'                      total_raw_count = c(1000, 2000))
#' pmo_read_count_by_stage_table_to_pmo(totals)
#' @export
pmo_read_count_by_stage_table_to_pmo <- function(
    total_raw_count_table, bioinformatics_run_name = NULL,
    reads_by_stage_table = NULL,
    library_sample_name_col = "library_sample_name",
    target_name_col = "target_name", total_raw_count_col = "total_raw_count",
    stage_col = "stage", read_count_col = "read_count",
    additional_library_sample_cols = NULL, additional_target_cols = NULL,
    wide = length(stage_col) > 1) {

  if (!is.data.frame(total_raw_count_table)) {
    stop("total_raw_count_table must be a data.frame")
  }
  if (!is.null(reads_by_stage_table) && !is.data.frame(reads_by_stage_table)) {
    stop("reads_by_stage_table must be a data.frame or NULL")
  }

  # The additional columns are checked against the whole tables: a table split
  # by run no longer has its run column, which may be one of them.
  .check_columns_exist(
    total_raw_count_table,
    list(additional_library_sample_cols = additional_library_sample_cols),
    "total_raw_count_table")
  if (!is.null(reads_by_stage_table)) {
    .check_columns_exist(reads_by_stage_table,
                         list(additional_target_cols = additional_target_cols),
                         "reads_by_stage_table")
  }

  cfg <- list(library_sample_name_col = library_sample_name_col,
              target_name_col = target_name_col,
              total_raw_count_col = total_raw_count_col, stage_col = stage_col,
              read_count_col = read_count_col, wide = wide,
              additional_library_sample_cols = additional_library_sample_cols,
              additional_target_cols = additional_target_cols)
  build_one <- function(total_tbl, reads_tbl, run_name) {
    sample_data <- .rc_process_total_raw_count(total_tbl, cfg)
    reads_data <- NULL
    if (!is.null(reads_tbl)) {
      reads_data <- .rc_process_reads_by_stage(reads_tbl, cfg)
    }
    .rc_build_output(sample_data, reads_data, run_name)
  }

  is_col <- !is.null(bioinformatics_run_name) &&
    bioinformatics_run_name %in% names(total_raw_count_table)
  if (is_col) {
    # a row with no run would otherwise be copied into every run, and run
    # names are text whatever type the column was read as
    run_arg <- list(bioinformatics_run_name = bioinformatics_run_name)
    .check_required_values(total_raw_count_table, run_arg,
                           "total_raw_count_table")
    total_raw_count_table[[bioinformatics_run_name]] <-
      .as_text(total_raw_count_table[[bioinformatics_run_name]])
    if (!is.null(reads_by_stage_table) &&
        bioinformatics_run_name %in% names(reads_by_stage_table)) {
      .check_required_values(reads_by_stage_table, run_arg,
                             "reads_by_stage_table")
      reads_by_stage_table[[bioinformatics_run_name]] <-
        .as_text(reads_by_stage_table[[bioinformatics_run_name]])
    }
    out <- list()
    for (run in unique(total_raw_count_table[[bioinformatics_run_name]])) {
      total_tbl <- total_raw_count_table[
        total_raw_count_table[[bioinformatics_run_name]] == run,
        setdiff(names(total_raw_count_table), bioinformatics_run_name),
        drop = FALSE]
      reads_tbl <- NULL
      if (!is.null(reads_by_stage_table)) {
        if (bioinformatics_run_name %in% names(reads_by_stage_table)) {
          # as in pmotools-python, reads rows whose run is not in the totals
          # table are left out
          reads_tbl <- reads_by_stage_table[
            reads_by_stage_table[[bioinformatics_run_name]] == run,
            setdiff(names(reads_by_stage_table), bioinformatics_run_name),
            drop = FALSE]
        } else {
          reads_tbl <- reads_by_stage_table
        }
      }
      out[[length(out) + 1L]] <- build_one(total_tbl, reads_tbl, run)
    }
    return(out)
  }
  run_name <- if (!is.null(bioinformatics_run_name)) {
    .as_text(bioinformatics_run_name)
  }
  list(build_one(total_raw_count_table, reads_by_stage_table, run_name))
}
