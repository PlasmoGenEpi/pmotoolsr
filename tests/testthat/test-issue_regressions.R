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
