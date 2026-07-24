# Combine multiple PMOs into one
#
# Ported from pmotools-python PMOReader.combine_multiple_pmos. Deduplicates
# genomes (by name+version), targets (by target_name), panels (by panel_name),
# projects (by name), specimens (by name), and representative microhaplotypes
# (by target_name then seq); concatenates the rest; and remaps every index.
# All ids are 1-based (consistent with read_pmo_raw / the builders).
#
# bioinformatics_run_info's bioinformatics_methods_id is remapped using the
# run's own methods id, and a representative-microhaplotype target newly added
# from a non-first PMO has its target_id remapped to the combined target_info.

#' @keywords internal
.cm_env <- function() new.env(parent = emptyenv())
#' @keywords internal
.cm_key <- function(...) paste(..., sep = "\r")

#' Combine multiple PMOs into a single PMO
#'
#' @param pmos A list of two or more PMOs (each a `PortableMicrohaplotypeObject`
#'   or a parsed PMO list).
#' @return The combined PMO as a raw nested list (1-based ids). Write with
#'   [write_pmo_raw()], convert with [pmo_list_to_r6()], or validate with
#'   [pmo_validate()].
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' a <- pmo_filter_by_specimen_ids(p, 1L)
#' b <- pmo_filter_by_specimen_ids(p, 2L)
#' combined <- pmo_combine_pmos(list(a, b))
#' length(combined$specimen_info)
#' @export
pmo_combine_pmos <- function(pmos) {
  if (length(pmos) <= 1) {
    stop("Only supplied ", length(pmos),
         " but multiple PMO objects were expected")
  }
  pmos <- lapply(pmos, .pmo_as_list)
  np <- length(pmos)

  # mutable index maps: value <- get(key) ; assign(key, value)
  set <- function(e, k, v) assign(k, v, envir = e)
  get1 <- function(e, k) get(k, envir = e, inherits = FALSE)
  has1 <- function(e, k) exists(k, envir = e, inherits = FALSE)

  out <- list()
  out$pmo_header <- list(
    pmo_version = pmo_schema_version(),
    creation_date = as.character(Sys.Date()),
    generation_method = list(
      program_name = "pmotoolsr.pmo_combine_pmos",
      program_version = tryCatch(as.character(utils::packageVersion("pmotoolsr")),
                                 error = function(e) "1.0.0")))

  # --- targeted_genomes (dedup by name_version) ---------------------------
  genomes_out <- .cm_env()
  genomes_old <- .cm_env()
  gsig <- function(g) paste0(g$name, "_", g$genome_version)
  if (!is.null(pmos[[1]]$targeted_genomes)) {
    out$targeted_genomes <- pmos[[1]]$targeted_genomes
    for (gi in seq_along(pmos[[1]]$targeted_genomes)) {
      set(genomes_out, gsig(pmos[[1]]$targeted_genomes[[gi]]), gi)
    }
  }
  for (pi in 2:np) {
    if (is.null(pmos[[pi]]$targeted_genomes)) next
    for (gi in seq_along(pmos[[pi]]$targeted_genomes)) {
      g <- pmos[[pi]]$targeted_genomes[[gi]]
      sig <- gsig(g)
      if (has1(genomes_out, sig)) {
        set(genomes_old, .cm_key(pi, gi), get1(genomes_out, sig))
      } else {
        if (is.null(out$targeted_genomes)) out$targeted_genomes <- list()
        ni <- length(out$targeted_genomes) + 1L
        out$targeted_genomes[[ni]] <- g
        set(genomes_out, sig, ni)
        set(genomes_old, .cm_key(pi, gi), ni)
      }
    }
  }

  # --- target_info (dedup by target_name) ---------------------------------
  out$target_info <- pmos[[1]]$target_info
  target_out <- .cm_env()
  target_old <- .cm_env()
  for (ti in seq_along(pmos[[1]]$target_info)) {
    set(target_out, pmos[[1]]$target_info[[ti]]$target_name, ti)
  }
  remap_genome <- function(loc, pi) {
    if (!is.null(loc) && !is.null(loc$genome_id)) {
      loc$genome_id <- get1(genomes_old, .cm_key(pi, loc$genome_id))
    }
    loc
  }
  for (pi in 2:np) {
    for (ti in seq_along(pmos[[pi]]$target_info)) {
      target <- pmos[[pi]]$target_info[[ti]]
      if (has1(target_out, target$target_name)) {
        set(target_old, .cm_key(pi, ti), get1(target_out, target$target_name))
      } else {
        tc <- target
        if (!is.null(out$targeted_genomes) &&
            length(out$targeted_genomes) > 1) {
          if (!is.null(tc$insert_location)) {
            tc$insert_location <- remap_genome(tc$insert_location, pi)
          }
          if (!is.null(tc$forward_primer$location)) {
            tc$forward_primer$location <- remap_genome(tc$forward_primer$location,
                                                       pi)
          }
          if (!is.null(tc$reverse_primer$location)) {
            tc$reverse_primer$location <- remap_genome(tc$reverse_primer$location,
                                                       pi)
          }
        }
        ni <- length(out$target_info) + 1L
        out$target_info[[ni]] <- tc
        set(target_out, tc$target_name, ni)
        set(target_old, .cm_key(pi, ti), ni)
      }
    }
  }

  # --- panel_info (dedup by panel_name) -----------------------------------
  out$panel_info <- pmos[[1]]$panel_info
  panel_out <- .cm_env()
  panel_old <- .cm_env()
  for (i in seq_along(pmos[[1]]$panel_info)) {
    set(panel_out, pmos[[1]]$panel_info[[i]]$panel_name, i)
  }
  for (pi in 2:np) {
    for (i in seq_along(pmos[[pi]]$panel_info)) {
      panel <- pmos[[pi]]$panel_info[[i]]
      if (has1(panel_out, panel$panel_name)) {
        set(panel_old, .cm_key(pi, i), get1(panel_out, panel$panel_name))
      } else {
        pc <- panel
        for (ri in seq_along(pc$reactions)) {
          pts <- unlist(pc$reactions[[ri]]$panel_targets)
          pc$reactions[[ri]]$panel_targets <- vapply(
            pts, function(t) get1(target_old, .cm_key(pi, t)), numeric(1))
        }
        ni <- length(out$panel_info) + 1L
        out$panel_info[[ni]] <- pc
        set(panel_out, pc$panel_name, ni)
        set(panel_old, .cm_key(pi, i), ni)
      }
    }
  }

  # --- sequencing_info (concatenate) --------------------------------------
  seq_old <- .cm_env()
  if (!is.null(pmos[[1]]$sequencing_info)) {
    out$sequencing_info <- pmos[[1]]$sequencing_info
  }
  for (pi in 2:np) {
    if (is.null(pmos[[pi]]$sequencing_info)) next
    for (si in seq_along(pmos[[pi]]$sequencing_info)) {
      if (is.null(out$sequencing_info)) out$sequencing_info <- list()
      ni <- length(out$sequencing_info) + 1L
      out$sequencing_info[[ni]] <- pmos[[pi]]$sequencing_info[[si]]
      set(seq_old, .cm_key(pi, si), ni)
    }
  }

  # --- project_info (dedup by name; error on description mismatch) ---------
  proj_old <- .cm_env()
  if (!is.null(pmos[[1]]$project_info)) {
    out$project_info <- pmos[[1]]$project_info
  }
  for (pi in 2:np) {
    if (is.null(pmos[[pi]]$project_info)) next
    for (pj in seq_along(pmos[[pi]]$project_info)) {
      proj <- pmos[[pi]]$project_info[[pj]]
      found <- FALSE
      if (!is.null(out$project_info)) {
        for (ci in seq_along(out$project_info)) {
          cur <- out$project_info[[ci]]
          if (identical(cur$project_name, proj$project_name)) {
            if (!identical(cur$project_description, proj$project_description)) {
              stop("Project description mismatch for project_name: ",
                   proj$project_name)
            }
            set(proj_old, .cm_key(pi, pj), ci)
            found <- TRUE
            break
          }
        }
      }
      if (!found) {
        if (is.null(out$project_info)) out$project_info <- list()
        ni <- length(out$project_info) + 1L
        out$project_info[[ni]] <- proj
        set(proj_old, .cm_key(pi, pj), ni)
      }
    }
  }

  # --- specimen_info (dedup by name) --------------------------------------
  out$specimen_info <- pmos[[1]]$specimen_info
  spec_names <- character(0)
  spec_index <- .cm_env()
  dup_spec <- character(0)
  for (i in seq_along(out$specimen_info)) {
    nm <- out$specimen_info[[i]]$specimen_name
    if (nm %in% spec_names) dup_spec <- c(dup_spec, nm)
    set(spec_index, nm, i)
    spec_names <- c(spec_names, nm)
  }
  spec_old <- .cm_env()
  for (pi in 2:np) {
    for (si in seq_along(pmos[[pi]]$specimen_info)) {
      spec <- pmos[[pi]]$specimen_info[[si]]
      nm <- spec$specimen_name
      if (nm %in% spec_names) {
        existing <- get1(spec_index, nm)
        if (!identical(.canonicalise(spec),
                       .canonicalise(out$specimen_info[[existing]]))) {
          dup_spec <- c(dup_spec, nm)
        }
        set(spec_old, .cm_key(pi, si), existing)
      } else {
        sc <- spec
        if (!is.null(sc$project_id)) {
          sc$project_id <- get1(proj_old, .cm_key(pi, sc$project_id))
        }
        ni <- length(out$specimen_info) + 1L
        out$specimen_info[[ni]] <- sc
        set(spec_index, nm, ni)
        spec_names <- c(spec_names, nm)
        set(spec_old, .cm_key(pi, si), ni)
      }
    }
  }

  # --- library_sample_info (concatenate, remap) ---------------------------
  out$library_sample_info <- pmos[[1]]$library_sample_info
  lib_old <- .cm_env()
  dup_lib <- character(0)
  lib_names <- character(0)
  for (l in out$library_sample_info) {
    if (l$library_sample_name %in% lib_names) {
      dup_lib <- c(dup_lib, l$library_sample_name)
    }
    lib_names <- c(lib_names, l$library_sample_name)
  }
  for (pi in 2:np) {
    for (li in seq_along(pmos[[pi]]$library_sample_info)) {
      lib <- pmos[[pi]]$library_sample_info[[li]]
      if (lib$library_sample_name %in% lib_names) {
        dup_lib <- c(dup_lib, lib$library_sample_name)
      }
      lib_names <- c(lib_names, lib$library_sample_name)
      lc <- lib
      lc$specimen_id <- get1(spec_old, .cm_key(pi, lc$specimen_id))
      lc$panel_id <- get1(panel_old, .cm_key(pi, lc$panel_id))
      if (!is.null(lc$sequencing_info_id)) {
        lc$sequencing_info_id <- get1(seq_old, .cm_key(pi, lc$sequencing_info_id))
      }
      ni <- length(out$library_sample_info) + 1L
      out$library_sample_info[[ni]] <- lc
      set(lib_old, .cm_key(pi, li), ni)
    }
  }

  warns <- character(0)
  if (length(dup_spec) > 0) {
    warns <- c(warns, paste0("Duplicate specimen names were supplied for the ",
                             "following specimens: ",
                             paste(dup_spec, collapse = ",")))
  }
  if (length(dup_lib) > 0) {
    warns <- c(warns, paste0("Duplicate library sample names were supplied for ",
                             "the following librarys: ",
                             paste(dup_lib, collapse = ",")))
  }
  if (length(warns) > 0) stop(paste(warns, collapse = "\n"))

  # --- bioinformatics_methods_info (concatenate) --------------------------
  methods_old <- .cm_env()
  if (!is.null(pmos[[1]]$bioinformatics_methods_info)) {
    out$bioinformatics_methods_info <- pmos[[1]]$bioinformatics_methods_info
  }
  for (pi in 2:np) {
    if (is.null(pmos[[pi]]$bioinformatics_methods_info)) next
    for (mi in seq_along(pmos[[pi]]$bioinformatics_methods_info)) {
      if (is.null(out$bioinformatics_methods_info)) {
        out$bioinformatics_methods_info <- list()
      }
      ni <- length(out$bioinformatics_methods_info) + 1L
      out$bioinformatics_methods_info[[ni]] <-
        pmos[[pi]]$bioinformatics_methods_info[[mi]]
      set(methods_old, .cm_key(pi, mi), ni)
    }
  }

  # --- bioinformatics_run_info (concatenate, remap methods id) ------------
  run_old <- .cm_env()
  if (!is.null(pmos[[1]]$bioinformatics_run_info)) {
    out$bioinformatics_run_info <- pmos[[1]]$bioinformatics_run_info
  }
  for (pi in 2:np) {
    if (is.null(pmos[[pi]]$bioinformatics_run_info)) next
    for (ri in seq_along(pmos[[pi]]$bioinformatics_run_info)) {
      rc <- pmos[[pi]]$bioinformatics_run_info[[ri]]
      # remap using the run own methods id
      if (!is.null(rc$bioinformatics_methods_id)) {
        rc$bioinformatics_methods_id <- get1(
          methods_old, .cm_key(pi, rc$bioinformatics_methods_id))
      }
      if (is.null(out$bioinformatics_run_info)) {
        out$bioinformatics_run_info <- list()
      }
      ni <- length(out$bioinformatics_run_info) + 1L
      out$bioinformatics_run_info[[ni]] <- rc
      set(run_old, .cm_key(pi, ri), ni)
    }
  }

  # --- representative_microhaplotypes (dedup by target_name then seq) -----
  out$representative_microhaplotypes <- pmos[[1]]$representative_microhaplotypes
  rep_out <- .cm_env()   # target_name -> new mhaps_target index
  rep_old <- .cm_env()   # pmo|old_mt -> new_mt
  rep_hmap <- .cm_env()  # pmo|old_mt|old_mhap -> new_mhap
  for (i in seq_along(out$representative_microhaplotypes$targets)) {
    tgt <- out$representative_microhaplotypes$targets[[i]]
    tname <- out$target_info[[tgt$target_id]]$target_name
    set(rep_out, tname, i)
  }
  for (pi in 2:np) {
    rep_targets <- pmos[[pi]]$representative_microhaplotypes$targets
    for (ri in seq_along(rep_targets)) {
      rep <- rep_targets[[ri]]
      tname <- pmos[[pi]]$target_info[[rep$target_id]]$target_name
      if (has1(rep_out, tname)) {
        existing <- get1(rep_out, tname)
        set(rep_old, .cm_key(pi, ri), existing)
        for (mi in seq_along(rep$microhaplotypes)) {
          adding <- rep$microhaplotypes[[mi]]
          have <- out$representative_microhaplotypes$targets[[existing]]$microhaplotypes
          found <- FALSE
          for (hi in seq_along(have)) {
            if (identical(adding$seq, have[[hi]]$seq)) {
              set(rep_hmap, .cm_key(pi, ri, mi), hi)
              found <- TRUE
              break
            }
          }
          if (!found) {
            ni <- length(have) + 1L
            out$representative_microhaplotypes$targets[[existing]]$
              microhaplotypes[[ni]] <- adding
            set(rep_hmap, .cm_key(pi, ri, mi), ni)
          }
        }
      } else {
        rc <- rep
        # remap the new rep target target_id to the combined target_info
        rc$target_id <- get1(target_old, .cm_key(pi, rep$target_id))
        ni <- length(out$representative_microhaplotypes$targets) + 1L
        out$representative_microhaplotypes$targets[[ni]] <- rc
        set(rep_old, .cm_key(pi, ri), ni)
        set(rep_out, tname, ni)
        for (mi in seq_along(rep$microhaplotypes)) {
          set(rep_hmap, .cm_key(pi, ri, mi), mi)
        }
      }
    }
  }

  # --- detected_microhaplotypes (copy first, remap rest) ------------------
  out$detected_microhaplotypes <- pmos[[1]]$detected_microhaplotypes
  for (pi in 2:np) {
    for (dm in pmos[[pi]]$detected_microhaplotypes) {
      dmc <- dm
      for (ls_i in seq_along(dmc$library_samples)) {
        ls <- dmc$library_samples[[ls_i]]
        for (tr_i in seq_along(ls$target_results)) {
          tr <- ls$target_results[[tr_i]]
          old_mt <- tr$mhaps_target_id
          for (h_i in seq_along(tr$mhaps)) {
            tr$mhaps[[h_i]]$mhap_id <- get1(
              rep_hmap, .cm_key(pi, old_mt, tr$mhaps[[h_i]]$mhap_id))
          }
          tr$mhaps_target_id <- get1(rep_old, .cm_key(pi, old_mt))
          ls$target_results[[tr_i]] <- tr
        }
        ls$library_sample_id <- get1(lib_old, .cm_key(pi, ls$library_sample_id))
        dmc$library_samples[[ls_i]] <- ls
      }
      if (!is.null(dmc$bioinformatics_run_id)) {
        dmc$bioinformatics_run_id <- get1(run_old,
                                          .cm_key(pi, dmc$bioinformatics_run_id))
      }
      out$detected_microhaplotypes[[length(out$detected_microhaplotypes) + 1L]] <-
        dmc
    }
  }

  # --- read_counts_by_stage -----------------------------------------------
  with_rc <- which(vapply(pmos, function(p) !is.null(p$read_counts_by_stage),
                          logical(1)))
  if (length(with_rc) > 0) {
    if (!(1 %in% with_rc)) out$read_counts_by_stage <- list()
    for (pi in with_rc) {
      if (pi == 1) {
        out$read_counts_by_stage <- pmos[[1]]$read_counts_by_stage
      } else {
        for (rc in pmos[[pi]]$read_counts_by_stage) {
          rcc <- rc
          for (s_i in seq_along(rcc$read_counts_by_library_sample_by_stage)) {
            s <- rcc$read_counts_by_library_sample_by_stage[[s_i]]
            if (!is.null(s$read_counts_for_targets)) {
              for (t_i in seq_along(s$read_counts_for_targets)) {
                s$read_counts_for_targets[[t_i]]$target_id <- get1(
                  target_old, .cm_key(pi, s$read_counts_for_targets[[t_i]]$target_id))
              }
            }
            s$library_sample_id <- get1(lib_old, .cm_key(pi, s$library_sample_id))
            rcc$read_counts_by_library_sample_by_stage[[s_i]] <- s
          }
          if (!is.null(rcc$bioinformatics_run_id)) {
            rcc$bioinformatics_run_id <- get1(
              run_old, .cm_key(pi, rcc$bioinformatics_run_id))
          }
          out$read_counts_by_stage[[length(out$read_counts_by_stage) + 1L]] <- rcc
        }
      }
    }
  }

  out
}
