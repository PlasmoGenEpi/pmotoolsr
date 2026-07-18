# PMO builder: panel/target table -> target_info + panel_info structures
#
# Ported from pmotools-python pmo_builder/panel_information_to_pmo.py.
# Target indices (panel_targets) and genome_id are 1-based here (the write path
# applies the -1 offset to produce 0-based on-disk values).

#' @keywords internal
.panel_check_location_columns <- function(cfg) {
  loc <- c(cfg$forward_primers_start_col, cfg$forward_primers_end_col,
           cfg$reverse_primers_start_col, cfg$reverse_primers_end_col,
           cfg$insert_start_col, cfg$insert_end_col, cfg$chrom_col,
           cfg$strand_col, cfg$ref_seq_col)
  if (length(loc) == 0) return(FALSE)
  warns <- character(0)
  if (is.null(cfg$chrom_col)) {
    warns <- c(warns, "If including location information, chrom_col must be set.")
  }
  pair_check <- function(a, b, label) {
    if (xor(is.null(a), is.null(b))) {
      warns <<- c(warns, sprintf("If one of %s is set, then both must be.", label))
    }
  }
  pair_check(cfg$forward_primers_start_col, cfg$forward_primers_end_col,
             "forward_primers_start_col or forward_primers_end_col")
  pair_check(cfg$reverse_primers_start_col, cfg$reverse_primers_end_col,
             "reverse_primers_start_col or reverse_primers_end_col")
  pair_check(cfg$insert_start_col, cfg$insert_end_col,
             "insert_start_col or insert_end_col")
  if (length(warns) > 0) {
    stop("Errors with location column configuration:\n- ",
         paste(warns, collapse = "\n- "))
  }
  TRUE
}

#' @keywords internal
.panel_check_target_names_unique <- function(target_table, cfg) {
  tn <- as.character(target_table[[cfg$target_name_col]])
  dups <- unique(tn[duplicated(tn)])
  if (length(dups) > 0) {
    stop("The following target names are duplicated: ",
         paste(dups, collapse = ", "))
  }
}

#' @keywords internal
.panel_check_unique_target_info <- function(target_table, cfg, cols) {
  cols <- unique(cols[!vapply(cols, is.null, logical(1))])
  key <- apply(target_table[, cols, drop = FALSE], 1,
               function(r) paste(as.character(r), collapse = "\r"))
  tn <- as.character(target_table[[cfg$target_name_col]])
  grouped <- split(tn, key)
  dup <- grouped[vapply(grouped, length, integer(1)) > 1]
  if (length(dup) > 0) {
    lines <- vapply(dup, function(targets) paste(targets, collapse = ", "),
                    character(1))
    stop("The following targets have duplicated information:\n",
         paste(lines, collapse = "\n"))
  }
}

#' @keywords internal
.panel_missing_loc <- function(target_table, cfg) {
  tn <- as.character(target_table[[cfg$target_name_col]])
  check_missing <- function(name, cols) {
    cols <- cols[!vapply(cols, is.null, logical(1))]
    miss <- tn[apply(target_table[, cols, drop = FALSE], 1,
                     function(r) any(is.na(r)))]
    if (length(miss) > 0) {
      warning(name, " location information was not added for targets with ",
              "empty fields: ", paste(miss, collapse = ", "))
    }
    miss
  }
  list(
    insert = if (!is.null(cfg$insert_start_col)) {
      check_missing("Insert",
                    c(cfg$chrom_col, cfg$insert_start_col, cfg$insert_end_col))
    } else character(0),
    fwd = if (!is.null(cfg$forward_primers_start_col)) {
      check_missing("Forward primer",
                    c(cfg$chrom_col, cfg$forward_primers_start_col,
                      cfg$forward_primers_end_col))
    } else character(0),
    rev = if (!is.null(cfg$reverse_primers_start_col)) {
      check_missing("Reverse primer",
                    c(cfg$chrom_col, cfg$reverse_primers_start_col,
                      cfg$reverse_primers_end_col))
    } else character(0)
  )
}

