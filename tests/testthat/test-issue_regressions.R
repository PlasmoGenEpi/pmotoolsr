# Regression tests for reported bugs. Each test names the GitHub issue it covers.

reg_mhap <- function() {
  data.frame(library_sample_name = c("s1", "s2"), target_name = "t1",
             seq = c("ACGT", "ACGA"), reads = c(10, 7))
}
reg_panel <- function() {
  data.frame(target_name = "t1", fwd_primer = "ACGT", rev_primer = "TTGA")
}
reg_pmo <- function(mhap = reg_mhap(), ...) {
  pmo_merge_to_pmo(pmo_mhap_table_to_pmo(mhap, "run1"),
                   pmo_panel_info_table_to_pmo(reg_panel(), "panel1"), ...)
}
on_disk <- function(path) jsonlite::fromJSON(path, simplifyVector = FALSE)
reg_totals <- function() {
  data.frame(library_sample_name = c("s1", "s2"), total_raw_count = c(1000, 2000))
}
reg_mask <- function(tbl) {
  pmo_mhap_table_to_pmo(
    tbl, masking_seq_start_col = "start", masking_seq_segment_size_col = "size",
    masking_replacement_size_col = "repl")
}

# --- #5: only the schema's index fields are shifted --------------------------

test_that("#5 a numeric column ending in _id is written unchanged", {
  spec <- data.frame(specimen_name = c("s1", "s2"), household_id = c(12, 40))
  pmo <- reg_pmo(specimen_info = pmo_specimen_info_table_to_pmo(
    spec, additional_specimen_cols = "household_id"))
  f1 <- tempfile(fileext = ".json")
  write_pmo_raw(pmo, f1)
  expect_equal(vapply(on_disk(f1)$specimen_info, function(s) s$household_id,
                      numeric(1)), c(12, 40))

  # the same value survives every read path, and a second write
  expect_equal(read_pmo_raw(f1)$specimen_info[[1]]$household_id, 12)
  f2 <- tempfile(fileext = ".json")
  write_pmo_raw(pmo_filter_by_specimen_ids(read_pmo(f1), 1:2), f2)
  expect_equal(vapply(on_disk(f2)$specimen_info, function(s) s$household_id,
                      numeric(1)), c(12, 40))
})

test_that("#5 a column of your own named like an index field is not shifted", {
  spec <- data.frame(specimen_name = c("s1", "s2"), target_id = c(5, 9),
                     specimen_id = c(3, 4))
  mhap <- reg_mhap()
  mhap$target_id <- c(7, 8)
  pmo <- reg_pmo(
    mhap = mhap,
    specimen_info = pmo_specimen_info_table_to_pmo(
      spec, additional_specimen_cols = c("target_id", "specimen_id")))
  # the builder does not know about additional mhap columns until asked
  pmo <- pmo_merge_to_pmo(
    pmo_mhap_table_to_pmo(mhap, "run1", additional_mhap_detected_cols = "target_id"),
    pmo_panel_info_table_to_pmo(reg_panel(), "panel1"),
    specimen_info = pmo$specimen_info)
  f <- tempfile(fileext = ".json")
  write_pmo_raw(pmo, f)
  d <- on_disk(f)
  expect_equal(d$specimen_info[[1]]$target_id, 5)
  expect_equal(d$specimen_info[[2]]$specimen_id, 4)
  mhaps <- d$detected_microhaplotypes[[1]]$library_samples[[1]]$
    target_results[[1]]$mhaps
  expect_equal(mhaps[[1]]$target_id, 7)
  # the real index fields beside them are still shifted
  expect_equal(d$representative_microhaplotypes$targets[[1]]$target_id, 0)
  expect_equal(vapply(d$library_sample_info, function(l) l$specimen_id,
                      numeric(1)), c(0, 1))
  back <- read_pmo_raw(f)
  expect_equal(back$specimen_info[[1]]$target_id, 5)
  expect_equal(back$representative_microhaplotypes$targets[[1]]$target_id, 1)
})

