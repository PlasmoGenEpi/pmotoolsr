# PMO exporter utilities
#
# Ported from pmotools-python's PMOExporter (src/pmotools/pmo_engine/pmo_exporter.py).
# Flat meta tables and the allele table are returned as tibbles. Id/index fields
# are 1-based in memory (see the package's offset convention), so columns such as
# genome_id are 1-based here (one greater than the on-disk JSON value).

#' @keywords internal
.is_named_list <- function(v) {
  is.list(v) && !is.null(names(v)) && any(nzchar(names(v)))
}

#' Flatten the exportable (primitive / primitive-list) fields of an object
#'
#' Scalars are kept as-is, atomic vectors and unnamed scalar lists are joined
#' with `separator`, and nested objects / lists of objects are skipped.
#' @keywords internal
.flatten_obj <- function(obj, separator, skip = character(0)) {
  out <- list()
  for (key in names(obj)) {
    if (key %in% skip) next
    v <- obj[[key]]
    if (is.null(v)) next
    if (is.atomic(v)) {
      out[[key]] <- if (length(v) == 0) NA else if (length(v) == 1) v else
        paste(as.character(v), collapse = separator)
    } else if (is.list(v) && !.is_named_list(v) && length(v) > 0 &&
               all(vapply(v, function(e) is.atomic(e) && length(e) == 1,
                          logical(1)))) {
      out[[key]] <- paste(as.character(unlist(v)), collapse = separator)
    }
    # named lists (nested objects) and lists of objects are skipped
  }
  out
}

#' @keywords internal
.reorder_priority <- function(df, priority) {
  leading <- intersect(priority, names(df))
  rest <- sort(setdiff(names(df), priority))
  df[c(leading, rest)]
}

#' @keywords internal
.scalar_or_join <- function(v, separator = ",") {
  if (is.null(v) || length(v) == 0) return("NA")
  if (length(v) == 1) return(v)
  paste(as.character(v), collapse = separator)
}

# ---------------------------------------------------------------------------
# Flat meta-table exporters (return tibbles)
# ---------------------------------------------------------------------------

#' Export specimen travel metadata
#'
#' One row per travel record in `travel_out_six_month`.
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param separator Separator for list-valued fields.
#' @return A tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_export_specimen_travel_meta_table(p)
#' @export
pmo_export_specimen_travel_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  rows <- list()
  for (specimen in p$specimen_info) {
    if (!is.null(specimen$travel_out_six_month)) {
      for (travel in specimen$travel_out_six_month) {
        row <- c(list(specimen_name = specimen$specimen_name),
                 .flatten_obj(travel, separator))
        rows[[length(rows) + 1L]] <- row
      }
    }
  }
  dplyr::bind_rows(rows)
}

#' Export specimen metadata
#'
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble of specimen metadata (`project_id` resolved to
#'   `project_name`; complex nested fields omitted).
#' @examples
#' pmo <- read_pmo(
#'   system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_export_specimen_meta_table(pmo))
#' @export
pmo_export_specimen_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  rows <- lapply(p$specimen_info, function(spec) {
    row <- .flatten_obj(spec, separator, skip = "project_id")
    if (!is.null(spec$project_id)) {
      row$project_name <- p$project_info[[spec$project_id]]$project_name
    }
    row
  })
  dplyr::bind_rows(rows)
}

#' Export library sample metadata
#'
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble (`sequencing_info_id`/`specimen_id`/`panel_id` resolved to
#'   their names).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_export_library_sample_meta_table(p))
#' @export
pmo_export_library_sample_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  rows <- lapply(p$library_sample_info, function(lib) {
    row <- .flatten_obj(lib, separator,
                        skip = c("sequencing_info_id", "specimen_id", "panel_id"))
    if (!is.null(lib$sequencing_info_id)) {
      row$sequencing_info_name <-
        p$sequencing_info[[lib$sequencing_info_id]]$sequencing_info_name
    }
    if (!is.null(lib$specimen_id)) {
      row$specimen_name <- p$specimen_info[[lib$specimen_id]]$specimen_name
    }
    if (!is.null(lib$panel_id)) {
      row$panel_name <- p$panel_info[[lib$panel_id]]$panel_name
    }
    row
  })
  dplyr::bind_rows(rows)
}

