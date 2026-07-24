# PMO builder: read-count-by-stage tables -> read_counts_by_stage structure
#
# Ported from pmotools-python pmo_builder/read_count_by_stage_table_to_pmo.py.
# Name-based intermediate (library_sample_name / target_name); merge_to_pmo
# replaces the names with indices.

#' @keywords internal
.rc_process_total_raw_count <- function(tbl, lib_col, total_col, additional) {
  missing <- setdiff(c(lib_col, total_col), names(tbl))
  if (length(missing) > 0) {
    stop("Missing required columns in total_raw_count_table: ",
         paste(missing, collapse = ", "))
  }
  if (any(duplicated(tbl[[lib_col]]))) {
    dups <- unique(tbl[[lib_col]][duplicated(tbl[[lib_col]])])
    stop("Duplicate library sample names found in total_raw_count_table: ",
         paste(dups, collapse = ", "))
  }
  sample_data <- list()
  for (i in seq_len(nrow(tbl))) {
    info <- list(total_raw_count = as.integer(tbl[[total_col]][i]))
    for (col in additional) {
      if (col %in% names(tbl) && .present(tbl[[col]][i])) {
        info[[col]] <- tbl[[col]][i]
      }
    }
    sample_data[[as.character(tbl[[lib_col]][i])]] <- info
  }
  sample_data
}

#' @keywords internal
.rc_long_records <- function(tbl, lib_col, tgt_col, stage_col, read_count_col,
                             additional) {
  records <- list()
  add_record <- function(sample, target, stage, reads, row_i, src_tbl) {
    sd <- list(stage = stage, reads = as.integer(reads))
    for (col in additional) {
      if (col %in% names(src_tbl) && .present(src_tbl[[col]][row_i])) {
        sd[[col]] <- src_tbl[[col]][row_i]
      }
    }
    records[[length(records) + 1L]] <<- list(sample = sample, target = target,
                                             stage_data = sd)
  }
  if (length(stage_col) > 1) {
    needed <- c(lib_col, tgt_col, stage_col)
    missing <- setdiff(needed, names(tbl))
    if (length(missing) > 0) {
      stop("Missing required columns in reads_by_stage_table: ",
           paste(missing, collapse = ", "))
    }
    for (i in seq_len(nrow(tbl))) {
      for (scol in stage_col) {
        add_record(tbl[[lib_col]][i], tbl[[tgt_col]][i], scol,
                   tbl[[scol]][i], i, tbl)
      }
    }
  } else {
    needed <- c(lib_col, tgt_col, stage_col, read_count_col)
    missing <- setdiff(needed, names(tbl))
    if (length(missing) > 0) {
      stop("Missing required columns in reads_by_stage_table: ",
           paste(missing, collapse = ", "))
    }
    for (i in seq_len(nrow(tbl))) {
      add_record(tbl[[lib_col]][i], tbl[[tgt_col]][i], tbl[[stage_col]][i],
                 tbl[[read_count_col]][i], i, tbl)
    }
  }
  records
}

#' @keywords internal
.rc_process_reads_by_stage <- function(tbl, lib_col, tgt_col, stage_col,
                                       read_count_col, additional) {
  records <- .rc_long_records(tbl, lib_col, tgt_col, stage_col, read_count_col,
                              additional)
  reads_data <- list()
  for (rec in records) {
    s <- as.character(rec$sample)
    t <- as.character(rec$target)
    st <- as.character(rec$stage_data$stage)
    reads_data[[s]][[t]][[st]] <- rec$stage_data
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
#'   per-stage read counts; long format (single `stage_col`) or wide format
#'   (pass `stage_col` as a vector of stage column names).
#' @param library_sample_name_col,target_name_col,total_raw_count_col,stage_col,read_count_col
#'   Column names.
#' @param additional_library_sample_cols,additional_target_cols Optional extra
#'   columns to carry through.
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
    additional_library_sample_cols = NULL, additional_target_cols = NULL) {

  if (!is.data.frame(total_raw_count_table)) {
    stop("total_raw_count_table must be a data.frame")
  }
  if (!is.null(reads_by_stage_table) && !is.data.frame(reads_by_stage_table)) {
    stop("reads_by_stage_table must be a data.frame or NULL")
  }
  if (!is.null(additional_library_sample_cols)) {
    .check_additional_columns_exist(total_raw_count_table,
                                    additional_library_sample_cols)
  }
  if (!is.null(reads_by_stage_table) && !is.null(additional_target_cols)) {
    .check_additional_columns_exist(reads_by_stage_table, additional_target_cols)
  }

  build_one <- function(total_tbl, reads_tbl, run_name) {
    sample_data <- .rc_process_total_raw_count(
      total_tbl, library_sample_name_col, total_raw_count_col,
      additional_library_sample_cols)
    reads_data <- NULL
    if (!is.null(reads_tbl)) {
      reads_data <- .rc_process_reads_by_stage(
        reads_tbl, library_sample_name_col, target_name_col, stage_col,
        read_count_col, additional_target_cols)
    }
    .rc_build_output(sample_data, reads_data, run_name)
  }

  is_col <- !is.null(bioinformatics_run_name) &&
    bioinformatics_run_name %in% names(total_raw_count_table)
  if (is_col) {
    out <- list()
    for (run in unique(total_raw_count_table[[bioinformatics_run_name]])) {
      total_tbl <- total_raw_count_table[
        total_raw_count_table[[bioinformatics_run_name]] == run,
        setdiff(names(total_raw_count_table), bioinformatics_run_name),
        drop = FALSE]
      reads_tbl <- NULL
      if (!is.null(reads_by_stage_table)) {
        if (bioinformatics_run_name %in% names(reads_by_stage_table)) {
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
  list(build_one(total_raw_count_table, reads_by_stage_table,
                 bioinformatics_run_name))
}
