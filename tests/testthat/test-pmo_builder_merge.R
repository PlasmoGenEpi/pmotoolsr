# Builder chunk E: merge_to_pmo assembler + pmo_updater.
# Verified against pmotools-python (1-based ids); the assembled PMO is
# validated against the JSON schema (the full table -> PMO round trip).

merge_mhap_info <- function() {
  mhap <- data.frame(
    library_sample_name = c("S1", "S1", "S2"),
    target_name = c("t1", "t2", "t1"),
    seq = c("AAA", "GGG", "AAC"), reads = c(10, 20, 8),
    stringsAsFactors = FALSE)
  pmo_mhap_table_to_pmo(mhap)
}

merge_panel_info <- function() {
  panel <- data.frame(
    target_name = c("t1", "t2"), fwd_primer = c("AAAA", "CCCC"),
    rev_primer = c("TTTT", "GGGG"), stringsAsFactors = FALSE)
  pmo_panel_info_table_to_pmo(panel, "panelA")
}

test_that("merge auto-generates specimen/library and assigns 1-based ids", {
  pmo <- pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                          panel_target_info = merge_panel_info())
  expect_setequal(
    names(pmo),
    c("pmo_header", "library_sample_info", "specimen_info", "panel_info",
      "target_info", "representative_microhaplotypes",
      "detected_microhaplotypes"))

  expect_equal(pmo$library_sample_info[[1]]$specimen_id, 1L)
  expect_equal(pmo$library_sample_info[[1]]$panel_id, 1L)
  expect_equal(pmo$library_sample_info[[2]]$specimen_id, 2L)
  expect_null(pmo$library_sample_info[[1]]$specimen_name) # name popped

  expect_equal(
    vapply(pmo$representative_microhaplotypes$targets,
           function(t) t$target_id, numeric(1)), c(1, 2))
  lib_ids <- unlist(lapply(pmo$detected_microhaplotypes,
    function(d) vapply(d$library_samples,
                       function(s) s$library_sample_id, numeric(1))))
  expect_equal(sort(lib_ids), c(1, 2))
  expect_equal(unlist(pmo$panel_info[[1]]$reactions[[1]]$panel_targets),
               c(1L, 2L))
})

test_that("assembled PMO validates against the JSON schema", {
  pmo <- pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                          panel_target_info = merge_panel_info())
  expect_true(pmo_validate(pmo))
})

test_that("assembled PMO round-trips through write + read", {
  pmo <- pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                          panel_target_info = merge_panel_info())
  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp), add = TRUE)
  write_pmo_raw(pmo, tmp)
  reread <- read_pmo(tmp, validate = TRUE)
  expect_s3_class(reread, "PortableMicrohaplotypeObject")
  expect_length(reread$library_sample_info, 2L)
  # genome-less primer locations absent; specimen_id re-read as 1-based
  expect_equal(reread$library_sample_info[[1]]$specimen_id, 1L)
})

test_that("merge with explicit specimen/library/sequencing/project/bioinfo", {
  spec <- pmo_specimen_info_table_to_pmo(
    data.frame(specimen_name = c("S1", "S2"),
               project_name = c("proj1", "proj1"),
               collection_country = c("MZ", "MZ"), stringsAsFactors = FALSE),
    project_name_col = "project_name",
    collection_country_col = "collection_country")
  lib <- pmo_library_sample_info_table_to_pmo(
    data.frame(library_sample_name = c("S1", "S2"),
               specimen_name = c("S1", "S2"), panel_name = c("panelA", "panelA"),
               sequencing_info_name = c("run1", "run1"),
               stringsAsFactors = FALSE),
    sequencing_info_name_col = "sequencing_info_name")
  seqinfo <- list(list(sequencing_info_name = "run1", seq_platform = "ILLUMINA",
                       seq_instrument_model = "NextSeq 2000",
                       library_layout = "PAIRED", library_strategy = "AMPLICON",
                       library_source = "GENOMIC", library_selection = "PCR"))
  proj <- list(list(project_name = "proj1",
                    project_description = "test project"))
  methods <- list(list(methods = list(list(program = "tool",
                                           program_version = "v1.0.0"))))
  runs <- list(list(bioinformatics_run_name = "brun1",
                    bioinformatics_methods_id = "ignored"))

  mhap_info <- merge_mhap_info()
  for (i in seq_along(mhap_info$detected_microhaplotypes)) {
    mhap_info$detected_microhaplotypes[[i]]$bioinformatics_run_name <- "brun1"
  }

  pmo <- pmo_merge_to_pmo(
    mhap_info = mhap_info, panel_target_info = merge_panel_info(),
    specimen_info = spec, library_sample_info = lib, sequencing_info = seqinfo,
    project_info = proj, bioinfo_method_info = methods, bioinfo_run_info = runs)

  expect_equal(pmo$specimen_info[[1]]$project_id, 1L)
  expect_equal(pmo$library_sample_info[[1]]$sequencing_info_id, 1L)
  expect_equal(pmo$detected_microhaplotypes[[1]]$bioinformatics_run_id, 1L)
  expect_true("sequencing_info" %in% names(pmo))
  expect_true("project_info" %in% names(pmo))
})

