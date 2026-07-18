# PMO builder: assemble name-based components into a complete PMO
#
# Ported from pmotools-python pmo_builder/merge_to_pmo.py. Takes the name-based
# intermediates produced by the other builders and replaces every name with its
# index. All produced ids are 1-based (consistent with read_pmo_raw); the write
# path applies the -1 offset to produce 0-based on-disk values.

#' @keywords internal
.merge_make_lookup <- function(entries, key) {
  nms <- vapply(entries, function(e) as.character(e[[key]]), character(1))
  stats::setNames(seq_along(entries), nms)
}

#' Pop name_key from each entry and set id_key from a (1-based) lookup
#' @keywords internal
.merge_replace_key <- function(target_list, lookup, name_key, id_key) {
  missing <- character(0)
  for (i in seq_along(target_list)) {
    name <- as.character(target_list[[i]][[name_key]])
    target_list[[i]][[name_key]] <- NULL
    if (name %in% names(lookup)) {
      target_list[[i]][[id_key]] <- unname(lookup[[name]])
    } else {
      missing <- c(missing, name)
      target_list[[i]][[id_key]] <- NA_integer_
    }
  }
  list(list = target_list, missing = unique(missing))
}

#' @keywords internal
.merge_generate_pmo_header <- function() {
  ver <- tryCatch(as.character(utils::packageVersion("pmotoolsr")),
                  error = function(e) "1.0.0")
  list(
    pmo_version = pmo_schema_version(),
    creation_date = as.character(Sys.Date()),
    generation_method = list(program_name = "pmotoolsr",
                             program_version = ver)
  )
}

#' @keywords internal
.merge_report_missing <- function(missing) {
  labels <- c(
    projects = "Project names in Specimen Info not in Project Info",
    sequencing = "Sequencing names in Library Sample Info not in Sequencing Info",
    specimen = "Specimen names in Library Sample Info not in Specimen Info",
    panels = "Panel names in Library Sample Info not in Panel Info",
    targets = "Target names in Representative Microhaplotypes not in Target Info",
    bioinfo_runs = "Bioinformatics run names in Detected Microhaplotypes not in Bioinformatic Run Info",
    libs = "Library Sample names in Detected Microhaplotypes not in Library Sample Info",
    rc_bioinfo = "Bioinformatics run names in Read Counts by Stage not in Bioinformatic Run Info",
    rc_libs = "Library Sample names in Read Counts by Stage not in Library Sample Info",
    rc_targets = "Target names in Read Counts by Stage not in Target Info")
  lines <- character(0)
  for (k in names(labels)) {
    if (length(missing[[k]]) > 0) {
      lines <- c(lines, paste0(labels[[k]], ": ",
                               paste(missing[[k]], collapse = ", ")))
    }
  }
  if (length(lines) > 0) {
    stop("The following fields were found in one table and not another:\n",
         paste(lines, collapse = "\n"))
  }
}

#' @keywords internal
.merge_all_have <- function(entries, field) {
  all(vapply(entries, function(e) !is.null(e[[field]]), logical(1)))
}

