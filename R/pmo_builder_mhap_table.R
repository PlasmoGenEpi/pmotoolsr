# PMO builder: microhaplotype table -> PMO microhaplotype structures
#
# Ported from pmotools-python pmo_builder/mhap_table_to_pmo.py (+ json_convert_utils.py).
#
# Produces a NAME-based intermediate: representative microhaplotypes keyed by
# `target_name`, detected microhaplotypes keyed by `library_sample_name`. The
# only positional indices are `mhaps_target_id` (into representative targets) and
# `mhap_id` (into a target's microhaplotypes); both are 1-based here so the
# write path's -1 offset yields correct 0-based on-disk values. merge_to_pmo
# later replaces the names with target/library ids.

#' @keywords internal
.check_additional_columns_exist <- function(df, cols) {
  if (length(cols) > 0) {
    missing <- setdiff(cols, names(df))
    if (length(missing) > 0) {
      stop("Missing additional columns: ", paste(missing, collapse = ", "))
    }
  }
}

#' @keywords internal
.present <- function(x) {
  length(x) == 1 && !is.null(x) && !is.na(x)
}

#' @keywords internal
.create_representative_microhaplotype_dict <- function(
    microhaplotype_table, target_name_col = "target_name", seq_col = "seq",
    genome_id = 1, chrom_col = NULL, start_col = NULL, end_col = NULL,
    ref_seq_col = NULL, strand_col = NULL, alt_annotations_col = NULL,
    masking_seq_start_col = NULL, masking_seq_segment_size_col = NULL,
    masking_replacement_size_col = NULL, masking_delim = ",",
    microhaplotype_name_col = NULL, pseudocigar_col = NULL,
    pseudocigar_chrom_col = NULL, pseudocigar_start_col = NULL,
    pseudocigar_end_col = NULL, pseudocigar_ref_seq_col = NULL,
    pseudocigar_strand_col = NULL, pseudocigar_genome_id = NULL,
    pseudocigar_generation_description_col = NULL, quality_col = NULL,
    additional_representative_mhap_cols = NULL) {

  if (!is.null(additional_representative_mhap_cols)) {
    .check_additional_columns_exist(microhaplotype_table,
                                    additional_representative_mhap_cols)
  }

  # the pseudocigar's reference location shares the chromosome / genome with the
  # microhaplotype location by default, but each may use its own column
  ps_chrom_col <- if (is.null(pseudocigar_chrom_col)) chrom_col else
    pseudocigar_chrom_col
  ps_genome_id <- if (is.null(pseudocigar_genome_id)) genome_id else
    pseudocigar_genome_id
  if (!is.null(pseudocigar_col)) {
    if (is.null(ps_chrom_col) || is.null(pseudocigar_start_col) ||
        is.null(pseudocigar_end_col)) {
      stop("pseudocigar_col is set, so a Pseudocigar ref_loc must be ",
           "constructable: set a chromosome (pseudocigar_chrom_col or ",
           "chrom_col), pseudocigar_start_col, and pseudocigar_end_col.")
    }
  }

  masking_cols <- c(masking_seq_start_col, masking_seq_segment_size_col,
                    masking_replacement_size_col)
  if (length(masking_cols) > 0 && length(masking_cols) != 3) {
    stop("If one masking column is set, all three must be set ",
         "(masking_seq_start_col, masking_seq_segment_size_col, ",
         "masking_replacement_size_col).")
  }
  loc_cols <- c(chrom_col, start_col, end_col, ref_seq_col, strand_col)
  if (length(loc_cols) > 0 &&
      !all(c(!is.null(chrom_col), !is.null(start_col), !is.null(end_col)))) {
    stop("If any location column is set, then chrom_col, start_col, and ",
         "end_col must all be set.")
  }

  optional_cols <- c(chrom_col, start_col, end_col, ref_seq_col, strand_col,
                     alt_annotations_col, microhaplotype_name_col,
                     pseudocigar_col, ps_chrom_col, pseudocigar_start_col,
                     pseudocigar_end_col, pseudocigar_ref_seq_col,
                     pseudocigar_strand_col,
                     pseudocigar_generation_description_col, quality_col)
  all_cols <- unique(c(target_name_col, seq_col, optional_cols, masking_cols,
                       additional_representative_mhap_cols))
  unique_table <- dplyr::distinct(
    microhaplotype_table[, all_cols, drop = FALSE])

  # warn on duplicate (target, seq) combinations
  combo <- paste(unique_table[[target_name_col]], unique_table[[seq_col]],
                 sep = "\r")
  dups <- unique(combo[duplicated(combo)])
  if (length(dups) > 0) {
    warning("Duplicate (target, seq) combinations found: ", length(dups),
            " combination(s)")
  }

  extract_masking <- function(row) {
    if (length(masking_cols) != 3) return(list())
    s <- row[[masking_seq_start_col]]
    sz <- row[[masking_seq_segment_size_col]]
    r <- row[[masking_replacement_size_col]]
    if (!(.present(s) && .present(sz) && .present(r))) return(list())
    starts <- strsplit(as.character(s), masking_delim, fixed = TRUE)[[1]]
    sizes <- strsplit(as.character(sz), masking_delim, fixed = TRUE)[[1]]
    repls <- strsplit(as.character(r), masking_delim, fixed = TRUE)[[1]]
    n <- min(length(starts), length(sizes), length(repls))
    out <- list()
    for (i in seq_len(n)) {
      if (nzchar(starts[i]) && nzchar(sizes[i]) && nzchar(repls[i])) {
        out[[length(out) + 1L]] <- list(
          seq_start = as.integer(starts[i]),
          seq_segment_size = as.integer(sizes[i]),
          replacement_size = as.integer(repls[i])
        )
      }
    }
    out
  }

  targets <- list()
  for (target in sort(unique(unique_table[[target_name_col]]))) {
    group <- unique_table[unique_table[[target_name_col]] == target, ,
                          drop = FALSE]
    target_dict <- list(target_name = target, microhaplotypes = list())
    if (!is.null(chrom_col) && .present(group[[chrom_col]][1])) {
      loc <- list(genome_id = genome_id, chrom = group[[chrom_col]][1],
                  start = group[[start_col]][1], end = group[[end_col]][1])
      if (!is.null(ref_seq_col) && .present(group[[ref_seq_col]][1])) {
        loc$ref_seq <- group[[ref_seq_col]][1]
      }
      if (!is.null(strand_col) && .present(group[[strand_col]][1])) {
        loc$strand <- group[[strand_col]][1]
      }
      target_dict$mhap_location <- loc
    }
    for (i in seq_len(nrow(group))) {
      row <- group[i, , drop = FALSE]
      mhap <- list(seq = row[[seq_col]])
      if (!is.null(alt_annotations_col) && .present(row[[alt_annotations_col]])) {
        mhap$alt_annotations <- row[[alt_annotations_col]]
      }
      if (!is.null(microhaplotype_name_col) &&
          .present(row[[microhaplotype_name_col]])) {
        mhap$microhaplotype_name <- row[[microhaplotype_name_col]]
      }
      if (!is.null(pseudocigar_col) && .present(row[[pseudocigar_col]])) {
        if (!(.present(row[[ps_chrom_col]]) &&
              .present(row[[pseudocigar_start_col]]) &&
              .present(row[[pseudocigar_end_col]]))) {
          stop("pseudocigar present for a microhaplotype but its ref_loc ",
               "chrom/start/end is missing (target ", target, ", seq ",
               row[[seq_col]], ")")
        }
        ref_loc <- list(genome_id = ps_genome_id, chrom = row[[ps_chrom_col]],
                        start = row[[pseudocigar_start_col]],
                        end = row[[pseudocigar_end_col]])
        if (!is.null(pseudocigar_ref_seq_col) &&
            .present(row[[pseudocigar_ref_seq_col]])) {
          ref_loc$ref_seq <- row[[pseudocigar_ref_seq_col]]
        }
        if (!is.null(pseudocigar_strand_col) &&
            .present(row[[pseudocigar_strand_col]])) {
          ref_loc$strand <- row[[pseudocigar_strand_col]]
        }
        ps <- list(pseudocigar_seq = row[[pseudocigar_col]], ref_loc = ref_loc)
        if (!is.null(pseudocigar_generation_description_col) &&
            .present(row[[pseudocigar_generation_description_col]])) {
          ps$pseudocigar_generation_description <-
            row[[pseudocigar_generation_description_col]]
        }
        mhap$pseudocigar <- ps
      }
      if (!is.null(quality_col) && .present(row[[quality_col]])) {
        mhap$quality <- row[[quality_col]]
      }
      for (col in additional_representative_mhap_cols) {
        if (.present(row[[col]])) mhap[[col]] <- row[[col]]
      }
      masking <- extract_masking(row)
      if (length(masking) > 0) mhap$masking <- masking
      target_dict$microhaplotypes[[length(target_dict$microhaplotypes) + 1L]] <-
        mhap
    }
    targets[[length(targets) + 1L]] <- target_dict
  }
  list(targets = targets)
}