test_that("#5 a text column ending in _id can be written, validated and read", {
  spec <- data.frame(specimen_name = c("s1", "s2"),
                     household_id = c("h12", "h40"))
  pmo <- reg_pmo(specimen_info = pmo_specimen_info_table_to_pmo(
    spec, additional_specimen_cols = "household_id"))
  expect_true(pmo_validate(pmo))
  f <- tempfile(fileext = ".json")
  write_pmo_raw(pmo, f)
  expect_equal(read_pmo_raw(f)$specimen_info[[2]]$household_id, "h40")
})

test_that("#5 index fields are still 0-based on disk and 1-based in memory", {
  pmo <- reg_pmo()
  f <- tempfile(fileext = ".json")
  write_pmo_raw(pmo, f)
  d <- on_disk(f)
  expect_equal(vapply(d$library_sample_info, function(l) l$specimen_id,
                      numeric(1)), c(0, 1))
  expect_equal(d$detected_microhaplotypes[[1]]$library_samples[[2]]$
                 target_results[[1]]$mhaps[[1]]$mhap_id, 1)
  expect_equal(d$panel_info[[1]]$reactions[[1]]$panel_targets, list(0L))
  back <- read_pmo_raw(f)
  expect_equal(vapply(back$library_sample_info, function(l) l$specimen_id,
                      numeric(1)), c(1, 2))
  expect_false(pmo_should_apply_id_offset("host_taxon_id"))
  expect_false(pmo_should_apply_id_offset("host_subject_id"))
  expect_true(pmo_should_apply_id_offset("target_id", "targets"))
  expect_false(pmo_should_apply_id_offset("target_id", "specimen_info"))
})

# --- #6: numbers keep their precision ----------------------------------------

test_that("#6 decimal numbers are written without rounding", {
  spec <- data.frame(specimen_name = c("s1", "s2"),
                     host_age = c(0.123456789, 31.5), density = 875.130981445312,
                     method = "qpcr")
  pmo <- reg_pmo(specimen_info = pmo_specimen_info_table_to_pmo(
    spec, host_age_col = "host_age", parasite_density_col = "density",
    parasite_density_method_col = "method"))

  f_raw <- tempfile(fileext = ".json")
  write_pmo_raw(pmo, f_raw)
  expect_equal(on_disk(f_raw)$specimen_info[[1]]$host_age, 0.123456789)

  r6 <- pmo_list_to_r6(pmo)
  expect_equal(r6$specimen_info[[1]]$host_age, 0.123456789)
  f_r6 <- tempfile(fileext = ".json")
  write_pmo(r6, f_r6)
  d <- on_disk(f_r6)$specimen_info[[1]]
  expect_equal(d$host_age, 0.123456789)
  expect_equal(d$parasite_density_info[[1]]$parasite_density, 875.130981445312)
})

test_that("#6 the shipped example survives a read and write unchanged", {
  path <- system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr")
  out <- tempfile(fileext = ".json")
  write_pmo(read_pmo(path), out)
  dens <- function(p) unlist(lapply(on_disk(p)$specimen_info, function(s) {
    lapply(s$parasite_density_info, function(x) x$parasite_density)
  }))
  expect_identical(dens(out), dens(path))
})

# --- #7: missing and malformed required values stop the builders ------------

test_that("#7 a missing value in a required microhaplotype column is an error", {
  for (col in c("library_sample_name", "target_name", "seq", "reads")) {
    m <- reg_mhap()
    m[[col]][2] <- NA
    expect_error(pmo_mhap_table_to_pmo(m), sprintf("_col = \"%s\"", col),
                 fixed = TRUE)
  }
})

test_that("#7 an empty or blank cell in a required column is an error", {
  m <- reg_mhap()
  m$seq[2] <- ""
  expect_error(pmo_mhap_table_to_pmo(m),
               "Missing values in required column(s) of microhaplotype_table: seq_col = \"seq\"",
               fixed = TRUE)
  m <- reg_mhap()
  m$library_sample_name[1] <- "  "
  expect_error(pmo_mhap_table_to_pmo(m), "library_sample_name_col")
  p <- reg_panel()
  p$rev_primer <- ""
  expect_error(pmo_panel_info_table_to_pmo(p, "panel1"),
               "reverse_primers_seq_col = \"rev_primer\"", fixed = TRUE)
  expect_error(
    pmo_specimen_info_table_to_pmo(data.frame(sample = c("s1", "")),
                                   specimen_name_col = "sample"),
    "specimen_name_col = \"sample\"", fixed = TRUE)
})