#' Export bioinformatics run info metadata
#'
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble with a 1-based `run_id` column.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_export_bioinformatics_run_info_meta_table(p)
#' @export
pmo_export_bioinformatics_run_info_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  .require_section(p, "bioinformatics_run_info")
  rows <- list()
  for (i in seq_along(p$bioinformatics_run_info)) {
    row <- c(list(run_id = i),
             .flatten_obj(p$bioinformatics_run_info[[i]], separator))
    rows[[length(rows) + 1L]] <- row
  }
  dplyr::bind_rows(rows)
}

#' Export bioinformatics methods info metadata
#'
#' One row per method step, with 1-based `bioinformatics_methods_id` and
#' `method_id` columns.
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_export_bioinformatics_methods_info_meta_table(p)
#' @export
pmo_export_bioinformatics_methods_info_meta_table <- function(pmo,
                                                              separator = ",") {
  p <- .pmo_as_list(pmo)
  .require_section(p, "bioinformatics_methods_info")
  rows <- list()
  for (i in seq_along(p$bioinformatics_methods_info)) {
    info <- p$bioinformatics_methods_info[[i]]
    base <- c(list(bioinformatics_methods_id = i),
              .flatten_obj(info, separator, skip = "methods"))
    for (m in seq_along(info$methods)) {
      method <- info$methods[[m]]
      row <- base
      row$method_id <- m
      for (k in names(method)) row[[k]] <- .scalar_or_join(method[[k]], separator)
      rows[[length(rows) + 1L]] <- row
    }
  }
  dplyr::bind_rows(rows)
}

#' Export sequencing info metadata
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_export_sequencing_info_meta_table(p))
#' @export
pmo_export_sequencing_info_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  .require_section(p, "sequencing_info")
  dplyr::bind_rows(lapply(p$sequencing_info, .flatten_obj,
                          separator = separator))
}

#' Export project info metadata
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_export_project_info_meta_table(p)
#' @export
pmo_export_project_info_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  .require_section(p, "project_info")
  dplyr::bind_rows(lapply(p$project_info, .flatten_obj, separator = separator))
}

#' Export panel info metadata
#'
#' One row per (panel, target), with `reaction_name` listing the reactions a
#' target appears in.
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_export_panel_info_meta_table(p))
#' @export
pmo_export_panel_info_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  rows <- list()
  for (panel in p$panel_info) {
    base <- .flatten_obj(panel, separator, skip = "reactions")
    reactions_for_target <- list()
    for (reaction in panel$reactions) {
      for (target_id in unlist(reaction$panel_targets)) {
        tname <- p$target_info[[target_id]]$target_name
        reactions_for_target[[tname]] <-
          c(reactions_for_target[[tname]], reaction$reaction_name)
      }
    }
    for (tname in names(reactions_for_target)) {
      row <- base
      row$target_name <- tname
      row$reaction_name <- paste(reactions_for_target[[tname]],
                                 collapse = separator)
      rows[[length(rows) + 1L]] <- row
    }
  }
  dplyr::bind_rows(rows)
}

#' Export target info metadata
#'
#' Primer sequences and primer/insert genomic locations are flattened into
#' `forward_primer_*`, `reverse_primer_*`, and `insert_*` columns.
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_export_target_info_meta_table(p))
#' @export
pmo_export_target_info_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  rows <- lapply(p$target_info, function(target) {
    row <- .flatten_obj(target, separator,
                        skip = c("forward_primer", "reverse_primer",
                                 "insert_location"))
    for (side in c("forward_primer", "reverse_primer")) {
      primer <- target[[side]]
      if (!is.null(primer)) {
        row[[paste0(side, "_seq")]] <- primer$seq
        if (!is.null(primer$location)) {
          for (k in names(primer$location)) {
            row[[paste0(side, "_", k)]] <- .scalar_or_join(primer$location[[k]],
                                                           separator)
          }
        }
      }
    }
    if (!is.null(target$insert_location)) {
      for (k in names(target$insert_location)) {
        row[[paste0("insert_", k)]] <- .scalar_or_join(
          target$insert_location[[k]], separator)
      }
    }
    row
  })
  df <- dplyr::bind_rows(rows)
  .reorder_priority(df, c("target_name", "forward_primer_seq",
                          "reverse_primer_seq"))
}