#' @keywords internal
.rep_target_names <- function(rep_dict) {
  vapply(rep_dict$targets, function(t) t$target_name, character(1))
}

#' @keywords internal
.mhaps_target_id_for <- function(target_names, rep_dict) {
  rep_names <- .rep_target_names(rep_dict)
  ids <- match(target_names, rep_names)
  if (anyNA(ids)) {
    miss <- unique(target_names[is.na(ids)])
    stop("Missing target_name(s) in representative microhaplotype table: ",
         paste(miss, collapse = ", "))
  }
  ids
}

#' @keywords internal
.mhap_id_for <- function(mhaps_target_ids, seqs, rep_dict) {
  key_lookup <- new.env(parent = emptyenv())
  for (ti in seq_along(rep_dict$targets)) {
    mhs <- rep_dict$targets[[ti]]$microhaplotypes
    for (mi in seq_along(mhs)) {
      assign(paste(ti, mhs[[mi]]$seq, sep = "\r"), mi, envir = key_lookup)
    }
  }
  ids <- vapply(seq_along(seqs), function(i) {
    k <- paste(mhaps_target_ids[i], seqs[i], sep = "\r")
    if (exists(k, envir = key_lookup, inherits = FALSE)) {
      get(k, envir = key_lookup, inherits = FALSE)
    } else {
      NA_integer_
    }
  }, integer(1))
  if (anyNA(ids)) {
    stop("Some seq values not found in representative microhaplotype table")
  }
  ids
}