test_that("#7 a missing target name or primer is an error", {
  for (col in c("target_name", "fwd_primer", "rev_primer")) {
    p <- data.frame(target_name = c("t1", "t2"), fwd_primer = c("ACGT", "ACGA"),
                    rev_primer = c("TTGA", "TTGC"))
    p[[col]][2] <- NA
    expect_error(pmo_panel_info_table_to_pmo(p, "panel1"),
                 sprintf("= \"%s\"", col), fixed = TRUE)
  }
})

test_that("#7 a missing read count is an error", {
  totals <- reg_totals()
  totals$total_raw_count[2] <- NA
  expect_error(pmo_read_count_by_stage_table_to_pmo(totals),
               "total_raw_count_col = \"total_raw_count\"", fixed = TRUE)
  long <- data.frame(library_sample_name = c("s1", "s2"), target_name = "t1",
                     stage = "final", read_count = c(5, NA))
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(reg_totals(), reads_by_stage_table = long),
    "read_count_col = \"read_count\"", fixed = TRUE)
})

test_that("#7 a count that is not a whole number of 0 or more is an error", {
  m <- reg_mhap()
  m$reads <- c("10", "abc")
  expect_error(pmo_mhap_table_to_pmo(m),
               "reads_col = \"reads\" must hold whole numbers of 0 or more, got: abc",
               fixed = TRUE)
  m$reads <- c(10, -1)
  expect_error(pmo_mhap_table_to_pmo(m), "got: -1", fixed = TRUE)
  # counts given as text are read as numbers
  m$reads <- c("10", "7")
  reads <- pmo_mhap_table_to_pmo(m)$detected_microhaplotypes[[1]]$
    library_samples[[1]]$target_results[[1]]$mhaps[[1]]$reads
  expect_identical(reads, 10L)

  totals <- reg_totals()
  totals$total_raw_count <- c("1000", "many")
  expect_error(pmo_read_count_by_stage_table_to_pmo(totals), "got: many")
  long <- data.frame(library_sample_name = c("s1", "s2"), target_name = "t1",
                     stage = "final", read_count = c("5", "x"))
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(reg_totals(), reads_by_stage_table = long),
    "read_count_col = \"read_count\" must hold whole numbers", fixed = TRUE)
})

test_that("#7 a masking value that is not a whole number is an error", {
  m <- data.frame(library_sample_name = "s1", target_name = "t1", seq = "ACGT",
                  reads = 1, start = "5", size = "1", repl = "1")
  expect_equal(reg_mask(m)$representative_microhaplotypes$targets[[1]]$
                 microhaplotypes[[1]]$masking[[1]]$seq_start, 5L)
  bad <- m
  bad$start <- "5.5"
  expect_error(reg_mask(bad),
               "masking_seq_start_col = \"start\" must hold whole numbers, got '5.5'",
               fixed = TRUE)
  bad <- m
  bad$size <- "x"
  expect_error(reg_mask(bad), "masking_seq_segment_size_col = \"size\"",
               fixed = TRUE)
  for (value in c("3e10", "Inf")) {
    bad <- m
    bad$start <- value
    expect_error(reg_mask(bad), "whole numbers")
  }
})