#' @keywords internal
.panel_build_target_info <- function(target_table, cfg, missing, genome_id_col) {
  gid_for <- function(row) {
    if (!is.null(genome_id_col)) as.integer(row[[genome_id_col]]) else
      cfg$genome_id_default
  }
  targets <- list()
  for (i in seq_len(nrow(target_table))) {
    row <- target_table[i, , drop = FALSE]
    tname <- as.character(row[[cfg$target_name_col]])
    td <- list(target_name = tname)
    if (!is.null(cfg$gene_name_col) && .present(row[[cfg$gene_name_col]])) {
      td$gene_name <- row[[cfg$gene_name_col]]
    }
    if (!is.null(cfg$target_attributes_col) &&
        .present(row[[cfg$target_attributes_col]])) {
      td$target_attributes <- trimws(strsplit(
        as.character(row[[cfg$target_attributes_col]]),
        cfg$target_attributes_col_delimiter, fixed = TRUE)[[1]])
    }
    for (col in cfg$additional_target_info_cols) {
      if (.present(row[[col]])) td[[col]] <- row[[col]]
    }
    if (!is.null(cfg$insert_start_col) && !(tname %in% missing$insert)) {
      il <- list(genome_id = gid_for(row), chrom = row[[cfg$chrom_col]],
                 start = as.integer(row[[cfg$insert_start_col]]),
                 end = as.integer(row[[cfg$insert_end_col]]))
      if (!is.null(cfg$strand_col) && .present(row[[cfg$strand_col]])) {
        il$strand <- row[[cfg$strand_col]]
      }
      if (!is.null(cfg$ref_seq_col) && .present(row[[cfg$ref_seq_col]])) {
        il$ref_seq <- row[[cfg$ref_seq_col]]
      }
      td$insert_location <- il
    }
    fwd <- list(seq = row[[cfg$forward_primers_seq_col]])
    rev <- list(seq = row[[cfg$reverse_primers_seq_col]])
    if (!is.null(cfg$forward_primers_start_col) && !(tname %in% missing$fwd)) {
      loc <- list(genome_id = gid_for(row), chrom = row[[cfg$chrom_col]],
                  start = as.integer(row[[cfg$forward_primers_start_col]]),
                  end = as.integer(row[[cfg$forward_primers_end_col]]))
      if (!is.null(cfg$strand_col) && .present(row[[cfg$strand_col]])) {
        loc$strand <- row[[cfg$strand_col]]
      }
      fwd$location <- loc
    }
    if (!is.null(cfg$reverse_primers_start_col) && !(tname %in% missing$rev)) {
      loc <- list(genome_id = gid_for(row), chrom = row[[cfg$chrom_col]],
                  start = as.integer(row[[cfg$reverse_primers_start_col]]),
                  end = as.integer(row[[cfg$reverse_primers_end_col]]))
      if (!is.null(cfg$strand_col) && .present(row[[cfg$strand_col]])) {
        loc$strand <- row[[cfg$strand_col]]
      }
      rev$location <- loc
    }
    td$forward_primer <- fwd
    td$reverse_primer <- rev
    targets[[length(targets) + 1L]] <- td
  }
  targets
}