#' @keywords internal
.build_detected_mhap_dict <- function(df, bioinformatics_run_name, mhap_cols,
                                      always_include = c("mhap_id", "reads")) {
  out <- list(library_samples = list())
  if (!is.null(bioinformatics_run_name)) {
    out$bioinformatics_run_name <- bioinformatics_run_name
  }
  for (sample in sort(unique(df$library_sample_name))) {
    sdf <- df[df$library_sample_name == sample, , drop = FALSE]
    target_results <- list()
    for (tid in sort(unique(sdf$mhaps_target_id))) {
      tdf <- sdf[sdf$mhaps_target_id == tid, , drop = FALSE]
      mhaps <- lapply(seq_len(nrow(tdf)), function(i) {
        m <- list()
        for (col in mhap_cols) {
          v <- tdf[[col]][i]
          if (col %in% always_include || .present(v)) m[[col]] <- v
        }
        m
      })
      target_results[[length(target_results) + 1L]] <-
        list(mhaps_target_id = tid, mhaps = mhaps)
    }
    out$library_samples[[length(out$library_samples) + 1L]] <-
      list(library_sample_name = sample, target_results = target_results)
  }
  out
}

#' @keywords internal
.create_detected_microhaplotype_dict <- function(
    microhaplotype_table, representative_microhaplotype_dict,
    bioinformatics_run_name = NULL,
    library_sample_name_col = "library_sample_name",
    target_name_col = "target_name", seq_col = "seq", reads_col = "reads",
    umis_col = NULL, additional_mhap_detected_cols = NULL) {

  work <- data.frame(
    library_sample_name = as.character(microhaplotype_table[[library_sample_name_col]]),
    target_name = as.character(microhaplotype_table[[target_name_col]]),
    seq = as.character(microhaplotype_table[[seq_col]]),
    reads = microhaplotype_table[[reads_col]],
    stringsAsFactors = FALSE
  )
  mhap_cols <- c("mhap_id", "reads")
  if (!is.null(umis_col)) {
    work$umis <- microhaplotype_table[[umis_col]]
    mhap_cols <- c(mhap_cols, "umis")
  }
  if (!is.null(additional_mhap_detected_cols)) {
    .check_additional_columns_exist(microhaplotype_table,
                                    additional_mhap_detected_cols)
    for (col in additional_mhap_detected_cols) {
      work[[col]] <- microhaplotype_table[[col]]
    }
    mhap_cols <- c(mhap_cols, additional_mhap_detected_cols)
  }
  work$mhaps_target_id <- .mhaps_target_id_for(work$target_name,
                                               representative_microhaplotype_dict)
  work$mhap_id <- .mhap_id_for(work$mhaps_target_id, work$seq,
                               representative_microhaplotype_dict)
  .build_detected_mhap_dict(work, bioinformatics_run_name, mhap_cols)
}