test_that("#7 a missing run name is an error", {
  m <- data.frame(run = c("r1", NA), library_sample_name = c("s1", "s2"),
                  target_name = "t1", seq = c("ACGT", "ACGA"), reads = c(10, 7))
  expect_error(pmo_mhap_table_to_pmo(m, "run"),
               "bioinformatics_run_name = \"run\"", fixed = TRUE)

  totals <- data.frame(library_sample_name = c("s1", "s1"),
                       total_raw_count = c(1000, 1500), run = c("r1", "r2"))
  reads <- data.frame(library_sample_name = c("s1", "s1", "s1"), target_name = "t",
                      stage = "x", read_count = c(1, 2, 3), run = c("r1", "r9", NA))
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(totals, "run",
                                         reads_by_stage_table = reads),
    "reads_by_stage_table: bioinformatics_run_name = \"run\"", fixed = TRUE)
  totals_na <- totals
  totals_na$run[2] <- NA
  expect_error(pmo_read_count_by_stage_table_to_pmo(totals_na, "run"),
               "total_raw_count_table: bioinformatics_run_name = \"run\"",
               fixed = TRUE)
  # a reads row for a run that has no totals is left out, as in pmotools-python
  out <- pmo_read_count_by_stage_table_to_pmo(
    totals, "run", reads_by_stage_table = reads[1:2, ])
  expect_length(out[[1]]$read_counts_by_library_sample_by_stage[[1]]$
                  read_counts_for_targets[[1]]$stages, 1L)
  expect_null(out[[2]]$read_counts_by_library_sample_by_stage[[1]]$
                read_counts_for_targets)
})

# --- #8: a column argument must name a real column ---------------------------

test_that("#8 a misspelled column argument is an error", {
  panel2 <- data.frame(target_name = c("t1", "t2"), fwd_primer = c("ACGT", "ACGA"),
                       rev_primer = c("TTGA", "TTGC"), pool = c("A", "B"))
  expect_error(pmo_panel_info_table_to_pmo(panel2, "p", reaction_name_col = "Pool"),
               "reaction_name_col = \"Pool\"", fixed = TRUE)
  expect_error(pmo_panel_info_table_to_pmo(panel2, "p", gene_name_col = "gene"),
               "gene_name_col")
  expect_error(pmo_mhap_table_to_pmo(reg_mhap(), umis_col = "umi"), "umis_col")
  expect_error(pmo_mhap_table_to_pmo(reg_mhap(), reads_col = "Reads"),
               "reads_col")
  expect_error(
    pmo_mhap_table_to_pmo(reg_mhap(), additional_mhap_detected_cols = "x"),
    "additional_mhap_detected_cols = \"x\"", fixed = TRUE)

  spec <- data.frame(specimen_name = "s1", density = 1200, plate = "P1")
  expect_error(pmo_specimen_info_table_to_pmo(spec, parasite_density_col = "Density"),
               "parasite_density_col = \"Density\"", fixed = TRUE)
  expect_error(
    pmo_specimen_info_table_to_pmo(spec, collection_country_col = "Country"),
    "Column(s) not found in contents: collection_country_col = \"Country\"",
    fixed = TRUE)
  expect_error(pmo_specimen_info_table_to_pmo(spec, additional_specimen_cols = "x"),
               "additional_specimen_cols = \"x\"", fixed = TRUE)
  expect_error(pmo_specimen_info_table_to_pmo(spec, host_subject_id = "subj"),
               "host_subject_id = \"subj\"", fixed = TRUE)
  expect_error(pmo_specimen_info_table_to_pmo(spec, storage_plate_name_col = "Plate"),
               "storage_plate_name_col = \"Plate\"", fixed = TRUE)
  lib <- data.frame(library_sample_name = "l1", specimen_name = "s1",
                    panel_name = "p")
  expect_error(pmo_library_sample_info_table_to_pmo(
    lib, library_prep_plate_name_col = "Plate"), "library_prep_plate_name_col")

  totals <- data.frame(sample = "l1", total_raw_count = 10)
  expect_error(pmo_read_count_by_stage_table_to_pmo(totals),
               "library_sample_name_col = \"library_sample_name\"", fixed = TRUE)
  long <- data.frame(library_sample_name = "l1", target_name = "t1",
                     stage = "final", read_count = 5)
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(
      data.frame(library_sample_name = "l1", total_raw_count = 10),
      reads_by_stage_table = long, target_name_col = "locus"),
    "target_name_col = \"locus\"", fixed = TRUE)
})