#' Export PMO header metadata
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A one-row tibble.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_export_pmo_header_table(p)
#' @export
pmo_export_pmo_header_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  if (is.null(p$pmo_header)) stop("no pmo_header found in input PMO")
  row <- .flatten_obj(p$pmo_header, separator, skip = "generation_method")
  gm <- p$pmo_header$generation_method
  if (!is.null(gm)) {
    row[["generation_method.program_version"]] <- gm$program_version
    row[["generation_method.program_name"]] <- gm$program_name
  }
  .reorder_priority(dplyr::bind_rows(row), "pmo_version")
}

#' Export targeted genomes metadata
#' @inheritParams pmo_export_specimen_travel_meta_table
#' @return A tibble with a 1-based `genome_id` column.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_export_targeted_genomes_meta_table(p)
#' @export
pmo_export_targeted_genomes_meta_table <- function(pmo, separator = ",") {
  p <- .pmo_as_list(pmo)
  .require_section(p, "targeted_genomes")
  rows <- list()
  for (i in seq_along(p$targeted_genomes)) {
    row <- c(list(genome_id = i),
             .flatten_obj(p$targeted_genomes[[i]], separator))
    rows[[length(rows) + 1L]] <- row
  }
  df <- dplyr::bind_rows(rows)
  .reorder_priority(df, c("name", "genome_version", "taxon_id", "genome_id",
                          "url"))
}

# ---------------------------------------------------------------------------
# BED insert-location extraction
# ---------------------------------------------------------------------------

#' @keywords internal
.bed_row_for_target <- function(target, genome, extra_info) {
  loc <- target$insert_location
  list(
    chrom = loc$chrom,
    start = loc$start,
    end = loc$end,
    name = target$target_name,
    score = loc$end - loc$start,
    strand = if (is.null(loc$strand)) "+" else loc$strand,
    ref_seq = if (is.null(loc$ref_seq)) "" else loc$ref_seq,
    extra_info = extra_info
  )
}

#' Extract target insert locations as BED rows
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param select_target_ids Optional 1-based target ids (default all).
#' @param sort_output Sort by chrom, start, end.
#' @return A tibble with columns `chrom`, `start`, `end`, `name`, `score`,
#'   `strand`, `ref_seq`, `extra_info`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_extract_targets_insert_bed(p))
#' @export
pmo_extract_targets_insert_bed <- function(pmo, select_target_ids = NULL,
                                           sort_output = TRUE) {
  p <- .pmo_as_list(pmo)
  .require_section(p, "targeted_genomes")
  if (is.null(select_target_ids)) select_target_ids <- seq_along(p$target_info)
  rows <- list()
  for (target_id in select_target_ids) {
    tar <- p$target_info[[target_id]]
    if (is.null(tar$insert_location)) {
      stop("no insert_location for target id ", target_id, " target_name ",
           tar$target_name, ", cannot extract insert_location")
    }
    genome <- p$targeted_genomes[[tar$insert_location$genome_id]]
    extra_info <- paste0("[genome_name_version=", genome$name, "_",
                         genome$genome_version, ";]")
    rows[[length(rows) + 1L]] <- .bed_row_for_target(tar, genome, extra_info)
  }
  df <- dplyr::bind_rows(rows)
  if (sort_output && nrow(df) > 0) {
    df <- df[order(df$chrom, df$start, df$end), , drop = FALSE]
  }
  df
}

