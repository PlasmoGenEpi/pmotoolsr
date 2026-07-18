# Chunk 2: counting / aggregation + allele extraction
# Ground-truth values computed from pmotools-python logic on the full fixture.

test_that("count_targets_per_library_sample matches reference", {
  pmo <- full_pmo()
  res <- pmo_count_targets_per_library_sample(pmo)
  expect_s3_class(res, "tbl_df")
  expect_named(res, c("bioinformatics_run_id", "library_sample_name",
                      "target_number"))
  # run id is 1-based in R (present in file)
  expect_true(all(res$bioinformatics_run_id == 1L))
  counts <- stats::setNames(res$target_number, res$library_sample_name)
  expect_equal(counts[["8025874217_lib_name"]], 99L)
  expect_equal(counts[["8025874266_lib_name"]], 85L)
})

test_that("min_reads filter reduces counted targets", {
  pmo <- full_pmo()
  hi <- pmo_count_targets_per_library_sample(pmo, min_reads = 1e9)
  expect_true(all(hi$target_number == 0L))
})

test_that("count_library_samples_per_target collapses across runs", {
  pmo <- full_pmo()
  res <- pmo_count_library_samples_per_target(pmo, collapse_across_runs = TRUE)
  expect_named(res, c("target_name", "sample_count"))
  expect_equal(nrow(res), 99L)
  expect_equal(sum(res$sample_count), 184L)
  # sorted by target_name
  expect_equal(res$target_name, sort(res$target_name))

  uncollapsed <- pmo_count_library_samples_per_target(pmo)
  expect_named(uncollapsed, c("bioinformatics_run_id", "target_name",
                              "sample_count"))
  expect_equal(sum(uncollapsed$sample_count), 184L)
})

test_that("count_targets_per_panel matches reference", {
  pmo <- full_pmo()
  res <- pmo_count_targets_per_panel(pmo)
  expect_named(res, c("panel_name", "panel_target_count"))
  expect_equal(res$panel_name, "heomev1")
  expect_equal(res$panel_target_count, 100L)
})

test_that("count_specimen_per_meta_fields matches reference", {
  pmo <- full_pmo()
  res <- pmo_count_specimen_per_meta_fields(pmo)
  expect_setequal(
    res$field,
    c("collection_country", "collection_date", "geo_admin3", "host_taxon_id",
      "lat_lon", "parasite_density_info", "project_id",
      "specimen_collect_device", "specimen_name", "specimen_store_loc",
      "specimen_taxon_id", "storage_plate_info")
  )
  expect_true(all(res$present_in_specimens_count == 2L))
  expect_true(all(res$total_specimen_count == 2L))
})

test_that("count_specimen_by_field_value groups and computes freq", {
  pmo <- full_pmo()
  res <- pmo_count_specimen_by_field_value(pmo, "collection_country")
  expect_true(all(c("collection_country", "specimens_count", "specimens_freq",
                    "total_specimen_count") %in% names(res)))
  expect_equal(sum(res$specimens_count), 2L)
  expect_equal(sum(res$specimens_freq), 1)
})

test_that("extract_allele_counts_freq matches reference", {
  pmo <- full_pmo()
  res <- pmo_extract_allele_counts_freq(pmo)
  expect_named(res, c("bioinformatics_run_id", "target_name", "mhap_id",
                      "count", "freq", "total_haps_per_target"))
  expect_equal(nrow(res), 181L)
  expect_equal(sum(res$count), 251L)
  expect_true(all(res$bioinformatics_run_id == 1L))
  expect_true(all(res$mhap_id >= 1L)) # 1-based

  coll <- pmo_extract_allele_counts_freq(pmo, collapse_across_runs = TRUE)
  expect_named(coll, c("target_name", "mhap_id", "count", "freq",
                       "target_total"))
  expect_equal(sum(coll$count), 251L)
  # freq within a target sums to 1
  per_target <- tapply(coll$freq, coll$target_name, sum)
  expect_true(all(abs(per_target - 1) < 1e-9))
})

test_that("allele extraction can filter by target name", {
  pmo <- full_pmo()
  some <- pmo_get_target_names(pmo)[1:3]
  res <- pmo_extract_allele_counts_freq(pmo, target_names = some)
  expect_true(all(res$target_name %in% some))
})

# --- Minimum required-fields PMO ------------------------------------------

test_that("counts work on the minimum PMO (no run id -> placeholder label)", {
  pmo <- minimum_pmo()
  res <- pmo_count_targets_per_library_sample(pmo)
  expect_s3_class(res, "tbl_df")
  expect_true(nrow(res) > 0)
  expect_true(all(res$bioinformatics_run_id ==
                    "detected_microhaplotypes_count_idx_0"))

  panel <- pmo_count_targets_per_panel(pmo)
  expect_true(panel$panel_target_count[1] > 0)

  fields <- pmo_count_specimen_per_meta_fields(pmo)
  # minimum specimens carry only specimen_name
  expect_equal(fields$field, "specimen_name")
  expect_equal(fields$present_in_specimens_count, 129L)
})

test_that("allele extraction errors on minimum PMO (no bioinformatics_run_id)", {
  pmo <- minimum_pmo()
  expect_error(
    pmo_extract_allele_counts_freq(pmo),
    "no bioinformatics_run_id"
  )
})
