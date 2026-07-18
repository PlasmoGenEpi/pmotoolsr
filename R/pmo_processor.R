# PMO processor utilities
#
# Ported from pmotools-python's PMOProcessor (src/pmotools/pmo_engine/pmo_processor.py).
#
# IMPORTANT indexing note: the Python implementation operates on PMO dicts with
# 0-based id/index fields. In pmotoolsr the same data is held 1-based in memory
# (read_pmo / read_pmo_raw add +1 to every `*_id` field and `panel_targets`).
# Because both R list indexing AND the stored id fields are 1-based, expressions
# like `specimen_info[[ library_sample$specimen_id ]]` port directly from Python.

#' Coerce a PMO to a plain nested list
#'
#' Internal helper that accepts either a [PortableMicrohaplotypeObject] R6
#' instance or an already-parsed PMO list (as returned by [read_pmo_raw()]) and
#' returns a plain nested list with 1-based id fields.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or a PMO list.
#' @return A nested list representation of the PMO.
#' @keywords internal
.pmo_as_list <- function(pmo) {
  if (inherits(pmo, "PortableMicrohaplotypeObject")) return(pmo$to_list())
  if (is.list(pmo)) return(pmo)
  stop("`pmo` must be a PortableMicrohaplotypeObject or a parsed PMO list")
}

#' @keywords internal
.named_index <- function(names_vec) {
  v <- seq_along(names_vec)
  names(v) <- names_vec
  v
}

#' Test whether an optional PMO section is present and non-empty
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param section The name of a top-level PMO section.
#' @return `TRUE` if the section is present and contains at least one element.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_has_section(p, "sequencing_info")
#' @export
pmo_has_section <- function(pmo, section) {
  p <- .pmo_as_list(pmo)
  !is.null(p[[section]]) && length(p[[section]]) > 0
}

#' @keywords internal
.require_section <- function(p, section) {
  if (is.null(p[[section]]) || length(p[[section]]) == 0) {
    stop("input PMO does not contain '", section,
         "'; this is an optional section that is absent from this PMO")
  }
  invisible(TRUE)
}

# ---------------------------------------------------------------------------
# Name -> index lookups (return a named integer vector, 1-based)
# ---------------------------------------------------------------------------

#' Build a name-to-index lookup for PMO entities
#'
#' These helpers return a named integer vector mapping each entity name to its
#' 1-based position within the corresponding PMO section.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @return A named integer vector of 1-based indices keyed by name.
#' @rdname pmo_index_key
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_index_key_target_names(p))
#' @export
pmo_index_key_specimen_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  .named_index(vapply(p$specimen_info, function(x) x$specimen_name, character(1)))
}

#' @rdname pmo_index_key
#' @export
pmo_index_key_library_sample_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  .named_index(vapply(p$library_sample_info, function(x) x$library_sample_name, character(1)))
}

#' @rdname pmo_index_key
#' @export
pmo_index_key_target_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  .named_index(vapply(p$target_info, function(x) x$target_name, character(1)))
}

#' @rdname pmo_index_key
#' @export
pmo_index_key_panel_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  .named_index(vapply(p$panel_info, function(x) x$panel_name, character(1)))
}

#' @rdname pmo_index_key
#' @export
pmo_index_key_bioinformatics_run_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  .require_section(p, "bioinformatics_run_info")
  .named_index(vapply(p$bioinformatics_run_info, function(x) x$bioinformatics_run_name, character(1)))
}

#' Build a target-name to representative-microhaplotype-index lookup
#'
#' Returns a named integer vector mapping each target name to its 1-based index
#' within `representative_microhaplotypes$targets` (which may be ordered
#' differently from, and may not cover all of, `target_info`).
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @return A named integer vector of 1-based indices keyed by target name.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_index_key_target_in_representative_microhaplotypes(p))
#' @export
pmo_index_key_target_in_representative_microhaplotypes <- function(pmo) {
  p <- .pmo_as_list(pmo)
  targets <- p$representative_microhaplotypes$targets
  target_info <- p$target_info
  nm <- vapply(targets, function(t) target_info[[t$target_id]]$target_name, character(1))
  .named_index(nm)
}

# ---------------------------------------------------------------------------
# Name getters (in order of appearance, plus sorted variants)
# ---------------------------------------------------------------------------

#' Get entity names from a PMO
#'
#' Return the names of PMO entities in the order they appear. Each function has
#' a `pmo_get_sorted_*` companion returning the names sorted alphabetically.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @return A character vector of names.
#' @examples
#' pmo <- read_pmo(
#'   system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_get_specimen_names(pmo))
#' pmo_get_sorted_target_names(pmo)[1:3]
#' @rdname pmo_get_names
#' @export
pmo_get_specimen_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  vapply(p$specimen_info, function(x) x$specimen_name, character(1))
}

#' @rdname pmo_get_names
#' @export
pmo_get_sorted_specimen_names <- function(pmo) sort(pmo_get_specimen_names(pmo))

#' @rdname pmo_get_names
#' @export
pmo_get_library_sample_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  vapply(p$library_sample_info, function(x) x$library_sample_name, character(1))
}

#' @rdname pmo_get_names
#' @export
pmo_get_sorted_library_sample_names <- function(pmo) sort(pmo_get_library_sample_names(pmo))

#' @rdname pmo_get_names
#' @export
pmo_get_target_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  vapply(p$target_info, function(x) x$target_name, character(1))
}

#' @rdname pmo_get_names
#' @export
pmo_get_sorted_target_names <- function(pmo) sort(pmo_get_target_names(pmo))