#' Extract panel insert locations as BED rows
#'
#' Returns a single tibble covering all requested panels, with `panel_name` and
#' `reaction_name` columns identifying each insert's source.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param select_panel_ids Optional 1-based panel ids (default all).
#' @param sort_output Sort by panel, chrom, start, end.
#' @return A tibble of BED rows plus `panel_name` and `reaction_name`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_extract_panels_insert_bed(p))
#' @export
pmo_extract_panels_insert_bed <- function(pmo, select_panel_ids = NULL,
                                          sort_output = TRUE) {
  p <- .pmo_as_list(pmo)
  .require_section(p, "targeted_genomes")
  if (is.null(select_panel_ids)) select_panel_ids <- seq_along(p$panel_info)
  rows <- list()
  for (panel_id in select_panel_ids) {
    panel <- p$panel_info[[panel_id]]
    for (reaction in panel$reactions) {
      for (target_id in unlist(reaction$panel_targets)) {
        tar <- p$target_info[[target_id]]
        if (is.null(tar$insert_location)) {
          stop("no insert_location for target id ", target_id, " target_name ",
               tar$target_name, ", cannot extract insert_location")
        }
        genome <- p$targeted_genomes[[tar$insert_location$genome_id]]
        extra_info <- paste0("[genome_name_version=", genome$name, "_",
                             genome$genome_version, ";panel=", panel$panel_name,
                             ";reaction=", reaction$reaction_name, ";]")
        row <- .bed_row_for_target(tar, genome, extra_info)
        row$panel_name <- panel$panel_name
        row$reaction_name <- reaction$reaction_name
        rows[[length(rows) + 1L]] <- row
      }
    }
  }
  df <- dplyr::bind_rows(rows)
  if (sort_output && nrow(df) > 0) {
    df <- df[order(df$panel_name, df$chrom, df$start, df$end), , drop = FALSE]
  }
  df
}

#' Write BED rows to a file
#'
#' @param bed A tibble/data.frame as returned by [pmo_extract_targets_insert_bed()].
#' @param path Output file path (overwritten if present).
#' @param add_header Write a commented `#chrom ...` header line.
#' @return Invisibly `path`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' bed <- pmo_extract_targets_insert_bed(p)
#' pmo_write_bed(bed, tempfile(fileext = ".bed"))
#' @export
pmo_write_bed <- function(bed, path, add_header = FALSE) {
  cols <- c("chrom", "start", "end", "name", "score", "strand", "ref_seq",
            "extra_info")
  cols <- intersect(cols, names(bed))
  con <- file(path, open = "wt")
  on.exit(close(con), add = TRUE)
  if (add_header) {
    writeLines(paste0("#", paste(cols, collapse = "\t")), con)
  }
  if (nrow(bed) > 0) {
    for (i in seq_len(nrow(bed))) {
      writeLines(paste(vapply(cols, function(cc) as.character(bed[[cc]][i]),
                              character(1)), collapse = "\t"), con)
    }
  }
  invisible(path)
}

# ---------------------------------------------------------------------------
# Allele table (for dcifer / moire etc.)
# ---------------------------------------------------------------------------

#' @keywords internal
.any_object_has_field <- function(objects, field) {
  for (o in objects) if (!is.null(o[[field]])) return(TRUE)
  FALSE
}