#' @keywords internal
.panel_build_panel_info <- function(target_table, cfg, targets) {
  target_indices <- list()
  for (i in seq_along(targets)) target_indices[[targets[[i]]$target_name]] <- i
  tn <- as.character(target_table[[cfg$target_name_col]])

  if (!is.null(cfg$reaction_name_col)) {
    row_reactions <- lapply(target_table[[cfg$reaction_name_col]], function(x) {
      trimws(strsplit(as.character(x), cfg$reaction_name_col_delimiter,
                      fixed = TRUE)[[1]])
    })
    reactions <- unique(unlist(row_reactions))
  } else {
    row_reactions <- rep(list("full"), nrow(target_table))
    reactions <- "full"
  }

  panel_dict <- list(panel_name = cfg$panel_name, reactions = list())
  for (reaction in reactions) {
    matching <- which(vapply(row_reactions,
                             function(rs) reaction %in% rs, logical(1)))
    panel_targets <- vapply(matching,
                            function(i) target_indices[[tn[i]]], integer(1))
    panel_dict$reactions[[length(panel_dict$reactions) + 1L]] <- list(
      reaction_name = reaction, panel_targets = panel_targets)
  }
  panel_dict
}

#' @keywords internal
.panel_check_genome_info <- function(genome_info) {
  required <- c("name", "genome_version", "taxon_id", "url")
  check_one <- function(g, label) {
    if (!is.list(g)) stop(label, " must be a list")
    miss <- setdiff(required, names(g))
    if (length(miss) > 0) {
      stop(label, " missing required keys: ", paste(miss, collapse = ", "))
    }
  }
  if (.is_single_genome(genome_info)) {
    check_one(genome_info, "genome_info")
  } else if (is.list(genome_info)) {
    if (length(genome_info) == 0) stop("genome_info list cannot be empty")
    for (i in seq_along(genome_info)) {
      check_one(genome_info[[i]], sprintf("genome_info[[%d]]", i))
    }
  } else {
    stop("genome_info must be a list (single genome) or list of genomes")
  }
}

#' @keywords internal
.is_single_genome <- function(g) {
  is.list(g) && !is.null(names(g)) && "name" %in% names(g)
}