#' @rdname pmo_get_names
#' @export
pmo_get_panel_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  vapply(p$panel_info, function(x) x$panel_name, character(1))
}

#' @rdname pmo_get_names
#' @export
pmo_get_sorted_panel_names <- function(pmo) sort(pmo_get_panel_names(pmo))

#' @rdname pmo_get_names
#' @export
pmo_get_bioinformatics_run_names <- function(pmo) {
  p <- .pmo_as_list(pmo)
  .require_section(p, "bioinformatics_run_info")
  vapply(p$bioinformatics_run_info, function(x) x$bioinformatics_run_name, character(1))
}

#' @rdname pmo_get_names
#' @export
pmo_get_sorted_bioinformatics_run_names <- function(pmo) sort(pmo_get_bioinformatics_run_names(pmo))

# ---------------------------------------------------------------------------
# Name -> index resolvers (return 1-based indices in input order)
# ---------------------------------------------------------------------------

#' @keywords internal
.resolve_names <- function(key, names_vec, what) {
  missing <- setdiff(names_vec, names(key))
  if (length(missing) > 0) {
    stop(what, " not found in PMO: ", paste(missing, collapse = ", "))
  }
  unname(key[names_vec])
}

#' Resolve entity names to their 1-based PMO indices
#'
#' Convert a vector of names into the corresponding 1-based indices, returned in
#' the same order as the input. Unknown names raise an error.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param specimen_names,library_sample_names,target_names,panel_names,bioinformatics_run_names
#'   A character vector of names to resolve.
#' @return An integer vector of 1-based indices.
#' @rdname pmo_index_of
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_index_of_specimen_names(p, pmo_get_specimen_names(p)[1:2])
#' @export
pmo_index_of_specimen_names <- function(pmo, specimen_names) {
  .resolve_names(pmo_index_key_specimen_names(pmo), specimen_names, "specimen_name(s)")
}

#' @rdname pmo_index_of
#' @export
pmo_index_of_library_sample_names <- function(pmo, library_sample_names) {
  .resolve_names(pmo_index_key_library_sample_names(pmo), library_sample_names, "library_sample_name(s)")
}

#' @rdname pmo_index_of
#' @export
pmo_index_of_target_names <- function(pmo, target_names) {
  .resolve_names(pmo_index_key_target_names(pmo), target_names, "target_name(s)")
}

#' @rdname pmo_index_of
#' @export
pmo_index_of_panel_names <- function(pmo, panel_names) {
  .resolve_names(pmo_index_key_panel_names(pmo), panel_names, "panel_name(s)")
}

#' @rdname pmo_index_of
#' @export
pmo_index_of_bioinformatics_run_names <- function(pmo, bioinformatics_run_names) {
  .resolve_names(pmo_index_key_bioinformatics_run_names(pmo), bioinformatics_run_names, "bioinformatics_run_name(s)")
}

#' @rdname pmo_index_of
#' @export
pmo_index_of_target_in_representative_microhaplotypes <- function(pmo, target_names) {
  .resolve_names(
    pmo_index_key_target_in_representative_microhaplotypes(pmo),
    target_names, "target_name(s)"
  )
}

# ---------------------------------------------------------------------------
# Relational queries
# ---------------------------------------------------------------------------

#' Get library sample ids for a set of specimen ids
#'
#' For each supplied specimen id, list the 1-based library sample ids whose
#' `specimen_id` matches.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param specimen_ids An integer vector of 1-based specimen ids.
#' @return A named list keyed by specimen id (as character), each element an
#'   integer vector of 1-based library sample ids.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_library_ids_for_specimen_ids(p, seq_along(p$specimen_info))
#' @export
pmo_library_ids_for_specimen_ids <- function(pmo, specimen_ids) {
  p <- .pmo_as_list(pmo)
  specimen_ids <- unique(as.integer(specimen_ids))
  n_spec <- length(p$specimen_info)
  bad <- specimen_ids[specimen_ids > n_spec]
  if (length(bad) > 0) {
    stop(paste0(bad, " id is beyond the length of specimen_info: ", n_spec, collapse = "\n"))
  }
  ret <- list()
  for (lib_id in seq_along(p$library_sample_info)) {
    sid <- p$library_sample_info[[lib_id]]$specimen_id
    if (sid %in% specimen_ids) {
      key <- as.character(sid)
      ret[[key]] <- c(ret[[key]], lib_id)
    }
  }
  ret
}

# ---------------------------------------------------------------------------
# Counting / aggregation (return tibbles)
# ---------------------------------------------------------------------------

# Quiet R CMD check on dplyr non-standard-evaluation column references.
utils::globalVariables(c(
  "target_name", "sample_count", "mhap_id", "count", "freq",
  "target_total", "bioinformatics_run_id"
))

# Composite-key separator unlikely to occur in entity names.
.PMO_KEY_SEP <- "|@@|"

#' @keywords internal
.sum_reads <- function(mhaps) {
  if (is.null(mhaps) || length(mhaps) == 0) return(0)
  sum(vapply(mhaps, function(h) h$reads, numeric(1)))
}