#' Extract a per-sample allele table
#'
#' Builds a long table of library sample, target, and representative
#' microhaplotype sequence, with optional additional metadata columns. This is
#' the table consumed by downstream tools (dcifer, moire, ...).
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param additional_specimen_info_fields,additional_library_sample_info_fields,additional_microhap_fields,additional_representative_info_fields
#'   Optional character vectors of extra fields to include from the respective
#'   objects; an error is raised if a requested field exists nowhere.
#' @param default_base_col_names Length-3 character vector naming the sample,
#'   target, and sequence columns.
#' @param validate If `TRUE`, validate the PMO against the schema first.
#' @return A tibble.
#' @examples
#' pmo <- read_pmo(
#'   system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_extract_alleles_per_sample_table(pmo))
#' @export
pmo_extract_alleles_per_sample_table <- function(
    pmo,
    additional_specimen_info_fields = NULL,
    additional_library_sample_info_fields = NULL,
    additional_microhap_fields = NULL,
    additional_representative_info_fields = NULL,
    default_base_col_names = c("library_sample_name", "target_name", "seq"),
    validate = FALSE) {
  p <- .pmo_as_list(pmo)
  if (validate) pmo_validate_jsonschema(pmo)
  if (length(default_base_col_names) != 3) {
    stop("default_base_col_names must have 3 entries, not ",
         length(default_base_col_names))
  }

  check_fields <- function(fields, objects, what) {
    if (is.null(fields)) return(invisible())
    missing <- fields[!vapply(fields, function(f) .any_object_has_field(objects, f),
                              logical(1))]
    if (length(missing) > 0) {
      stop("No ", what, " have data for fields: ",
           paste(missing, collapse = ", "))
    }
  }
  check_fields(additional_specimen_info_fields, p$specimen_info, "specimen_info")
  check_fields(additional_library_sample_info_fields, p$library_sample_info,
               "library_sample_info")
  all_mhaps <- list()
  for (dm in p$detected_microhaplotypes) for (s in dm$library_samples) {
    for (tr in s$target_results) for (mh in tr$mhaps) {
      all_mhaps[[length(all_mhaps) + 1L]] <- mh
    }
  }
  check_fields(additional_microhap_fields, all_mhaps, "detected_microhaplotypes")
  all_reps <- list()
  for (t in p$representative_microhaplotypes$targets) {
    for (mh in t$microhaplotypes) all_reps[[length(all_reps) + 1L]] <- mh
  }
  check_fields(additional_representative_info_fields, all_reps,
               "representative_microhaplotypes")

  library_sample_info <- p$library_sample_info
  specimen_info <- p$specimen_info
  target_info <- p$target_info
  rep_haps <- p$representative_microhaplotypes$targets
  run_names <- if (!is.null(p$bioinformatics_run_info)) {
    vapply(p$bioinformatics_run_info,
           function(x) x$bioinformatics_run_name, character(1))
  } else {
    NULL
  }

  rows <- list()
  detected_count <- 0L
  for (dm in p$detected_microhaplotypes) {
    run_id <- dm$bioinformatics_run_id
    for (sample_data in dm$library_samples) {
      lib_meta <- library_sample_info[[sample_data$library_sample_id]]
      spec_meta <- specimen_info[[lib_meta$specimen_id]]
      for (target_data in sample_data$target_results) {
        rep_for_target <- rep_haps[[target_data$mhaps_target_id]]
        target_name <- target_info[[rep_for_target$target_id]]$target_name
        for (mh in target_data$mhaps) {
          allele_id <- mh$mhap_id
          rep_meta <- rep_for_target$microhaplotypes[[allele_id]]
          row <- list()
          row[[default_base_col_names[1]]] <- lib_meta$library_sample_name
          row[[default_base_col_names[2]]] <- target_name
          row[[default_base_col_names[3]]] <- rep_meta$seq
          row[["bioinformatics_run_name"]] <-
            if (!is.null(run_names) && !is.null(run_id)) {
              run_names[run_id]
            } else {
              paste0("detected_microhaplotypes_count_idx_", detected_count)
            }
          for (f in additional_library_sample_info_fields) {
            row[[f]] <- .scalar_or_join(lib_meta[[f]])
          }
          for (f in additional_specimen_info_fields) {
            row[[f]] <- .scalar_or_join(spec_meta[[f]])
          }
          for (f in additional_microhap_fields) {
            row[[f]] <- .scalar_or_join(mh[[f]])
          }
          for (f in additional_representative_info_fields) {
            row[[f]] <- .scalar_or_join(rep_meta[[f]])
          }
          rows[[length(rows) + 1L]] <- row
        }
      }
    }
    detected_count <- detected_count + 1L
  }
  dplyr::bind_rows(rows)
}