#' Convert a panel/target table into PMO target_info + panel_info
#'
#' @param target_table A data.frame with one row per target.
#' @param panel_name Name assigned to the panel.
#' @param genome_info Optional genome metadata (a single genome list or a list
#'   of them); required if any location columns are used.
#' @param target_name_col,forward_primers_seq_col,reverse_primers_seq_col Column
#'   names for the required fields.
#' @param reaction_name_col,reaction_name_col_delimiter Optional reaction column
#'   (targets split into reactions); without it all targets form one `full`
#'   reaction.
#' @param forward_primers_start_col,forward_primers_end_col,reverse_primers_start_col,reverse_primers_end_col,insert_start_col,insert_end_col,chrom_col,strand_col,ref_seq_col
#'   Optional genomic-location columns (0-based coordinates).
#' @param gene_name_col,genome_id_col,target_attributes_col,target_attributes_col_delimiter,additional_target_info_cols
#'   Optional extra columns. `genome_id_col` values are 1-based; without it
#'   genome id defaults to 1.
#' @return A list with `panel_info`, `target_info`, and (if `genome_info` given)
#'   `targeted_genomes`.
#' @examples
#' primers <- data.frame(target_name = c("t1", "t2"),
#'                       fwd_primer = c("AAAA", "CCCC"),
#'                       rev_primer = c("TTTT", "GGGG"))
#' panel <- pmo_panel_info_table_to_pmo(primers, "demo_panel")
#' length(panel$target_info)
#' @export
pmo_panel_info_table_to_pmo <- function(
    target_table, panel_name, genome_info = NULL,
    target_name_col = "target_name", forward_primers_seq_col = "fwd_primer",
    reverse_primers_seq_col = "rev_primer", reaction_name_col = NULL,
    reaction_name_col_delimiter = ",", forward_primers_start_col = NULL,
    forward_primers_end_col = NULL, reverse_primers_start_col = NULL,
    reverse_primers_end_col = NULL, insert_start_col = NULL,
    insert_end_col = NULL, chrom_col = NULL, strand_col = NULL,
    ref_seq_col = NULL, gene_name_col = NULL, genome_id_col = NULL,
    target_attributes_col = NULL, target_attributes_col_delimiter = ",",
    additional_target_info_cols = NULL) {

  if (!is.data.frame(target_table)) {
    stop("target_table must be a data.frame")
  }
  .check_additional_columns_exist(target_table, additional_target_info_cols)

  cfg <- list(
    panel_name = panel_name, target_name_col = target_name_col,
    forward_primers_seq_col = forward_primers_seq_col,
    reverse_primers_seq_col = reverse_primers_seq_col,
    reaction_name_col = reaction_name_col,
    reaction_name_col_delimiter = reaction_name_col_delimiter,
    forward_primers_start_col = forward_primers_start_col,
    forward_primers_end_col = forward_primers_end_col,
    reverse_primers_start_col = reverse_primers_start_col,
    reverse_primers_end_col = reverse_primers_end_col,
    insert_start_col = insert_start_col, insert_end_col = insert_end_col,
    chrom_col = chrom_col, strand_col = strand_col, ref_seq_col = ref_seq_col,
    gene_name_col = gene_name_col, target_attributes_col = target_attributes_col,
    target_attributes_col_delimiter = target_attributes_col_delimiter,
    additional_target_info_cols = additional_target_info_cols,
    genome_id_default = 1L)

  has_location <- .panel_check_location_columns(cfg)
  .panel_check_target_names_unique(target_table, cfg)
  cols_to_check <- c(forward_primers_seq_col, reverse_primers_seq_col)
  if (has_location) {
    cols_to_check <- c(cols_to_check,
                       forward_primers_start_col, forward_primers_end_col,
                       reverse_primers_start_col, reverse_primers_end_col,
                       insert_start_col, insert_end_col, chrom_col, strand_col,
                       ref_seq_col)
  }
  .panel_check_unique_target_info(target_table, cfg, cols_to_check)
  missing <- .panel_missing_loc(target_table, cfg)

  if (!is.null(genome_info) && .is_single_genome(genome_info)) {
    genome_info <- list(genome_info)
  }
  if (!is.null(genome_info)) .panel_check_genome_info(genome_info)

  targets <- .panel_build_target_info(target_table, cfg, missing, genome_id_col)

  if (is.null(genome_info)) {
    for (target in targets) {
      if (!is.null(target$insert_location)) {
        stop("insert_location is provided for ", target$target_name,
             " but no targeted_genomes is provided.")
      }
      if (!is.null(target$forward_primer$location)) {
        stop("forward primer location is provided for ", target$target_name,
             " but no targeted_genomes is provided.")
      }
      if (!is.null(target$reverse_primer$location)) {
        stop("reverse primer location is provided for ", target$target_name,
             " but no targeted_genomes is provided.")
      }
    }
  }

  panel_dict <- .panel_build_panel_info(target_table, cfg, targets)
  out <- list(panel_info = list(panel_dict), target_info = targets)
  if (!is.null(genome_info)) out$targeted_genomes <- genome_info
  out
}

# ---------------------------------------------------------------------------
# Merging panel dicts
# ---------------------------------------------------------------------------

#' @keywords internal
.canonicalise <- function(x) {
  if (is.list(x)) {
    if (!is.null(names(x))) x <- x[order(names(x))]
    x <- lapply(x, .canonicalise)
  }
  x
}

#' @keywords internal
.genome_signature <- function(g) {
  as.character(jsonlite::toJSON(.canonicalise(g), auto_unbox = TRUE,
                                null = "null"))
}

#' @keywords internal
.remap_genome_ids <- function(target, mapping) {
  if (!is.null(target$insert_location) &&
      !is.null(target$insert_location$genome_id)) {
    old <- as.character(target$insert_location$genome_id)
    if (old %in% names(mapping)) target$insert_location$genome_id <- mapping[[old]]
  }
  for (pk in c("forward_primer", "reverse_primer")) {
    if (!is.null(target[[pk]]) && !is.null(target[[pk]]$location) &&
        !is.null(target[[pk]]$location$genome_id)) {
      old <- as.character(target[[pk]]$location$genome_id)
      if (old %in% names(mapping)) {
        target[[pk]]$location$genome_id <- mapping[[old]]
      }
    }
  }
  target
}