#' Convert a microhaplotype calls table into PMO microhaplotype structures
#'
#' Builds the `representative_microhaplotypes` and `detected_microhaplotypes`
#' components from a long table of microhaplotype calls. The result is a
#' name-based intermediate (see file notes) suitable for [pmo_merge_to_pmo()].
#'
#' @param microhaplotype_table A data.frame of microhaplotype calls.
#' @param bioinformatics_run_name Either a column name in the table (one detected
#'   set is built per unique value) or a single run name, or `NULL`.
#' @param library_sample_name_col,target_name_col,seq_col,reads_col Column names
#'   for the required fields.
#' @param genome_id 1-based genome id for mhap locations (default 1).
#' @param umis_col,chrom_col,start_col,end_col,ref_seq_col,strand_col Optional
#'   column names.
#' @param alt_annotations_col,microhaplotype_name_col,pseudocigar_col,quality_col
#'   Optional column names.
#' @param pseudocigar_chrom_col,pseudocigar_start_col,pseudocigar_end_col,pseudocigar_ref_seq_col,pseudocigar_strand_col,pseudocigar_genome_id,pseudocigar_generation_description_col
#'   Columns/value used to build the `Pseudocigar` object's `ref_loc`
#'   ([GenomicLocation]) when `pseudocigar_col` is set. The chromosome defaults
#'   to `chrom_col` and the genome id to `genome_id`; `pseudocigar_start_col` and
#'   `pseudocigar_end_col` are required (an error is raised if `pseudocigar_col`
#'   is set without a constructable ref_loc).
#' @param masking_seq_start_col,masking_seq_segment_size_col,masking_replacement_size_col
#'   Optional masking column names (all three required together).
#' @param masking_delim Delimiter for masking list values.
#' @param additional_representative_mhap_cols,additional_mhap_detected_cols
#'   Optional extra columns to carry through.
#' @return A list with `representative_microhaplotypes` and a list of
#'   `detected_microhaplotypes`.
#' @examples
#' calls <- data.frame(
#'   library_sample_name = c("S1", "S1", "S2"),
#'   target_name = c("t1", "t2", "t1"),
#'   seq = c("ACGT", "TTTT", "ACGA"),
#'   reads = c(120, 80, 95)
#' )
#' mhaps <- pmo_mhap_table_to_pmo(calls)
#' length(mhaps$representative_microhaplotypes$targets)
#' @export
pmo_mhap_table_to_pmo <- function(
    microhaplotype_table, bioinformatics_run_name = NULL,
    library_sample_name_col = "library_sample_name",
    target_name_col = "target_name", seq_col = "seq", reads_col = "reads",
    genome_id = 1, umis_col = NULL, chrom_col = NULL, start_col = NULL,
    end_col = NULL, ref_seq_col = NULL, strand_col = NULL,
    alt_annotations_col = NULL, masking_seq_start_col = NULL,
    masking_seq_segment_size_col = NULL, masking_replacement_size_col = NULL,
    masking_delim = ",", microhaplotype_name_col = NULL, pseudocigar_col = NULL,
    pseudocigar_chrom_col = NULL, pseudocigar_start_col = NULL,
    pseudocigar_end_col = NULL, pseudocigar_ref_seq_col = NULL,
    pseudocigar_strand_col = NULL, pseudocigar_genome_id = NULL,
    pseudocigar_generation_description_col = NULL,
    quality_col = NULL, additional_representative_mhap_cols = NULL,
    additional_mhap_detected_cols = NULL) {

  rep_dict <- .create_representative_microhaplotype_dict(
    microhaplotype_table = microhaplotype_table,
    target_name_col = target_name_col, seq_col = seq_col, genome_id = genome_id,
    chrom_col = chrom_col, start_col = start_col, end_col = end_col,
    ref_seq_col = ref_seq_col, strand_col = strand_col,
    alt_annotations_col = alt_annotations_col,
    masking_seq_start_col = masking_seq_start_col,
    masking_seq_segment_size_col = masking_seq_segment_size_col,
    masking_replacement_size_col = masking_replacement_size_col,
    masking_delim = masking_delim,
    microhaplotype_name_col = microhaplotype_name_col,
    pseudocigar_col = pseudocigar_col,
    pseudocigar_chrom_col = pseudocigar_chrom_col,
    pseudocigar_start_col = pseudocigar_start_col,
    pseudocigar_end_col = pseudocigar_end_col,
    pseudocigar_ref_seq_col = pseudocigar_ref_seq_col,
    pseudocigar_strand_col = pseudocigar_strand_col,
    pseudocigar_genome_id = pseudocigar_genome_id,
    pseudocigar_generation_description_col =
      pseudocigar_generation_description_col,
    quality_col = quality_col,
    additional_representative_mhap_cols = additional_representative_mhap_cols)

  detected_list <- list()
  is_col <- !is.null(bioinformatics_run_name) &&
    bioinformatics_run_name %in% names(microhaplotype_table)
  if (is_col) {
    for (run in unique(microhaplotype_table[[bioinformatics_run_name]])) {
      sub <- microhaplotype_table[
        microhaplotype_table[[bioinformatics_run_name]] == run, , drop = FALSE]
      detected_list[[length(detected_list) + 1L]] <-
        .create_detected_microhaplotype_dict(
          sub, rep_dict, bioinformatics_run_name = run,
          library_sample_name_col = library_sample_name_col,
          target_name_col = target_name_col, seq_col = seq_col,
          reads_col = reads_col, umis_col = umis_col,
          additional_mhap_detected_cols = additional_mhap_detected_cols)
    }
  } else {
    detected_list[[1L]] <- .create_detected_microhaplotype_dict(
      microhaplotype_table, rep_dict,
      bioinformatics_run_name = bioinformatics_run_name,
      library_sample_name_col = library_sample_name_col,
      target_name_col = target_name_col, seq_col = seq_col,
      reads_col = reads_col, umis_col = umis_col,
      additional_mhap_detected_cols = additional_mhap_detected_cols)
  }

  list(representative_microhaplotypes = rep_dict,
       detected_microhaplotypes = detected_list)
}