test_that("#8 the library-to-specimen key table is checked too", {
  detected <- pmo_mhap_table_to_pmo(reg_mhap())$detected_microhaplotypes
  key <- data.frame(lib = c("s1", "s2"), specimen = c("A", "B"))
  expect_error(
    pmo_minimum_library_specimen_from_mhap_table(detected, "panel1",
                                                 library_sample_specimen_key = key),
    "library_sample_specimen_key: library_sample_name_col = \"library_sample_name\"; specimen_name_col = \"specimen_name\"",
    fixed = TRUE)
  out <- pmo_minimum_library_specimen_from_mhap_table(
    detected, "panel1", library_sample_specimen_key = key,
    library_sample_name_col = "lib", specimen_name_col = "specimen")
  expect_equal(vapply(out$specimen_info, function(s) s$specimen_name, ""),
               c("A", "B"))
})

test_that("#8 the run column may be listed as an additional column", {
  totals <- data.frame(library_sample_name = c("s1", "s1"),
                       total_raw_count = c(1000, 1500), run = c("r1", "r2"))
  out <- pmo_read_count_by_stage_table_to_pmo(
    totals, "run", additional_library_sample_cols = "run")
  expect_length(out, 2L)
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(
      totals, "run", additional_library_sample_cols = "nope"),
    "additional_library_sample_cols = \"nope\"", fixed = TRUE)
})

# --- #9: order does not depend on the locale ---------------------------------

test_that("#9 targets and samples are ordered by code point", {
  # testthat runs in the C locale, where sort() already gives this order. Switch
  # to a locale that sorts text differently so the test can fail.
  old <- Sys.getlocale("LC_COLLATE")
  on.exit(Sys.setlocale("LC_COLLATE", old), add = TRUE)
  differs <- FALSE
  for (loc in c("en_US.UTF-8", "C.UTF-8", "English_United States.utf8")) {
    set <- suppressWarnings(Sys.setlocale("LC_COLLATE", loc))
    if (nzchar(set) && !identical(sort(c("tb", "tB", "t_")), c("tB", "t_", "tb"))) {
      differs <- TRUE
      break
    }
  }
  skip_if_not(differs, "no locale with a collation other than C is available")

  m <- data.frame(library_sample_name = c("b", "B", "a", "_"),
                  target_name = c("tb", "tB", "ta", "t_"), seq = "A", reads = 1)
  out <- pmo_mhap_table_to_pmo(m)
  expect_equal(
    vapply(out$representative_microhaplotypes$targets,
           function(t) t$target_name, character(1)),
    c("tB", "t_", "ta", "tb"))
  expect_equal(
    vapply(out$detected_microhaplotypes[[1]]$library_samples,
           function(s) s$library_sample_name, character(1)),
    c("B", "_", "a", "b"))
})

# --- #10: numeric names ------------------------------------------------------

test_that("#10 numeric target and sample names are written as text", {
  m <- data.frame(library_sample_name = c(101, 102), target_name = c(1, 1),
                  seq = c("ACGT", "ACGA"), reads = c(10, 7))
  p <- data.frame(target_name = 1, fwd_primer = "ACGT", rev_primer = "TTGA")
  pmo <- pmo_merge_to_pmo(pmo_mhap_table_to_pmo(m, "run1"),
                          pmo_panel_info_table_to_pmo(p, "panel1"))
  expect_true(pmo_validate(pmo))
  expect_identical(pmo$target_info[[1]]$target_name, "1")
  expect_identical(pmo_get_library_sample_names(pmo), c("101", "102"))
})

test_that("#10 numeric names in the metadata tables are written as text", {
  spec <- pmo_specimen_info_table_to_pmo(data.frame(specimen_name = c(101, 102)))
  expect_identical(spec[[1]]$specimen_name, "101")
  lib <- pmo_library_sample_info_table_to_pmo(
    data.frame(library_sample_name = c(101, 102), specimen_name = c(101, 102),
               panel_name = "panel1"))
  expect_identical(lib[[2]]$library_sample_name, "102")
  m <- data.frame(library_sample_name = c(101, 102), target_name = "t1",
                  seq = c("ACGT", "ACGA"), reads = c(10, 7))
  pmo <- reg_pmo(mhap = m, specimen_info = spec, library_sample_info = lib)
  expect_true(pmo_validate(pmo))
})