#' @keywords internal
.merge_replace_names_with_ids <- function(specimen_info, panel_target_info,
                                          mhap_info, project_info,
                                          library_sample_info, sequencing_info,
                                          bioinfo_run_info,
                                          read_counts_by_stage_info) {
  miss <- list(projects = character(0), sequencing = character(0),
               specimen = character(0), panels = character(0),
               targets = character(0), bioinfo_runs = character(0),
               libs = character(0), rc_bioinfo = character(0),
               rc_libs = character(0), rc_targets = character(0))
  warns <- character(0)

  # specimen_info: project_name -> project_id
  if (!is.null(project_info)) {
    if (!.merge_all_have(specimen_info, "project_name")) {
      warns <- c(warns, paste("project_info provided but there are specimens",
                              "missing project_name field"))
    } else {
      r <- .merge_replace_key(specimen_info,
                              .merge_make_lookup(project_info, "project_name"),
                              "project_name", "project_id")
      specimen_info <- r$list
      miss$projects <- r$missing
    }
  }

  spec_lookup <- .merge_make_lookup(specimen_info, "specimen_name")
  panel_lookup <- .merge_make_lookup(panel_target_info$panel_info, "panel_name")
  target_lookup <- .merge_make_lookup(panel_target_info$target_info,
                                      "target_name")

  # library_sample_info: specimen_id, panel_id, sequencing_info_id
  r <- .merge_replace_key(library_sample_info, spec_lookup, "specimen_name",
                          "specimen_id")
  library_sample_info <- r$list
  miss$specimen <- r$missing
  r <- .merge_replace_key(library_sample_info, panel_lookup, "panel_name",
                          "panel_id")
  library_sample_info <- r$list
  miss$panels <- r$missing
  if (!is.null(sequencing_info)) {
    if (!.merge_all_have(library_sample_info, "sequencing_info_name")) {
      warns <- c(warns, paste("sequencing_info provided but there are library",
                              "samples missing sequencing_info_name field"))
    } else {
      r <- .merge_replace_key(
        library_sample_info,
        .merge_make_lookup(sequencing_info, "sequencing_info_name"),
        "sequencing_info_name", "sequencing_info_id")
      library_sample_info <- r$list
      miss$sequencing <- r$missing
    }
  }

  # representative_microhaplotypes: target_name -> target_id
  r <- .merge_replace_key(mhap_info$representative_microhaplotypes$targets,
                          target_lookup, "target_name", "target_id")
  mhap_info$representative_microhaplotypes$targets <- r$list
  miss$targets <- r$missing

  # detected_microhaplotypes: bioinformatics_run_id + per-sample library_sample_id
  if (!is.null(bioinfo_run_info)) {
    if (!.merge_all_have(mhap_info$detected_microhaplotypes,
                         "bioinformatics_run_name")) {
      warns <- c(warns, paste("bioinformatics_run_info provided but there are",
                              "detected microhaplotypes missing",
                              "bioinformatics_run_name field"))
    } else {
      r <- .merge_replace_key(
        mhap_info$detected_microhaplotypes,
        .merge_make_lookup(bioinfo_run_info, "bioinformatics_run_name"),
        "bioinformatics_run_name", "bioinformatics_run_id")
      mhap_info$detected_microhaplotypes <- r$list
      miss$bioinfo_runs <- r$missing
    }
  }
  lib_lookup <- .merge_make_lookup(library_sample_info, "library_sample_name")
  for (i in seq_along(mhap_info$detected_microhaplotypes)) {
    r <- .merge_replace_key(
      mhap_info$detected_microhaplotypes[[i]]$library_samples, lib_lookup,
      "library_sample_name", "library_sample_id")
    mhap_info$detected_microhaplotypes[[i]]$library_samples <- r$list
    miss$libs <- c(miss$libs, r$missing)
  }

  # read_counts_by_stage
  if (!is.null(read_counts_by_stage_info)) {
    if (!.merge_all_have(read_counts_by_stage_info, "bioinformatics_run_name")) {
      if (!is.null(bioinfo_run_info)) {
        warns <- c(warns, paste("bioinformatics_run_info provided but there are",
                                "read counts by stage missing",
                                "bioinformatics_run_name field"))
      }
    } else if (!is.null(bioinfo_run_info)) {
      r <- .merge_replace_key(
        read_counts_by_stage_info,
        .merge_make_lookup(bioinfo_run_info, "bioinformatics_run_name"),
        "bioinformatics_run_name", "bioinformatics_run_id")
      read_counts_by_stage_info <- r$list
      miss$rc_bioinfo <- r$missing
    }
    for (i in seq_along(read_counts_by_stage_info)) {
      r <- .merge_replace_key(
        read_counts_by_stage_info[[i]]$read_counts_by_library_sample_by_stage,
        lib_lookup, "library_sample_name", "library_sample_id")
      read_counts_by_stage_info[[i]]$read_counts_by_library_sample_by_stage <-
        r$list
      miss$rc_libs <- c(miss$rc_libs, r$missing)
      samples <- read_counts_by_stage_info[[i]]$
        read_counts_by_library_sample_by_stage
      for (j in seq_along(samples)) {
        le <- samples[[j]]
        if (!is.null(le$read_counts_for_targets)) {
          for (k in seq_along(le$read_counts_for_targets)) {
            tname <- le$read_counts_for_targets[[k]]$target_name
            le$read_counts_for_targets[[k]]$target_name <- NULL
            if (!is.null(tname)) {
              if (as.character(tname) %in% names(target_lookup)) {
                le$read_counts_for_targets[[k]]$target_id <-
                  unname(target_lookup[[as.character(tname)]])
              } else {
                miss$rc_targets <- c(miss$rc_targets, as.character(tname))
              }
            }
          }
          samples[[j]] <- le
        }
      }
      read_counts_by_stage_info[[i]]$read_counts_by_library_sample_by_stage <-
        samples
    }
  }

  if (length(warns) > 0) {
    stop("The following warnings were encountered during merging:\n",
         paste(warns, collapse = "\n"))
  }
  .merge_report_missing(miss)

  list(specimen_info = specimen_info, library_sample_info = library_sample_info,
       panel_target_info = panel_target_info, mhap_info = mhap_info,
       read_counts_by_stage_info = read_counts_by_stage_info)
}