#' Merge multiple panel_info dictionaries
#'
#' Concatenates target lists (deduplicated by `target_name`), collapses
#' duplicate genomes, and remaps all genome ids and panel target indices so they
#' remain valid across the merged structure.
#'
#' @param panel_info_dicts A list of outputs from [pmo_panel_info_table_to_pmo()].
#' @return A merged list with `panel_info`, `target_info`, and (if any genomes)
#'   `targeted_genomes`.
#' @examples
#' mk <- function(t) pmo_panel_info_table_to_pmo(
#'   data.frame(target_name = t, fwd_primer = "AAAA", rev_primer = "TTTT"),
#'   paste0("panel_", t))
#' merged <- pmo_merge_panel_info_dicts(list(mk("t1"), mk("t2")))
#' length(merged$target_info)
#' @export
pmo_merge_panel_info_dicts <- function(panel_info_dicts) {
  if (length(panel_info_dicts) == 0) {
    stop("panel_info_dicts must contain at least one entry.")
  }
  merged_targets <- list()
  tname_to_idx <- list()
  merged_panels <- list()
  merged_genomes <- list()
  sig_to_idx <- list()

  for (pdct in panel_info_dicts) {
    genome_mapping <- integer(0)
    if (!is.null(pdct$targeted_genomes)) {
      for (gi in seq_along(pdct$targeted_genomes)) {
        sig <- .genome_signature(pdct$targeted_genomes[[gi]])
        if (is.null(sig_to_idx[[sig]])) {
          merged_genomes[[length(merged_genomes) + 1L]] <-
            pdct$targeted_genomes[[gi]]
          sig_to_idx[[sig]] <- length(merged_genomes)
        }
        genome_mapping[as.character(gi)] <- sig_to_idx[[sig]]
      }
    }
    if (is.null(pdct$target_info)) stop("panel_info_dict missing 'target_info'.")
    for (target in pdct$target_info) {
      tname <- target$target_name
      if (is.null(tname)) {
        stop("Each target_info entry must include a 'target_name'.")
      }
      if (is.null(tname_to_idx[[tname]])) {
        tcopy <- target
        if (!is.null(pdct$targeted_genomes)) {
          tcopy <- .remap_genome_ids(tcopy, genome_mapping)
        } else {
          if (!is.null(tcopy$insert_location)) {
            stop("target ", tname,
                 " has insert_location but no targeted_genomes information")
          }
          if (!is.null(tcopy$forward_primer$location)) {
            stop("target ", tname,
                 " has forward primer location but no targeted_genomes")
          }
          if (!is.null(tcopy$reverse_primer$location)) {
            stop("target ", tname,
                 " has reverse primer location but no targeted_genomes")
          }
        }
        merged_targets[[length(merged_targets) + 1L]] <- tcopy
        tname_to_idx[[tname]] <- length(merged_targets)
      }
    }
    for (panel in pdct$panel_info) {
      rp <- list(panel_name = panel$panel_name, reactions = list())
      for (reaction in panel$reactions) {
        remapped <- integer(0)
        for (tidx in unlist(reaction$panel_targets)) {
          tn <- pdct$target_info[[tidx]]$target_name
          remapped <- c(remapped, tname_to_idx[[tn]])
        }
        rp$reactions[[length(rp$reactions) + 1L]] <- list(
          reaction_name = reaction$reaction_name, panel_targets = remapped)
      }
      merged_panels[[length(merged_panels) + 1L]] <- rp
    }
  }
  out <- list(panel_info = merged_panels, target_info = merged_targets)
  if (length(merged_genomes) > 0) out$targeted_genomes <- merged_genomes
  out
}