test_that("#10 a large numeric name is written in full, whatever the column type", {
  expect_identical(.as_text(c(100000, 2.5, NA)), c("100000", "2.5", NA))
  expect_identical(.as_text(100000L), "100000")
  expect_identical(.as_text(factor("t1")), "t1")

  # the target is a double in one table and an integer in the other
  m <- data.frame(library_sample_name = c(100000, 200000), target_name = 100000,
                  seq = c("ACGT", "ACGA"), reads = c(10, 7))
  p <- data.frame(target_name = 100000L, fwd_primer = "ACGT", rev_primer = "TTGA")
  totals <- data.frame(library_sample_name = c(100000L, 200000L),
                       total_raw_count = c(50, 60))
  pmo <- pmo_merge_to_pmo(
    pmo_mhap_table_to_pmo(m, "run1"), pmo_panel_info_table_to_pmo(p, "panel1"),
    read_counts_by_stage_info = pmo_read_count_by_stage_table_to_pmo(totals, "run1"))
  expect_identical(pmo$target_info[[1]]$target_name, "100000")
  expect_identical(pmo_get_library_sample_names(pmo), c("100000", "200000"))
  expect_true(pmo_validate(pmo))
})

test_that("#10 numeric run names are written as text", {
  m <- reg_mhap()
  m$run <- c(1, 2)
  runs <- pmo_mhap_table_to_pmo(m, "run")$detected_microhaplotypes
  expect_identical(vapply(runs, function(d) d$bioinformatics_run_name, ""),
                   c("1", "2"))
  expect_identical(pmo_mhap_table_to_pmo(reg_mhap(), 7)$detected_microhaplotypes[[1]]$
                     bioinformatics_run_name, "7")

  totals <- reg_totals()
  totals$run <- c(1, 1)
  out <- pmo_read_count_by_stage_table_to_pmo(totals, "run")
  expect_identical(out[[1]]$bioinformatics_run_name, "1")
  expect_identical(pmo_read_count_by_stage_table_to_pmo(reg_totals(), 7)[[1]]$
                     bioinformatics_run_name, "7")
})

# --- #11: a library sample in more than one run ------------------------------

test_that("#11 a library sample may appear in several bioinformatics runs", {
  m <- data.frame(run = c("run1", "run2", "run2"),
                  library_sample_name = c("s1", "s1", "s2"), target_name = "t1",
                  seq = "ACGT", reads = c(10, 12, 3))
  pmo <- pmo_merge_to_pmo(pmo_mhap_table_to_pmo(m, "run"),
                          pmo_panel_info_table_to_pmo(reg_panel(), "panel1"))
  expect_length(pmo$detected_microhaplotypes, 2L)
  expect_equal(pmo_get_library_sample_names(pmo), c("s1", "s2"))
  expect_equal(pmo_get_specimen_names(pmo), c("s1", "s2"))
  # both runs point at the same library sample
  expect_equal(pmo$detected_microhaplotypes[[1]]$library_samples[[1]]$
                 library_sample_id, 1L)
  expect_equal(pmo$detected_microhaplotypes[[2]]$library_samples[[1]]$
                 library_sample_id, 1L)
  expect_true(pmo_validate(pmo))
})

test_that("#11 a name repeated within one run is still an error", {
  detected <- list(list(library_samples = list(
    list(library_sample_name = "s1"), list(library_sample_name = "s1"))))
  expect_error(pmo_minimum_library_specimen_from_mhap_table(detected, "panel1"),
               "Duplicate library sample names")
})

# --- #12: the mapped column is the one that is read --------------------------

test_that("#12 the mapped column is used when another column has the field name", {
  spec <- data.frame(specimen_name = c("old1", "old2"), sample = c("s1", "s2"),
                     country = "Mozambique", collection_country = "WRONG")
  out <- pmo_specimen_info_table_to_pmo(spec, specimen_name_col = "sample",
                                        collection_country_col = "country")
  expect_equal(vapply(out, function(s) s$specimen_name, character(1)),
               c("s1", "s2"))
  expect_equal(out[[1]]$collection_country, "Mozambique")

  lib <- data.frame(library_sample_name = c("old1", "old2"), lib = c("l1", "l2"),
                    specimen_name = c("s1", "s2"), panel_name = "p")
  out <- pmo_library_sample_info_table_to_pmo(lib, library_sample_name_col = "lib")
  expect_equal(vapply(out, function(s) s$library_sample_name, character(1)),
               c("l1", "l2"))
})