test_that("merge errors on a missing referenced name", {
  lib <- pmo_library_sample_info_table_to_pmo(
    data.frame(library_sample_name = c("S1", "S2"),
               specimen_name = c("S1", "S2"),
               panel_name = c("WRONG", "WRONG"), stringsAsFactors = FALSE))
  expect_error(
    pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                     panel_target_info = merge_panel_info(),
                     library_sample_info = lib),
    "Panel names in Library Sample Info not in Panel Info"
  )
})

test_that("merge errors when bioinfo_run_info given without methods", {
  expect_error(
    pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                     panel_target_info = merge_panel_info(),
                     bioinfo_run_info = list(list(bioinformatics_run_name = "b"))),
    "bioinfo_method_info must be provided"
  )
})

# --- updater ---------------------------------------------------------------

test_that("traveler info is appended to specimens", {
  pmo <- pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                          panel_target_info = merge_panel_info())
  travel <- data.frame(
    specimen_name = c("S1", "S1"),
    travel_country = c("Kenya", "Tanzania"),
    travel_start_date = c("2023-01", "2023-03-15"),
    travel_end_date = c("2023-02", "2023-04-01"),
    stringsAsFactors = FALSE)
  updated <- pmo_update_specimen_with_traveler_info(pmo, travel)
  trips <- updated$specimen_info[[1]]$travel_out_six_month
  expect_length(trips, 2L)
  expect_equal(trips[[1]]$travel_country, "Kenya")
  expect_equal(trips[[2]]$travel_start_date, "2023-03-15")
  # S2 has none
  expect_null(updated$specimen_info[[2]]$travel_out_six_month)
})

test_that("traveler info errors on unknown specimen and bad date", {
  pmo <- pmo_merge_to_pmo(mhap_info = merge_mhap_info(),
                          panel_target_info = merge_panel_info())
  bad_spec <- data.frame(specimen_name = "nope", travel_country = "X",
                         travel_start_date = "2023-01", travel_end_date = "2023-02",
                         stringsAsFactors = FALSE)
  expect_error(pmo_update_specimen_with_traveler_info(pmo, bad_spec),
               "missing from the PMO")
  bad_date <- data.frame(specimen_name = "S1", travel_country = "X",
                         travel_start_date = "2023-13", travel_end_date = "2023-02",
                         stringsAsFactors = FALSE)
  expect_error(pmo_update_specimen_with_traveler_info(pmo, bad_date),
               "Invalid date format")
})

# --- merge_dicts_by_key ----------------------------------------------------

test_that("merge_dicts_by_key merges and respects replace flag", {
  main <- list(list(name = "a", x = 1), list(name = "b", x = 2))
  upd <- list(list(name = "a", y = 10))
  out <- suppressWarnings(pmo_merge_dicts_by_key(main, upd, "name"))
  expect_equal(out[[1]]$y, 10)
  expect_equal(out[[1]]$x, 1)

  upd_conflict <- list(list(name = "a", x = 99))
  expect_error(suppressWarnings(pmo_merge_dicts_by_key(main, upd_conflict, "name")),
               "already exists")
  out2 <- suppressWarnings(
    pmo_merge_dicts_by_key(main, upd_conflict, "name", replace = TRUE))
  expect_equal(out2[[1]]$x, 99)
})

test_that("merge_dicts_by_key errors on unknown update key", {
  main <- list(list(name = "a", x = 1))
  upd <- list(list(name = "z", y = 1))
  expect_error(pmo_merge_dicts_by_key(main, upd, "name"), "not found in")
})