#' List library sample names per specimen
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param select_specimen_ids Optional 1-based specimen ids.
#' @param select_specimen_names Optional specimen names (mutually exclusive with
#'   `select_specimen_ids`).
#' @return A tibble with columns `specimen_name`, `library_sample_name`,
#'   `library_sample_count`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_list_library_samples_per_specimen(p))
#' @export
pmo_list_library_samples_per_specimen <- function(pmo,
                                                  select_specimen_ids = NULL,
                                                  select_specimen_names = NULL) {
  p <- .pmo_as_list(pmo)
  if (!is.null(select_specimen_ids) && !is.null(select_specimen_names)) {
    stop("Cannot specify both select_specimen_ids and select_specimen_names")
  }
  if (!is.null(select_specimen_names)) {
    select_specimen_ids <- pmo_index_of_specimen_names(p, select_specimen_names)
  }
  per_spec <- list()
  for (lib in p$library_sample_info) {
    if (is.null(select_specimen_ids) || lib$specimen_id %in% select_specimen_ids) {
      sname <- p$specimen_info[[lib$specimen_id]]$specimen_name
      per_spec[[sname]] <- c(per_spec[[sname]], lib$library_sample_name)
    }
  }
  rows <- list()
  for (sname in names(per_spec)) {
    libs <- per_spec[[sname]]
    for (lib_name in libs) {
      rows[[length(rows) + 1L]] <- list(
        specimen_name = sname,
        library_sample_name = lib_name,
        library_sample_count = length(libs)
      )
    }
  }
  if (length(rows) == 0) {
    return(tibble::tibble(specimen_name = character(0),
                          library_sample_name = character(0),
                          library_sample_count = integer(0)))
  }
  dplyr::bind_rows(rows)
}

# ---------------------------------------------------------------------------
# Excel export
# ---------------------------------------------------------------------------

#' @keywords internal
.build_pmo_sheet_configs <- function(pmo) {
  sheets <- list(
    list(name = "PMO Header", df = pmo_export_pmo_header_table(pmo)),
    list(name = "Required Panel Targets",
         df = pmo_export_target_info_meta_table(pmo)),
    list(name = "Required Panel Info",
         df = pmo_export_panel_info_meta_table(pmo))
  )
  if (pmo_has_section(pmo, "targeted_genomes")) {
    sheets <- c(sheets, list(list(name = "Optional GenomeInfo",
      df = pmo_export_targeted_genomes_meta_table(pmo))))
  }
  sheets <- c(sheets, list(
    list(name = "Required Microhaplotype",
         df = pmo_extract_alleles_per_sample_table(
           pmo, additional_microhap_fields = "reads")),
    list(name = "Optional Specimen Level",
         df = pmo_export_specimen_meta_table(pmo)),
    list(name = "Optional LibrarySampleInfo",
         df = pmo_export_library_sample_meta_table(pmo))
  ))
  if (pmo_has_section(pmo, "project_info")) {
    sheets <- c(sheets, list(list(name = "Optional ProjectInfo",
      df = pmo_export_project_info_meta_table(pmo))))
  }
  if (pmo_has_section(pmo, "sequencing_info")) {
    sheets <- c(sheets, list(list(name = "Optional SequencingInfo",
      df = pmo_export_sequencing_info_meta_table(pmo))))
  }
  if (pmo_has_section(pmo, "bioinformatics_methods_info")) {
    sheets <- c(sheets, list(list(name = "Optional Bioinformatics Methods",
      df = pmo_export_bioinformatics_methods_info_meta_table(pmo))))
  }
  if (pmo_has_section(pmo, "bioinformatics_run_info")) {
    sheets <- c(sheets, list(list(name = "Optional Bioinformatics Run",
      df = pmo_export_bioinformatics_run_info_meta_table(pmo))))
  }
  sheets
}

#' Export a PMO to a multi-sheet Excel workbook
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param output_path Path to write the `.xlsx` file.
#' @return Invisibly `output_path`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' \donttest{
#' pmo_export_to_excel(p, tempfile(fileext = ".xlsx"))
#' }
#' @export
pmo_export_to_excel <- function(pmo, output_path) {
  wb <- openxlsx::createWorkbook()
  for (cfg in .build_pmo_sheet_configs(pmo)) {
    openxlsx::addWorksheet(wb, cfg$name)
    openxlsx::writeData(wb, cfg$name, cfg$df)
    if (ncol(cfg$df) > 0) {
      openxlsx::setColWidths(wb, cfg$name, cols = seq_len(ncol(cfg$df)),
                             widths = "auto")
    }
  }
  openxlsx::saveWorkbook(wb, output_path, overwrite = TRUE)
  invisible(output_path)
}