test_that("#12 two columns may not become the same PMO field", {
  spec <- data.frame(specimen_name = c("old1", "old2"), sample = c("s1", "s2"))
  expect_error(
    pmo_specimen_info_table_to_pmo(spec, specimen_name_col = "sample",
                                   additional_specimen_cols = "specimen_name"),
    "Columns \"sample\" and \"specimen_name\" would both become the PMO field \"specimen_name\"",
    fixed = TRUE)
  expect_error(
    pmo_specimen_info_table_to_pmo(spec, specimen_name_col = "sample",
                                   additional_specimen_cols = "sample"),
    "additional_specimen_cols lists column(s) that are already mapped to a PMO field: sample",
    fixed = TRUE)
  # a column listed again under the field of its own name changes nothing
  out <- pmo_specimen_info_table_to_pmo(spec, additional_specimen_cols = "specimen_name")
  expect_equal(out[[1]], list(specimen_name = "old1"))
  lib <- data.frame(library_sample_name = "old", lib = "l1", specimen_name = "s1",
                    panel_name = "p")
  expect_error(
    pmo_library_sample_info_table_to_pmo(
      lib, library_sample_name_col = "lib",
      additional_library_sample_info_cols = "library_sample_name"),
    "would both become the PMO field \"library_sample_name\"", fixed = TRUE)
})

test_that("#12 plate and density values come from the right row", {
  spec <- data.frame(specimen_name = c("s1", "s2", "s3"),
                     density = c(10, NA, 30), method = "qpcr",
                     pos = c("A1", "B02", "h12"))
  out <- pmo_specimen_info_table_to_pmo(
    spec, parasite_density_col = "density", parasite_density_method_col = "method",
    storage_plate_position_col = "pos")
  expect_equal(out[[1]]$parasite_density_info[[1]]$parasite_density, 10)
  expect_null(out[[2]]$parasite_density_info)
  expect_equal(out[[3]]$parasite_density_info[[1]]$parasite_density, 30)
  expect_equal(out[[2]]$storage_plate_info, list(plate_row = "B", plate_col = 2L))
  expect_equal(out[[3]]$storage_plate_info, list(plate_row = "H", plate_col = 12L))
})

# --- #13: both writers accept both representations ---------------------------

test_that("#13 write_pmo() and write_pmo_raw() accept a list or an R6 object", {
  pmo <- reg_pmo()
  r6 <- pmo_list_to_r6(pmo)
  paths <- replicate(4, tempfile(fileext = ".json"))
  write_pmo_raw(pmo, paths[1])
  write_pmo(pmo, paths[2])
  write_pmo(r6, paths[3])
  write_pmo_raw(r6, paths[4])
  ref <- read_pmo_raw(paths[1])
  for (p in paths[-1]) {
    got <- read_pmo_raw(p)
    expect_equal(got[sort(names(got))], ref[sort(names(ref))],
                 ignore_attr = TRUE, list_as_map = TRUE)
  }
  expect_error(write_pmo("not a pmo", tempfile()), "PMO list")
  expect_error(write_pmo_raw("not a pmo", tempfile()), "PMO list")
})

test_that("#13 write_pmo() still validates a list by default", {
  pmo <- reg_pmo()
  pmo$specimen_info[[1]]$specimen_name <- NULL
  expect_error(write_pmo(pmo, tempfile(fileext = ".json")), "specimen_name")
})

test_that("#13 extra JSON arguments reach the encoder for either representation", {
  spec <- data.frame(specimen_name = c("s1", "s2"), host_age = c(0.123456789, 31))
  pmo <- reg_pmo(specimen_info = pmo_specimen_info_table_to_pmo(
    spec, host_age_col = "host_age"))
  age <- function(p) on_disk(p)$specimen_info[[1]]$host_age
  for (obj in list(pmo, pmo_list_to_r6(pmo))) {
    for (writer in list(write_pmo, write_pmo_raw)) {
      f <- tempfile(fileext = ".json")
      writer(obj, f, digits = 2)
      expect_equal(age(f), 0.12)
    }
  }
})