#' Count the number of targets detected per library sample
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param min_reads Minimum summed reads for a target (across its detected
#'   microhaplotypes) for that target to be counted.
#' @return A tibble with columns `bioinformatics_run_id`, `library_sample_name`,
#'   `target_number`. Note: `bioinformatics_run_id` is 1-based; when a detected
#'   set has no run id, a `detected_microhaplotypes_count_idx_<n>` label is used.
#' @examples
#' pmo <- read_pmo(
#'   system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_count_targets_per_library_sample(pmo))
#' @export
pmo_count_targets_per_library_sample <- function(pmo, min_reads = 0) {
  p <- .pmo_as_list(pmo)
  lib_info <- p$library_sample_info
  records <- list()
  detected_count <- 0L
  for (result in p$detected_microhaplotypes) {
    run_id <- if (!is.null(result$bioinformatics_run_id)) {
      result$bioinformatics_run_id
    } else {
      paste0("detected_microhaplotypes_count_idx_", detected_count)
    }
    detected_count <- detected_count + 1L
    for (sample in result$library_samples) {
      sample_name <- lib_info[[sample$library_sample_id]]$library_sample_name
      target_count <- sum(vapply(
        sample$target_results,
        function(tr) .sum_reads(tr$mhaps) >= min_reads,
        logical(1)
      ))
      records[[length(records) + 1L]] <- list(
        bioinformatics_run_id = run_id,
        library_sample_name = sample_name,
        target_number = as.integer(target_count)
      )
    }
  }
  dplyr::bind_rows(records)
}

#' Count the number of library samples a target is detected in
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param min_reads Minimum summed reads for a target to be counted in a sample.
#' @param collapse_across_runs If `TRUE`, sum counts across bioinformatics runs.
#' @return A tibble. If `collapse_across_runs = FALSE`: columns
#'   `bioinformatics_run_id`, `target_name`, `sample_count`. If `TRUE`:
#'   `target_name`, `sample_count`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_count_library_samples_per_target(p, collapse_across_runs = TRUE))
#' @export
pmo_count_library_samples_per_target <- function(pmo, min_reads = 0,
                                                 collapse_across_runs = FALSE) {
  p <- .pmo_as_list(pmo)
  microhap_targets <- p$representative_microhaplotypes$targets
  target_info <- p$target_info
  records <- list()
  detected_count <- 0L
  for (result in p$detected_microhaplotypes) {
    run_id <- if (!is.null(result$bioinformatics_run_id)) {
      result$bioinformatics_run_id
    } else {
      paste0("detected_microhaplotypes_count_idx_", detected_count)
    }
    detected_count <- detected_count + 1L
    counts <- integer(0)
    for (sample in result$library_samples) {
      for (tr in sample$target_results) {
        if (.sum_reads(tr$mhaps) >= min_reads) {
          target_id <- microhap_targets[[tr$mhaps_target_id]]$target_id
          tname <- target_info[[target_id]]$target_name
          prev <- counts[tname]
          counts[tname] <- (if (is.na(prev)) 0L else prev) + 1L
        }
      }
    }
    for (tname in names(counts)) {
      records[[length(records) + 1L]] <- list(
        bioinformatics_run_id = run_id,
        target_name = tname,
        sample_count = as.integer(counts[[tname]])
      )
    }
  }
  ret <- dplyr::bind_rows(records)
  if (collapse_across_runs) {
    return(
      ret |>
        dplyr::group_by(target_name) |>
        dplyr::summarise(sample_count = sum(sample_count), .groups = "drop") |>
        dplyr::arrange(target_name)
    )
  }
  ret |> dplyr::arrange(bioinformatics_run_id, target_name)
}

#' Count the number of unique targets in each panel
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @return A tibble with columns `panel_name`, `panel_target_count`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_count_targets_per_panel(p)
#' @export
pmo_count_targets_per_panel <- function(pmo) {
  p <- .pmo_as_list(pmo)
  panel_names <- character(0)
  counts <- integer(0)
  for (panel in p$panel_info) {
    panel_targets <- integer(0)
    for (reaction in panel$reactions) {
      panel_targets <- c(panel_targets, unlist(reaction$panel_targets))
    }
    panel_names <- c(panel_names, panel$panel_name)
    counts <- c(counts, length(unique(panel_targets)))
  }
  tibble::tibble(
    panel_name = panel_names,
    panel_target_count = as.integer(counts)
  )
}

#' Count how many specimens carry each metadata field
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @return A tibble with columns `field`, `present_in_specimens_count`,
#'   `total_specimen_count`.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_count_specimen_per_meta_fields(p)
#' @export
pmo_count_specimen_per_meta_fields <- function(pmo) {
  p <- .pmo_as_list(pmo)
  field_counts <- integer(0)
  for (specimen in p$specimen_info) {
    for (f in names(specimen)) {
      prev <- field_counts[f]
      field_counts[f] <- (if (is.na(prev)) 0L else prev) + 1L
    }
  }
  tibble::tibble(
    field = names(field_counts),
    present_in_specimens_count = as.integer(field_counts),
    total_specimen_count = length(p$specimen_info)
  )
}

#' @keywords internal
.specimen_field_value <- function(specimen, field) {
  v <- specimen[[field]]
  if (is.null(v)) {
    "NA"
  } else if (length(v) == 1) {
    as.character(v)
  } else {
    paste(as.character(v), collapse = ",")
  }
}

#' Count specimens grouped by combinations of metadata field values
#'
#' Specimens missing a requested field are recorded as `"NA"` for that field.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param meta_fields A character vector of specimen metadata fields to group by.
#' @return A tibble with one column per requested field plus `specimens_count`,
#'   `specimens_freq`, and `total_specimen_count`, sorted by the fields.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_count_specimen_by_field_value(p, "collection_country")
#' @export
pmo_count_specimen_by_field_value <- function(pmo, meta_fields) {
  p <- .pmo_as_list(pmo)
  total <- length(p$specimen_info)
  groups <- list()
  for (specimen in p$specimen_info) {
    vals <- vapply(
      meta_fields, function(f) .specimen_field_value(specimen, f), character(1)
    )
    key <- paste(vals, collapse = .PMO_KEY_SEP)
    if (is.null(groups[[key]])) {
      rec <- as.list(stats::setNames(vals, meta_fields))
      rec[["specimens_count"]] <- 0L
      groups[[key]] <- rec
    }
    groups[[key]][["specimens_count"]] <-
      groups[[key]][["specimens_count"]] + 1L
  }
  rows <- lapply(groups, function(rec) {
    cnt <- rec[["specimens_count"]]
    rec[["specimens_freq"]] <- cnt / total
    rec[["total_specimen_count"]] <- total
    rec
  })
  ret <- dplyr::bind_rows(rows)
  ret |> dplyr::arrange(dplyr::across(dplyr::all_of(meta_fields)))
}

# ---------------------------------------------------------------------------
# Allele counts / frequencies
# ---------------------------------------------------------------------------

#' Extract allele (microhaplotype) counts and frequencies
#'
#' Tallies, per bioinformatics run and target, how many samples carry each
#' representative microhaplotype, and the within-target frequency. This is the
#' table consumed by downstream tools such as dcifer and moire.
#'
#' Requires each detected-microhaplotypes set to have a `bioinformatics_run_id`;
#' an informative error is raised if that optional field is absent.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param bioinformatics_run_ids Optional integer vector of 1-based run ids to
#'   include.
#' @param library_sample_names Optional character vector of library sample names
#'   to include.
#' @param target_names Optional character vector of target names to include.
#' @param collapse_across_runs If `TRUE`, collapse counts/frequencies across
#'   runs.
#' @return A tibble. If `collapse_across_runs = FALSE`: columns
#'   `bioinformatics_run_id`, `target_name`, `mhap_id`, `count`, `freq`,
#'   `total_haps_per_target`. If `TRUE`: `target_name`, `mhap_id`, `count`,
#'   `freq`, `target_total`. Note: `mhap_id` and `bioinformatics_run_id` are
#'   1-based.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' head(pmo_extract_allele_counts_freq(p))
#' @export
pmo_extract_allele_counts_freq <- function(pmo,
                                           bioinformatics_run_ids = NULL,
                                           library_sample_names = NULL,
                                           target_names = NULL,
                                           collapse_across_runs = FALSE) {
  p <- .pmo_as_list(pmo)
  lib_info <- p$library_sample_info
  rep_targets <- p$representative_microhaplotypes$targets
  target_info <- p$target_info
  counts <- list()
  totals <- list()
  for (data_for_run in p$detected_microhaplotypes) {
    if (is.null(data_for_run$bioinformatics_run_id)) {
      stop("a detected_microhaplotypes set has no bioinformatics_run_id; ",
           "this optional field is required for allele extraction")
    }
    bioid <- data_for_run$bioinformatics_run_id
    if (!is.null(bioinformatics_run_ids) &&
        !(bioid %in% bioinformatics_run_ids)) {
      next
    }
    for (sample_data in data_for_run$library_samples) {
      sample_name <-
        lib_info[[sample_data$library_sample_id]]$library_sample_name
      if (!is.null(library_sample_names) &&
          !(sample_name %in% library_sample_names)) {
        next
      }
      for (target_data in sample_data$target_results) {
        target_id <- rep_targets[[target_data$mhaps_target_id]]$target_id
        target <- target_info[[target_id]]$target_name
        if (!is.null(target_names) && !(target %in% target_names)) {
          next
        }
        for (microhapid in target_data$mhaps) {
          mhap_id <- microhapid$mhap_id
          tk <- paste(bioid, target, sep = .PMO_KEY_SEP)
          ck <- paste(tk, mhap_id, sep = .PMO_KEY_SEP)
          counts[[ck]] <- (counts[[ck]] %||% 0L) + 1L
          totals[[tk]] <- (totals[[tk]] %||% 0L) + 1L
        }
      }
    }
  }
  rows <- list()
  for (ck in names(counts)) {
    parts <- strsplit(ck, .PMO_KEY_SEP, fixed = TRUE)[[1]]
    bioid <- as.integer(parts[1])
    target <- parts[2]
    mid <- as.integer(parts[3])
    total <- totals[[paste(parts[1], parts[2], sep = .PMO_KEY_SEP)]]
    cnt <- counts[[ck]]
    rows[[length(rows) + 1L]] <- list(
      bioinformatics_run_id = bioid,
      target_name = target,
      mhap_id = mid,
      count = as.integer(cnt),
      freq = cnt / total,
      total_haps_per_target = as.integer(total)
    )
  }
  ret <- dplyr::bind_rows(rows)
  if (collapse_across_runs) {
    collapsed <- ret |>
      dplyr::group_by(target_name, mhap_id) |>
      dplyr::summarise(count = sum(count), .groups = "drop")
    target_totals <- collapsed |>
      dplyr::group_by(target_name) |>
      dplyr::summarise(target_total = sum(count), .groups = "drop")
    return(
      collapsed |>
        dplyr::left_join(target_totals, by = "target_name") |>
        dplyr::mutate(freq = count / target_total) |>
        dplyr::arrange(target_name, mhap_id) |>
        dplyr::select(target_name, mhap_id, count, freq, target_total)
    )
  }
  ret |> dplyr::arrange(bioinformatics_run_id, target_name, mhap_id)
}

# ---------------------------------------------------------------------------
# Filters that return a new (sub)PMO as a raw nested list
# ---------------------------------------------------------------------------
#
# These return a plain PMO list with 1-based ids, which can be written with
# write_pmo_raw(). All cross-referencing indices are remapped to the filtered
# positions. The input is never modified (work happens on a fresh to_list()
# copy).

#' @keywords internal
.copy_optional_sections <- function(src, dst, sections) {
  for (s in sections) {
    if (!is.null(src[[s]])) dst[[s]] <- src[[s]]
  }
  dst
}

#' Filter a PMO down to selected library samples
#'
#' Returns a new PMO (as a raw nested list) containing only the supplied library
#' samples, their parent specimens, and their detected microhaplotypes and read
#' counts, with all ids remapped to the new positions.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param library_sample_ids Integer vector of 1-based library sample ids.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' sub <- pmo_filter_by_library_sample_ids(p, 1L)
#' length(sub$library_sample_info)
#' @export
pmo_filter_by_library_sample_ids <- function(pmo, library_sample_ids) {
  p <- .pmo_as_list(pmo)
  library_sample_ids <- sort(unique(as.integer(library_sample_ids)))
  n_lib <- length(p$library_sample_info)
  bad <- library_sample_ids[library_sample_ids > n_lib | library_sample_ids < 1]
  if (length(bad) > 0) {
    stop(paste0(bad, " id is beyond the length of library_sample_info: ", n_lib,
                collapse = "\n"))
  }

  out <- list(
    pmo_header = p$pmo_header,
    panel_info = p$panel_info,
    target_info = p$target_info,
    representative_microhaplotypes = p$representative_microhaplotypes,
    specimen_info = list(),
    library_sample_info = list(),
    detected_microhaplotypes = list()
  )
  out <- .copy_optional_sections(p, out, c(
    "sequencing_info", "project_info", "bioinformatics_methods_info",
    "bioinformatics_run_info", "targeted_genomes"
  ))
  has_read_counts <- !is.null(p$read_counts_by_stage)
  if (has_read_counts) out$read_counts_by_stage <- list()

  # specimen_info: gather parent specimen ids (deterministic order)
  specimen_id_index_key <- integer(0)
  for (lib_id in library_sample_ids) {
    sid <- p$library_sample_info[[lib_id]]$specimen_id
    key <- as.character(sid)
    if (!(key %in% names(specimen_id_index_key))) {
      out$specimen_info[[length(out$specimen_info) + 1L]] <-
        p$specimen_info[[sid]]
      specimen_id_index_key[key] <- length(out$specimen_info)
    }
  }

  # library_sample_info: remap specimen_id
  library_id_index_key <- integer(0)
  for (lib_id in library_sample_ids) {
    lib <- p$library_sample_info[[lib_id]]
    lib$specimen_id <- specimen_id_index_key[[as.character(lib$specimen_id)]]
    out$library_sample_info[[length(out$library_sample_info) + 1L]] <- lib
    library_id_index_key[as.character(lib_id)] <-
      length(out$library_sample_info)
  }

  # detected_microhaplotypes: keep selected samples, remap library_sample_id
  for (dm in p$detected_microhaplotypes) {
    new_dm <- list(library_samples = list())
    if (!is.null(dm$bioinformatics_run_id)) {
      new_dm$bioinformatics_run_id <- dm$bioinformatics_run_id
    }
    for (sample in dm$library_samples) {
      if (sample$library_sample_id %in% library_sample_ids) {
        sample$library_sample_id <-
          library_id_index_key[[as.character(sample$library_sample_id)]]
        new_dm$library_samples[[length(new_dm$library_samples) + 1L]] <- sample
      }
    }
    out$detected_microhaplotypes[[length(out$detected_microhaplotypes) + 1L]] <-
      new_dm
  }

  # read_counts_by_stage: keep selected samples, remap library_sample_id
  if (has_read_counts) {
    for (rc in p$read_counts_by_stage) {
      new_rc <- list(read_counts_by_library_sample_by_stage = list())
      if (!is.null(rc$bioinformatics_run_id)) {
        new_rc$bioinformatics_run_id <- rc$bioinformatics_run_id
      }
      for (sample in rc$read_counts_by_library_sample_by_stage) {
        if (sample$library_sample_id %in% library_sample_ids) {
          sample$library_sample_id <-
            library_id_index_key[[as.character(sample$library_sample_id)]]
          idx <- length(new_rc$read_counts_by_library_sample_by_stage) + 1L
          new_rc$read_counts_by_library_sample_by_stage[[idx]] <- sample
        }
      }
      out$read_counts_by_stage[[length(out$read_counts_by_stage) + 1L]] <- new_rc
    }
  }
  out
}

#' Filter a PMO down to selected library samples by name
#'
#' @inheritParams pmo_filter_by_library_sample_ids
#' @param library_sample_names Character vector of library sample names.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' nm <- pmo_get_library_sample_names(p)[1]
#' sub <- pmo_filter_by_library_sample_names(p, nm)
#' @export
pmo_filter_by_library_sample_names <- function(pmo, library_sample_names) {
  ids <- pmo_index_of_library_sample_names(pmo, library_sample_names)
  pmo_filter_by_library_sample_ids(pmo, ids)
}

#' Filter a PMO down to selected specimens
#'
#' @inheritParams pmo_filter_by_library_sample_ids
#' @param specimen_ids Integer vector of 1-based specimen ids.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' sub <- pmo_filter_by_specimen_ids(p, 1L)
#' @export
pmo_filter_by_specimen_ids <- function(pmo, specimen_ids) {
  p <- .pmo_as_list(pmo)
  specimen_ids <- unique(as.integer(specimen_ids))
  n_spec <- length(p$specimen_info)
  bad <- specimen_ids[specimen_ids > n_spec | specimen_ids < 1]
  if (length(bad) > 0) {
    stop(paste0(bad, " id is beyond the length of specimen_info: ", n_spec,
                collapse = "\n"))
  }
  lib_ids_for_spec <- pmo_library_ids_for_specimen_ids(p, specimen_ids)
  all_lib_ids <- sort(unique(unlist(lib_ids_for_spec, use.names = FALSE)))
  pmo_filter_by_library_sample_ids(p, all_lib_ids)
}

#' Filter a PMO down to selected specimens by name
#'
#' @inheritParams pmo_filter_by_library_sample_ids
#' @param specimen_names Character vector of specimen names.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' nm <- pmo_get_specimen_names(p)[1]
#' sub <- pmo_filter_by_specimen_names(p, nm)
#' @export
pmo_filter_by_specimen_names <- function(pmo, specimen_names) {
  ids <- pmo_index_of_specimen_names(pmo, specimen_names)
  pmo_filter_by_specimen_ids(pmo, ids)
}

#' Filter a PMO down to selected targets
#'
#' Returns a new PMO (as a raw nested list) restricted to the supplied targets,
#' remapping `target_info`, `panel_info`, `representative_microhaplotypes`,
#' `detected_microhaplotypes`, and `read_counts_by_stage` to the new target
#' positions.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param target_ids Integer vector of 1-based target ids.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' sub <- pmo_filter_by_target_ids(p, 1:3)
#' @export
pmo_filter_by_target_ids <- function(pmo, target_ids) {
  p <- .pmo_as_list(pmo)
  target_ids <- sort(unique(as.integer(target_ids)))
  n_target <- length(p$target_info)
  rep_targets <- p$representative_microhaplotypes$targets
  rep_target_ids <- vapply(rep_targets, function(t) t$target_id, numeric(1))

  warnings <- character(0)
  oob <- target_ids[target_ids > n_target | target_ids < 1]
  if (length(oob) > 0) {
    warnings <- c(warnings,
      paste0(oob, " out of range of target_info, length is ", n_target))
  }
  not_in_rep <- target_ids[!(target_ids %in% rep_target_ids)]
  if (length(not_in_rep) > 0) {
    warnings <- c(warnings,
      paste0(not_in_rep, " not in representative_microhaplotypes"))
  }
  if (length(warnings) > 0) stop(paste(warnings, collapse = "\n"))

  out <- list(
    pmo_header = p$pmo_header,
    specimen_info = p$specimen_info,
    library_sample_info = p$library_sample_info,
    target_info = list()
  )
  out <- .copy_optional_sections(p, out, c(
    "sequencing_info", "project_info", "bioinformatics_methods_info",
    "bioinformatics_run_info", "targeted_genomes"
  ))

  # target_info: old 1-based id -> new 1-based index
  target_info_index_key <- integer(0)
  for (tid in seq_along(p$target_info)) {
    if (tid %in% target_ids) {
      out$target_info[[length(out$target_info) + 1L]] <- p$target_info[[tid]]
      target_info_index_key[as.character(tid)] <- length(out$target_info)
    }
  }

  # panel_info: keep only reactions retaining at least one target
  out$panel_info <- list()
  for (panel in p$panel_info) {
    new_panel <- list(panel_name = panel$panel_name, reactions = list())
    for (reaction in panel$reactions) {
      kept <- integer(0)
      for (pt in unlist(reaction$panel_targets)) {
        if (pt %in% target_ids) {
          kept <- c(kept, target_info_index_key[[as.character(pt)]])
        }
      }
      if (length(kept) > 0) {
        new_panel$reactions[[length(new_panel$reactions) + 1L]] <- list(
          reaction_name = reaction$reaction_name,
          panel_targets = kept
        )
      }
    }
    out$panel_info[[length(out$panel_info) + 1L]] <- new_panel
  }

  # representative_microhaplotypes: old mhaps_target_id -> new index
  out$representative_microhaplotypes <- list(targets = list())
  mhaps_target_id_new_key <- integer(0)
  for (mi_index in seq_along(rep_targets)) {
    mi <- rep_targets[[mi_index]]
    if (mi$target_id %in% target_ids) {
      mi$target_id <- target_info_index_key[[as.character(mi$target_id)]]
      idx <- length(out$representative_microhaplotypes$targets) + 1L
      out$representative_microhaplotypes$targets[[idx]] <- mi
      mhaps_target_id_new_key[as.character(mi_index)] <- idx
    }
  }

  # detected_microhaplotypes: remap mhaps_target_id, drop targets not kept
  out$detected_microhaplotypes <- list()
  for (dm in p$detected_microhaplotypes) {
    new_dm <- list(library_samples = list())
    if (!is.null(dm$bioinformatics_run_id)) {
      new_dm$bioinformatics_run_id <- dm$bioinformatics_run_id
    }
    for (sample in dm$library_samples) {
      new_sample <- list(
        library_sample_id = sample$library_sample_id,
        target_results = list()
      )
      for (tr in sample$target_results) {
        key <- as.character(tr$mhaps_target_id)
        if (key %in% names(mhaps_target_id_new_key)) {
          tr$mhaps_target_id <- mhaps_target_id_new_key[[key]]
          new_sample$target_results[[length(new_sample$target_results) + 1L]] <-
            tr
        }
      }
      new_dm$library_samples[[length(new_dm$library_samples) + 1L]] <- new_sample
    }
    out$detected_microhaplotypes[[length(out$detected_microhaplotypes) + 1L]] <-
      new_dm
  }

  # read_counts_by_stage: remap per-target read counts
  if (!is.null(p$read_counts_by_stage)) {
    out$read_counts_by_stage <- list()
    for (rc in p$read_counts_by_stage) {
      new_rc <- list(read_counts_by_library_sample_by_stage = list())
      if (!is.null(rc$bioinformatics_run_id)) {
        new_rc$bioinformatics_run_id <- rc$bioinformatics_run_id
      }
      for (sample in rc$read_counts_by_library_sample_by_stage) {
        new_sample <- list(
          library_sample_id = sample$library_sample_id,
          total_raw_count = sample$total_raw_count
        )
        if (!is.null(sample$read_counts_for_targets)) {
          new_sample$read_counts_for_targets <- list()
          for (tr in sample$read_counts_for_targets) {
            if (tr$target_id %in% target_ids) {
              tr$target_id <- target_info_index_key[[as.character(tr$target_id)]]
              idx <- length(new_sample$read_counts_for_targets) + 1L
              new_sample$read_counts_for_targets[[idx]] <- tr
            }
          }
        }
        idx <- length(new_rc$read_counts_by_library_sample_by_stage) + 1L
        new_rc$read_counts_by_library_sample_by_stage[[idx]] <- new_sample
      }
      out$read_counts_by_stage[[length(out$read_counts_by_stage) + 1L]] <- new_rc
    }
  }
  out
}

#' Filter a PMO down to selected targets by name
#'
#' @inheritParams pmo_filter_by_target_ids
#' @param target_names Character vector of target names.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' pmo <- read_pmo(
#'   system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
#' keep <- pmo_get_target_names(pmo)[1:3]
#' sub <- pmo_filter_by_target_names(pmo, keep)
#' length(sub$target_info)
#' @export
pmo_filter_by_target_names <- function(pmo, target_names) {
  ids <- pmo_index_of_target_names(pmo, target_names)
  pmo_filter_by_target_ids(pmo, ids)
}

# ---------------------------------------------------------------------------
# Metadata-grouping extraction and read filtering
# ---------------------------------------------------------------------------

#' Parse a metadata-grouping specification
#'
#' Accepts either a path to a tab-delimited file with columns `field`, `values`
#' (comma-separated) and an optional `group`, or an inline string of the form
#' `field1=v1,v2:field2=v3;field1=v4` where groups are separated by `;`, fields
#' within a group by `:`, field/values by `=`, and values by `,`.
#'
#' @param meta_fields_values File path or inline specification string.
#' @return A named list keyed by group, each a named list of
#'   `field -> character vector of values`.
#' @keywords internal
.parse_meta_groupings <- function(meta_fields_values) {
  if (length(meta_fields_values) == 1 && file.exists(meta_fields_values)) {
    tab <- utils::read.delim(meta_fields_values, sep = "\t",
                             stringsAsFactors = FALSE, check.names = FALSE)
    if (!all(c("field", "values") %in% names(tab))) {
      stop(meta_fields_values, " doesn't have columns field and values, has ",
           paste(names(tab), collapse = ","))
    }
    selected <- list()
    if ("group" %in% names(tab)) {
      for (i in seq_len(nrow(tab))) {
        g <- as.character(tab$group[i])
        if (is.null(selected[[g]])) selected[[g]] <- list()
        selected[[g]][[tab$field[i]]] <-
          strsplit(tab$values[i], ",", fixed = TRUE)[[1]]
      }
    } else {
      grp <- list()
      for (i in seq_len(nrow(tab))) {
        grp[[tab$field[i]]] <- strsplit(tab$values[i], ",", fixed = TRUE)[[1]]
      }
      selected[["0"]] <- grp
    }
    return(selected)
  }

  selected <- list()
  group_toks <- strsplit(meta_fields_values, ";", fixed = TRUE)[[1]]
  for (idx in seq_along(group_toks)) {
    grp <- list()
    for (ft in strsplit(group_toks[idx], ":", fixed = TRUE)[[1]]) {
      fv <- strsplit(ft, "=", fixed = TRUE)[[1]]
      if (length(fv) != 2) {
        stop("error processing ", group_toks[idx],
             " should be field and values separated by =")
      }
      grp[[fv[1]]] <- strsplit(fv[2], ",", fixed = TRUE)[[1]]
    }
    # 0-based group key, matching the Python implementation
    selected[[as.character(idx - 1L)]] <- grp
  }
  selected
}

#' @keywords internal
.specimen_value_as_scalar <- function(v) {
  if (is.null(v)) return(NA_character_)
  if (length(v) == 1) return(as.character(v))
  paste(as.character(v), collapse = ",")
}

#' Extract specimens matching metadata groupings
#'
#' Keeps the specimens (and their libraries/results) that satisfy any of the
#' supplied metadata groups, returning the filtered PMO and a per-group count
#' table. A specimen matches a group when it has every field in that group and
#' the field's value is among the group's listed values.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param meta_fields_values File path or inline specification (see
#'   [.parse_meta_groupings()]).
#' @return A list with `pmo` (a filtered PMO list) and `group_counts` (a tibble
#'   with a `group` column, one column per field, and a `count` column).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' res <- pmo_extract_samples_by_meta_groupings(p, "collection_country=Mozambique")
#' res$group_counts
#' @export
pmo_extract_samples_by_meta_groupings <- function(pmo, meta_fields_values) {
  p <- .pmo_as_list(pmo)
  selected <- .parse_meta_groupings(meta_fields_values)

  fields_found <- pmo_count_specimen_per_meta_fields(p)$field
  warnings <- character(0)
  for (g in selected) {
    for (f in names(g)) {
      if (!(f %in% fields_found)) {
        warnings <- c(warnings, paste0("missing the field: ", f, " in pmo"))
      }
    }
  }
  if (length(warnings) > 0) stop(paste(unique(warnings), collapse = "\n"))

  group_counts <- stats::setNames(
    integer(length(selected)), names(selected)
  )
  all_specimen_names <- character(0)
  for (specimen in p$specimen_info) {
    for (gname in names(selected)) {
      meta <- selected[[gname]]
      passes <- TRUE
      for (f in names(meta)) {
        sv <- .specimen_value_as_scalar(specimen[[f]])
        if (is.na(sv) || !(sv %in% meta[[f]])) {
          passes <- FALSE
          break
        }
      }
      if (passes) {
        group_counts[gname] <- group_counts[gname] + 1L
        all_specimen_names <- c(all_specimen_names, specimen$specimen_name)
      }
    }
  }

  all_fields <- unique(unlist(lapply(selected, names)))
  rows <- lapply(names(selected), function(gname) {
    rec <- list(group = gname)
    for (f in all_fields) {
      v <- selected[[gname]][[f]]
      rec[[f]] <- if (is.null(v)) NA_character_ else paste(v, collapse = ",")
    }
    rec[["count"]] <- as.integer(group_counts[[gname]])
    rec
  })
  group_counts_df <- dplyr::bind_rows(rows)

  specimen_ids <- unique(pmo_index_of_specimen_names(
    p, unique(all_specimen_names)
  ))
  pmo_out <- pmo_filter_by_specimen_ids(p, specimen_ids)
  list(pmo = pmo_out, group_counts = group_counts_df)
}

#' Filter detected microhaplotypes by a minimum read count
#'
#' Returns a new PMO (as a raw nested list) keeping only detected
#' microhaplotypes with `reads >= read_filter`. Targets with no surviving
#' microhaplotypes, and samples with no surviving targets, are dropped. All
#' other sections (including `representative_microhaplotypes` and
#' `read_counts_by_stage`) are carried over unchanged.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param read_filter Minimum read count for a microhaplotype to be kept.
#' @return A PMO list (write with [write_pmo_raw()]).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' sub <- pmo_extract_by_read_filter(p, 100)
#' @export
pmo_extract_by_read_filter <- function(pmo, read_filter) {
  p <- .pmo_as_list(pmo)
  out <- list(
    pmo_header = p$pmo_header,
    panel_info = p$panel_info,
    target_info = p$target_info,
    specimen_info = p$specimen_info,
    library_sample_info = p$library_sample_info,
    representative_microhaplotypes = p$representative_microhaplotypes,
    detected_microhaplotypes = list()
  )
  out <- .copy_optional_sections(p, out, c(
    "sequencing_info", "project_info", "bioinformatics_methods_info",
    "bioinformatics_run_info", "targeted_genomes", "read_counts_by_stage"
  ))

  for (dm in p$detected_microhaplotypes) {
    new_dm <- list(library_samples = list())
    if (!is.null(dm$bioinformatics_run_id)) {
      new_dm$bioinformatics_run_id <- dm$bioinformatics_run_id
    }
    for (library in dm$library_samples) {
      new_sample <- list(
        library_sample_id = library$library_sample_id,
        target_results = list()
      )
      for (target in library$target_results) {
        kept <- list()
        for (mh in target$mhaps) {
          if (mh$reads >= read_filter) kept[[length(kept) + 1L]] <- mh
        }
        if (length(kept) > 0) {
          new_sample$target_results[[length(new_sample$target_results) + 1L]] <-
            list(mhaps_target_id = target$mhaps_target_id, mhaps = kept)
        }
      }
      if (length(new_sample$target_results) > 0) {
        new_dm$library_samples[[length(new_dm$library_samples) + 1L]] <-
          new_sample
      }
    }
    out$detected_microhaplotypes[[length(out$detected_microhaplotypes) + 1L]] <-
      new_dm
  }
  out
}

# ---------------------------------------------------------------------------
# List <-> R6 conversion
# ---------------------------------------------------------------------------

#' Convert a raw PMO list into a PortableMicrohaplotypeObject
#'
#' Wraps a plain nested PMO list (1-based ids, as produced by the filter
#' functions or [read_pmo_raw()]) into a [PortableMicrohaplotypeObject] R6
#' instance. Ids are preserved (the round-trip applies the write offset and the
#' read offset, which cancel out).
#'
#' @param pmo_list A PMO list with 1-based id fields.
#' @param validate Logical; validate the resulting object.
#' @return A `PortableMicrohaplotypeObject` instance.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' filtered <- pmo_filter_by_specimen_ids(p, 1L)
#' obj <- pmo_list_to_r6(filtered)
#' @export
pmo_list_to_r6 <- function(pmo_list, validate = TRUE) {
  if (inherits(pmo_list, "PortableMicrohaplotypeObject")) return(pmo_list)
  json_ready <- pmo_raw_prepare_for_json(pmo_list)
  json <- jsonlite::toJSON(json_ready, auto_unbox = TRUE, na = "string")
  parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)
  PortableMicrohaplotypeObject$from_json(parsed, validate = validate)
}