#' Build minimal library/specimen info from a detected-microhaplotypes structure
#'
#' @param detected_microhaps The list of detected-microhaplotype sets (the
#'   `detected_microhaplotypes` element from [pmo_mhap_table_to_pmo()]).
#' @param panel_name Panel name to assign to each library sample.
#' @param library_sample_specimen_key Optional named character vector or
#'   data.frame mapping library sample name to specimen name; if `NULL`,
#'   specimen name equals library sample name.
#' @param library_sample_name_col,specimen_name_col Column names used when
#'   `library_sample_specimen_key` is a data.frame.
#' @param missing_library_sample_becomes_specimen_name If `TRUE`, library samples
#'   absent from the key fall back to using their own name as the specimen name.
#' @return A list with `library_sample_info` and `specimen_info`.
#' @examples
#' calls <- data.frame(library_sample_name = c("S1", "S2"),
#'                     target_name = c("t1", "t1"), seq = c("ACGT", "ACGA"),
#'                     reads = c(120, 95))
#' mhaps <- pmo_mhap_table_to_pmo(calls)
#' ls <- pmo_minimum_library_specimen_from_mhap_table(
#'   mhaps$detected_microhaplotypes, panel_name = "demo_panel")
#' length(ls$specimen_info)
#' @export
pmo_minimum_library_specimen_from_mhap_table <- function(
    detected_microhaps, panel_name, library_sample_specimen_key = NULL,
    library_sample_name_col = "library_sample_name",
    specimen_name_col = "specimen_name",
    missing_library_sample_becomes_specimen_name = FALSE) {

  all_samples <- list()
  for (entry in detected_microhaps) {
    for (s in entry$library_samples) {
      all_samples[[length(all_samples) + 1L]] <- s
    }
  }
  names_vec <- vapply(all_samples, function(s) {
    if (is.null(s$library_sample_name)) NA_character_ else s$library_sample_name
  }, character(1))
  if (anyNA(names_vec)) {
    stop("Some samples are missing 'library_sample_name'")
  }
  dups <- unique(names_vec[duplicated(names_vec)])
  if (length(dups) > 0) {
    stop("Duplicate library sample names found: ",
         paste(sort(dups), collapse = ", "))
  }

  key <- NULL
  if (!is.null(library_sample_specimen_key)) {
    if (is.data.frame(library_sample_specimen_key)) {
      key <- stats::setNames(
        as.character(library_sample_specimen_key[[specimen_name_col]]),
        as.character(library_sample_specimen_key[[library_sample_name_col]]))
    } else {
      key <- library_sample_specimen_key
    }
  }

  library_sample_info <- list()
  for (lib_name in names_vec) {
    if (!is.null(key)) {
      if (lib_name %in% names(key)) {
        specimen_name <- unname(key[[lib_name]])
      } else if (missing_library_sample_becomes_specimen_name) {
        specimen_name <- lib_name
      } else {
        stop("library_sample_name '", lib_name, "' not found in ",
             "library_sample_specimen_key and ",
             "missing_library_sample_becomes_specimen_name is FALSE")
      }
    } else {
      specimen_name <- lib_name
    }
    library_sample_info[[length(library_sample_info) + 1L]] <- list(
      library_sample_name = lib_name, panel_name = panel_name,
      specimen_name = specimen_name)
  }

  seen <- character(0)
  specimen_info <- list()
  for (entry in library_sample_info) {
    sp <- entry$specimen_name
    if (!(sp %in% seen)) {
      seen <- c(seen, sp)
      specimen_info[[length(specimen_info) + 1L]] <- list(specimen_name = sp)
    }
  }

  list(library_sample_info = library_sample_info, specimen_info = specimen_info)
}
