# Chunk 4: meta-grouping extraction, read filter, list<->R6 conversion

test_that("meta grouping (single group) keeps matching specimens", {
  pmo <- full_pmo()
  res <- pmo_extract_samples_by_meta_groupings(pmo, "collection_country=Mozambique")
  expect_named(res, c("pmo", "group_counts"))
  # both specimens are Mozambique
  expect_length(res$pmo$specimen_info, 2L)
  expect_equal(res$group_counts$count, 2L)
  expect_true("collection_country" %in% names(res$group_counts))
})

test_that("meta grouping on a discriminating field subsets specimens", {
  pmo <- full_pmo()
  res <- pmo_extract_samples_by_meta_groupings(pmo, "geo_admin3=Inhassoro")
  expect_length(res$pmo$specimen_info, 1L)
  expect_equal(res$pmo$specimen_info[[1]]$specimen_name, "8025874217")
  expect_equal(res$group_counts$count, 1L)
})

test_that("meta grouping with multiple groups unions specimens", {
  pmo <- full_pmo()
  res <- pmo_extract_samples_by_meta_groupings(
    pmo, "geo_admin3=Inhassoro;geo_admin3=Namaacha"
  )
  expect_equal(nrow(res$group_counts), 2L)
  expect_equal(sort(res$group_counts$count), c(1L, 1L))
  expect_length(res$pmo$specimen_info, 2L)
})

test_that("meta grouping errors on a missing field", {
  pmo <- full_pmo()
  expect_error(
    pmo_extract_samples_by_meta_groupings(pmo, "not_a_field=x"),
    "missing the field"
  )
})

test_that("meta grouping accepts a tab-delimited file with a group column", {
  pmo <- full_pmo()
  tmp <- tempfile(fileext = ".tsv")
  on.exit(unlink(tmp), add = TRUE)
  writeLines(c(
    "field\tvalues\tgroup",
    "geo_admin3\tInhassoro\tA",
    "geo_admin3\tNamaacha\tB"
  ), tmp)
  res <- pmo_extract_samples_by_meta_groupings(pmo, tmp)
  expect_setequal(res$group_counts$group, c("A", "B"))
  expect_length(res$pmo$specimen_info, 2L)
})

test_that("read filter keeps all at 0 and drops all at a huge threshold", {
  pmo <- full_pmo()

  keep_all <- pmo_extract_by_read_filter(pmo, 0)
  n_haps_all <- sum(vapply(keep_all$detected_microhaplotypes, function(dm) {
    sum(vapply(dm$library_samples, function(s) {
      sum(vapply(s$target_results, function(tr) length(tr$mhaps), integer(1)))
    }, integer(1)))
  }, integer(1)))
  expect_equal(n_haps_all, 251L)

  drop_all <- pmo_extract_by_read_filter(pmo, 1e9)
  for (dm in drop_all$detected_microhaplotypes) {
    expect_length(dm$library_samples, 0L)
  }
})

test_that("read filter removes only low-read microhaplotypes", {
  pmo <- full_pmo()
  out <- pmo_extract_by_read_filter(pmo, 1000)
  reads <- unlist(lapply(out$detected_microhaplotypes, function(dm) {
    lapply(dm$library_samples, function(s) {
      lapply(s$target_results, function(tr) {
        vapply(tr$mhaps, function(h) h$reads, numeric(1))
      })
    })
  }))
  expect_true(all(reads >= 1000))
})

test_that("read filter result round-trips", {
  pmo <- full_pmo()
  out <- pmo_extract_by_read_filter(pmo, 100)
  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp), add = TRUE)
  write_pmo_raw(out, tmp)
  reread <- read_pmo(tmp, validate = TRUE)
  expect_s3_class(reread, "PortableMicrohaplotypeObject")
})

test_that("pmo_list_to_r6 preserves 1-based ids and validates", {
  pmo <- full_pmo()
  filtered <- pmo_filter_by_library_sample_ids(pmo, 1L)
  obj <- pmo_list_to_r6(filtered)
  expect_s3_class(obj, "PortableMicrohaplotypeObject")
  expect_length(obj$library_sample_info, 1L)
  # panel_targets remain 1-based after the round-trip
  pt <- obj$panel_info[[1]]$reactions[[1]]$panel_targets
  expect_true(min(pt) >= 1L)
  # specimen_id remapped + 1-based
  expect_equal(obj$library_sample_info[[1]]$specimen_id, 1L)
})

test_that("pmo_list_to_r6 is idempotent on an R6 input", {
  pmo <- full_pmo()
  expect_identical(pmo_list_to_r6(pmo), pmo)
})

# --- Minimum required-fields PMO ------------------------------------------

test_that("read filter works on the minimum PMO without optional sections", {
  pmo <- minimum_pmo()
  out <- pmo_extract_by_read_filter(pmo, 1)
  expect_null(out$read_counts_by_stage)
  expect_null(out$sequencing_info)
  obj <- pmo_list_to_r6(out)
  expect_s3_class(obj, "PortableMicrohaplotypeObject")
})