#' Merge name-based PMO components into a complete PMO
#'
#' Assembles the outputs of the other builders into a full PMO, replacing every
#' name reference with its 1-based index. If `specimen_info`/`library_sample_info`
#' are omitted they are derived from the detected microhaplotypes.
#'
#' @param mhap_info List with `representative_microhaplotypes` and
#'   `detected_microhaplotypes` (from [pmo_mhap_table_to_pmo()]).
#' @param panel_target_info List with `panel_info` and `target_info` (and
#'   optionally `targeted_genomes`) from [pmo_panel_info_table_to_pmo()].
#' @param specimen_info,library_sample_info Optional name-based metadata lists
#'   (from [pmo_specimen_info_table_to_pmo()] /
#'   [pmo_library_sample_info_table_to_pmo()]).
#' @param sequencing_info,bioinfo_method_info,bioinfo_run_info,project_info
#'   Optional component lists.
#' @param read_counts_by_stage_info Optional list from
#'   [pmo_read_count_by_stage_table_to_pmo()].
#' @return A complete PMO as a raw nested list (1-based ids). Write with
#'   [write_pmo_raw()], convert with [pmo_list_to_r6()], or validate with
#'   [pmo_validate()].
#' @examples
#' calls <- data.frame(
#'   library_sample_name = c("S1", "S2"), target_name = c("t1", "t1"),
#'   seq = c("ACGT", "ACGA"), reads = c(120, 95))
#' mhaps <- pmo_mhap_table_to_pmo(calls)
#' primers <- data.frame(target_name = "t1", fwd_primer = "AAAA",
#'                       rev_primer = "TTTT")
#' panel <- pmo_panel_info_table_to_pmo(primers, "demo_panel")
#' pmo <- pmo_merge_to_pmo(mhap_info = mhaps, panel_target_info = panel)
#' pmo_validate(pmo)
#' @export
pmo_merge_to_pmo <- function(mhap_info, panel_target_info, specimen_info = NULL,
                             library_sample_info = NULL, sequencing_info = NULL,
                             bioinfo_method_info = NULL, bioinfo_run_info = NULL,
                             project_info = NULL,
                             read_counts_by_stage_info = NULL) {
  missing_fields <- character(0)
  if (is.null(panel_target_info$panel_info)) {
    missing_fields <- c(missing_fields, "panel_info")
  }
  if (is.null(panel_target_info$target_info)) {
    missing_fields <- c(missing_fields, "target_info")
  }
  if (is.null(mhap_info$representative_microhaplotypes)) {
    missing_fields <- c(missing_fields, "representative_microhaplotypes")
  }
  if (is.null(mhap_info$detected_microhaplotypes)) {
    missing_fields <- c(missing_fields, "detected_microhaplotypes")
  }
  if (length(missing_fields) > 0) {
    stop("Missing required fields for panel_target_info or mhap_info: ",
         paste(missing_fields, collapse = ", "))
  }
  if (!is.null(bioinfo_run_info) && is.null(bioinfo_method_info)) {
    stop("bioinfo_method_info must be provided if bioinfo_run_info is provided")
  }

  panel_name <- panel_target_info$panel_info[[1]]$panel_name

  if (!is.null(specimen_info) && is.null(library_sample_info)) {
    gen <- pmo_minimum_library_specimen_from_mhap_table(
      mhap_info$detected_microhaplotypes, panel_name)
    library_sample_info <- gen$library_sample_info
    lib_names <- vapply(library_sample_info,
                        function(x) x$library_sample_name, character(1))
    spec_names <- vapply(specimen_info, function(x) x$specimen_name,
                         character(1))
    missing_in_specimen <- setdiff(lib_names, spec_names)
    missing_in_library <- setdiff(spec_names, lib_names)
    for (nm in missing_in_specimen) {
      specimen_info[[length(specimen_info) + 1L]] <- list(specimen_name = nm)
    }
    if (length(missing_in_specimen) > 0) {
      warning("library_sample_names found in the detected_microhaplotypes that ",
              "don't have corresponding supplied specimen_names: ",
              paste(sort(missing_in_specimen), collapse = ", "),
              ", will be added to specimen_info with no meta")
    }
    if (length(missing_in_library) > 0) {
      warning("specimen_name were supplied that don't have corresponding ",
              "library_sample_names in detected_microhaplotypes: ",
              paste(sort(missing_in_library), collapse = ", "))
    }
  }
  if (is.null(specimen_info) && is.null(library_sample_info)) {
    if (length(panel_target_info$panel_info) > 1) {
      stop("If multiple panels are included, specimen_info and ",
           "library_sample_info must also be provided. Panels found: ",
           length(panel_target_info$panel_info))
    }
    gen <- pmo_minimum_library_specimen_from_mhap_table(
      mhap_info$detected_microhaplotypes, panel_name)
    specimen_info <- gen$specimen_info
    library_sample_info <- gen$library_sample_info
  } else if (is.null(specimen_info)) {
    for (i in seq_along(library_sample_info)) {
      library_sample_info[[i]]$specimen_name <-
        library_sample_info[[i]]$library_sample_name
    }
    specimen_info <- lapply(library_sample_info,
                            function(ls) list(specimen_name =
                                                ls$library_sample_name))
  }

  res <- .merge_replace_names_with_ids(
    specimen_info, panel_target_info, mhap_info, project_info,
    library_sample_info, sequencing_info, bioinfo_run_info,
    read_counts_by_stage_info)

  pmo <- list(pmo_header = .merge_generate_pmo_header(),
              library_sample_info = res$library_sample_info,
              specimen_info = res$specimen_info)
  for (k in names(res$panel_target_info)) pmo[[k]] <- res$panel_target_info[[k]]
  for (k in names(res$mhap_info)) pmo[[k]] <- res$mhap_info[[k]]
  if (!is.null(sequencing_info) && length(sequencing_info) > 0) {
    pmo$sequencing_info <- sequencing_info
  }
  if (!is.null(bioinfo_method_info) && length(bioinfo_method_info) > 0) {
    pmo$bioinformatics_methods_info <- bioinfo_method_info
  }
  if (!is.null(bioinfo_run_info) && length(bioinfo_run_info) > 0) {
    pmo$bioinformatics_run_info <- bioinfo_run_info
  }
  if (!is.null(project_info) && length(project_info) > 0) {
    pmo$project_info <- project_info
  }
  if (!is.null(res$read_counts_by_stage_info)) {
    pmo$read_counts_by_stage <- res$read_counts_by_stage_info
  }
  pmo
}