# --- #17: wide read counts with one stage column -----------------------------

test_that("#17 a wide read-count table with one stage column is accepted", {
  totals <- reg_totals()
  wide <- data.frame(library_sample_name = c("s1", "s2"), target_name = "t1",
                     Reads = c(13, 4))
  out <- pmo_read_count_by_stage_table_to_pmo(
    totals, reads_by_stage_table = wide, stage_col = "Reads", wide = TRUE)
  s1 <- out[[1]]$read_counts_by_library_sample_by_stage[[1]]
  expect_equal(s1$read_counts_for_targets[[1]]$stages,
               list(list(stage = "Reads", reads = 13L)))
  # counts read as text are accepted too
  wide$Reads <- c("13", "4")
  out <- pmo_read_count_by_stage_table_to_pmo(
    totals, reads_by_stage_table = wide, stage_col = "Reads", wide = TRUE)
  expect_equal(out[[1]]$read_counts_by_library_sample_by_stage[[2]]$
                 read_counts_for_targets[[1]]$stages[[1]]$reads, 4L)
  # without wide = TRUE one stage column means long format, and the error says
  # how to ask for wide
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(
      totals, reads_by_stage_table = wide, stage_col = "Reads"),
    "wide = TRUE")
  # several stage columns are wide by default
  wide$Final <- c(10, 3)
  out <- pmo_read_count_by_stage_table_to_pmo(
    totals, reads_by_stage_table = wide, stage_col = c("Reads", "Final"))
  expect_length(out[[1]]$read_counts_by_library_sample_by_stage[[1]]$
                  read_counts_for_targets[[1]]$stages, 2L)

  # long format is unchanged, and a long table without its count column fails
  long <- data.frame(library_sample_name = c("s1", "s2"), target_name = "t1",
                     stage = "final", read_count = c(13, 4))
  out <- pmo_read_count_by_stage_table_to_pmo(totals, reads_by_stage_table = long)
  expect_equal(out[[1]]$read_counts_by_library_sample_by_stage[[2]]$
                 read_counts_for_targets[[1]]$stages[[1]],
               list(stage = "final", reads = 4L))
  expect_error(
    pmo_read_count_by_stage_table_to_pmo(
      totals, reads_by_stage_table = long[c("library_sample_name", "target_name",
                                            "stage")]),
    "read_count")
})

# --- #22: plate positions ----------------------------------------------------

test_that("#22 blank plate positions are skipped and spaces are ignored", {
  spec <- data.frame(specimen_name = c("s1", "s2", "s3", "s4"),
                     position = c("A01", NA, " c3 ", ""), plate = "P1")
  out <- pmo_specimen_info_table_to_pmo(
    spec, storage_plate_position_col = "position", storage_plate_name_col = "plate")
  expect_equal(out[[1]]$storage_plate_info,
               list(plate_name = "P1", plate_row = "A", plate_col = 1L))
  expect_equal(out[[2]]$storage_plate_info, list(plate_name = "P1"))
  expect_equal(out[[3]]$storage_plate_info,
               list(plate_name = "P1", plate_row = "C", plate_col = 3L))
  expect_equal(out[[4]]$storage_plate_info, list(plate_name = "P1"))

  spec$position[2] <- "Z99"
  expect_error(
    pmo_specimen_info_table_to_pmo(spec, storage_plate_position_col = "position"),
    "Got: Z99", fixed = TRUE)

  lib <- data.frame(library_sample_name = c("l1", "l2"), specimen_name = "s1",
                    panel_name = "p", well = c("H12", NA))
  out <- pmo_library_sample_info_table_to_pmo(
    lib, library_prep_plate_position_col = "well")
  expect_equal(out[[1]]$library_prep_plate_info,
               list(plate_row = "H", plate_col = 12L))
  expect_null(out[[2]]$library_prep_plate_info)
})
