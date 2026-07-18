# Chunk 3: filters that return a new (sub)PMO list with remapped indices.

test_that("filter_by_library_sample_ids keeps and remaps one sample", {
  pmo <- full_pmo()
  out <- pmo_filter_by_library_sample_ids(pmo, 1L)

  expect_length(out$library_sample_info, 1L)
  expect_length(out$specimen_info, 1L)
  # specimen_id remapped to the new 1-based position
  expect_equal(out$library_sample_info[[1]]$specimen_id, 1L)

  # detected microhaplotypes keep only the selected sample, remapped to id 1
  for (dm in out$detected_microhaplotypes) {
    ids <- vapply(dm$library_samples, function(s) s$library_sample_id, numeric(1))
    expect_true(all(ids == 1L))
    expect_length(dm$library_samples, 1L)
  }
})

test_that("read_counts_by_stage survives the library filter (regression)", {
  pmo <- full_pmo()
  expect_true(pmo_has_section(pmo, "read_counts_by_stage"))
  out <- pmo_filter_by_library_sample_ids(pmo, 1L)
  # the Python bug returned an empty list here; ours retains + remaps it
  expect_true(length(out$read_counts_by_stage) >= 1L)
  for (rc in out$read_counts_by_stage) {
    samples <- rc$read_counts_by_library_sample_by_stage
    expect_length(samples, 1L)
    expect_equal(samples[[1]]$library_sample_id, 1L)
  }
})

test_that("library filter result round-trips through write_pmo_raw + read_pmo", {
  pmo <- full_pmo()
  out <- pmo_filter_by_library_sample_ids(pmo, c(1L, 2L))
  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp), add = TRUE)
  write_pmo_raw(out, tmp)
  reread <- read_pmo(tmp, validate = TRUE)
  expect_s3_class(reread, "PortableMicrohaplotypeObject")
  expect_length(reread$library_sample_info, 2L)
})

test_that("filter_by_library_sample_names delegates correctly", {
  pmo <- full_pmo()
  out <- pmo_filter_by_library_sample_names(pmo, "8025874217_lib_name")
  expect_length(out$library_sample_info, 1L)
  expect_equal(out$library_sample_info[[1]]$library_sample_name,
               "8025874217_lib_name")
})

test_that("filter_by_specimen_ids / names keep the specimen's libraries", {
  pmo <- full_pmo()
  by_id <- pmo_filter_by_specimen_ids(pmo, 1L)
  expect_length(by_id$specimen_info, 1L)
  expect_equal(by_id$specimen_info[[1]]$specimen_name, "8025874217")

  by_name <- pmo_filter_by_specimen_names(pmo, "8025874217")
  expect_equal(
    length(by_name$library_sample_info),
    length(by_id$library_sample_info)
  )
})

test_that("filter_by_target_names restricts and remaps targets", {
  pmo <- full_pmo()
  rep_names <- names(
    pmo_index_key_target_in_representative_microhaplotypes(pmo)
  )
  pick <- rep_names[1:5]
  out <- pmo_filter_by_target_names(pmo, pick)

  expect_length(out$target_info, 5L)
  expect_length(out$representative_microhaplotypes$targets, 5L)
  kept_target_names <- vapply(out$target_info, function(t) t$target_name,
                              character(1))
  expect_setequal(kept_target_names, pick)

  # representative target_id values now point within 1:5
  rep_tids <- vapply(out$representative_microhaplotypes$targets,
                     function(t) t$target_id, numeric(1))
  expect_true(all(rep_tids >= 1L & rep_tids <= 5L))

  # detected mhaps_target_id values now point within 1:5
  for (dm in out$detected_microhaplotypes) {
    for (sample in dm$library_samples) {
      for (tr in sample$target_results) {
        expect_true(tr$mhaps_target_id >= 1L && tr$mhaps_target_id <= 5L)
      }
    }
  }

  # panel_targets remapped within range
  for (panel in out$panel_info) {
    for (reaction in panel$reactions) {
      pts <- unlist(reaction$panel_targets)
      expect_true(all(pts >= 1L & pts <= 5L))
    }
  }
})

test_that("target filter result round-trips through write + read", {
  pmo <- full_pmo()
  rep_names <- names(
    pmo_index_key_target_in_representative_microhaplotypes(pmo)
  )
  out <- pmo_filter_by_target_names(pmo, rep_names[1:10])
  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp), add = TRUE)
  write_pmo_raw(out, tmp)
  reread <- read_pmo(tmp, validate = TRUE)
  expect_length(reread$target_info, 10L)
})

test_that("filtering by a target absent from representatives errors", {
  pmo <- full_pmo()
  all_names <- pmo_get_target_names(pmo)
  rep_names <- names(
    pmo_index_key_target_in_representative_microhaplotypes(pmo)
  )
  missing <- setdiff(all_names, rep_names)
  expect_length(missing, 1L)
  expect_error(
    pmo_filter_by_target_names(pmo, missing),
    "not in representative_microhaplotypes"
  )
})

test_that("out-of-range ids error", {
  pmo <- full_pmo()
  expect_error(pmo_filter_by_library_sample_ids(pmo, 999L),
               "beyond the length")
  expect_error(pmo_filter_by_specimen_ids(pmo, 999L),
               "beyond the length")
})

# --- Minimum required-fields PMO ------------------------------------------

test_that("filters work on the minimum PMO (no optional sections)", {
  pmo <- minimum_pmo()
  out <- pmo_filter_by_library_sample_ids(pmo, 1L)
  expect_length(out$library_sample_info, 1L)
  # optional sections stay absent
  expect_null(out$read_counts_by_stage)
  expect_null(out$sequencing_info)

  # round-trip the minimal filtered PMO
  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp), add = TRUE)
  write_pmo_raw(out, tmp)
  reread <- read_pmo(tmp, validate = TRUE)
  expect_s3_class(reread, "PortableMicrohaplotypeObject")
})
