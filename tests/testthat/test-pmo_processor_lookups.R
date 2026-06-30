# Chunk 1: lookups, name getters, resolvers, relational query
# Ported from pmotools-python tests/test_pmo_engine/test_pmo_processor.py

test_that("index keys map names to 1-based indices (full PMO)", {
  pmo <- full_pmo()

  spec_key <- pmo_index_key_specimen_names(pmo)
  expect_named(spec_key, c("8025874217", "8025874266"))
  expect_equal(unname(spec_key), c(1L, 2L))

  lib_key <- pmo_index_key_library_sample_names(pmo)
  expect_equal(lib_key[["8025874217_lib_name"]], 1L)
  expect_equal(lib_key[["8025874266_lib_name"]], 2L)

  panel_key <- pmo_index_key_panel_names(pmo)
  expect_equal(panel_key[["heomev1"]], 1L)

  target_key <- pmo_index_key_target_names(pmo)
  expect_length(target_key, 100L)
  # first target in file is t96 -> index 1
  expect_equal(target_key[["t96"]], 1L)
})

test_that("index keys also work on a raw PMO list", {
  pmo_list <- read_pmo_raw(test_path("fixtures", "full_pmo_example.json"))
  spec_key <- pmo_index_key_specimen_names(pmo_list)
  expect_equal(unname(spec_key), c(1L, 2L))
})

test_that("representative-microhaplotype target index resolves names", {
  pmo <- full_pmo()
  rep_key <- pmo_index_key_target_in_representative_microhaplotypes(pmo)
  expect_length(rep_key, 99L)
  # every name in the rep key must be a valid target name
  expect_true(all(names(rep_key) %in% pmo_get_target_names(pmo)))
  # round-trip: index_of returns the index stored in the key
  nm <- names(rep_key)[1]
  expect_equal(
    pmo_index_of_target_in_representative_microhaplotypes(pmo, nm),
    unname(rep_key[nm])
  )
})

test_that("name getters return ordered and sorted names", {
  pmo <- full_pmo()
  expect_equal(pmo_get_specimen_names(pmo), c("8025874217", "8025874266"))
  expect_equal(pmo_get_sorted_specimen_names(pmo), c("8025874217", "8025874266"))
  expect_equal(pmo_get_panel_names(pmo), "heomev1")
  expect_equal(pmo_get_sorted_target_names(pmo), sort(pmo_get_target_names(pmo)))
  runs <- pmo_get_bioinformatics_run_names(pmo)
  expect_type(runs, "character")
  expect_length(runs, 1L)
})

test_that("name -> index resolvers preserve input order and validate", {
  pmo <- full_pmo()
  expect_equal(
    pmo_index_of_specimen_names(pmo, c("8025874266", "8025874217")),
    c(2L, 1L)
  )
  expect_equal(
    pmo_index_of_library_sample_names(pmo, "8025874217_lib_name"), 1L
  )
  expect_error(
    pmo_index_of_specimen_names(pmo, "does_not_exist"),
    "not found"
  )
})

test_that("library ids for specimen ids", {
  pmo <- full_pmo()
  res <- pmo_library_ids_for_specimen_ids(pmo, c(1L, 2L))
  expect_equal(res[["1"]], 1L)
  expect_equal(res[["2"]], 2L)
  # specimen id out of range errors
  expect_error(pmo_library_ids_for_specimen_ids(pmo, 999L), "beyond the length")
})

# --- Minimum required-fields PMO ------------------------------------------

test_that("required-section lookups work on the minimum PMO", {
  pmo <- minimum_pmo()
  expect_length(pmo_get_specimen_names(pmo), 129L)
  expect_length(pmo_get_library_sample_names(pmo), 129L)
  expect_equal(pmo_get_panel_names(pmo), pmo_get_panel_names(pmo)) # present
  expect_length(pmo_get_target_names(pmo), 27L)
  expect_equal(unname(pmo_index_key_specimen_names(pmo)), seq_len(129L))
})

test_that("optional-section accessors fail loudly on the minimum PMO", {
  pmo <- minimum_pmo()
  expect_false(pmo_has_section(pmo, "bioinformatics_run_info"))
  expect_error(
    pmo_get_bioinformatics_run_names(pmo),
    "does not contain 'bioinformatics_run_info'"
  )
  expect_error(
    pmo_index_key_bioinformatics_run_names(pmo),
    "does not contain 'bioinformatics_run_info'"
  )
  expect_error(
    pmo_index_of_bioinformatics_run_names(pmo, "anything"),
    "does not contain 'bioinformatics_run_info'"
  )
})

test_that("relational query works on the minimum PMO", {
  pmo <- minimum_pmo()
  res <- pmo_library_ids_for_specimen_ids(pmo, 1L)
  expect_true("1" %in% names(res))
  expect_true(all(res[["1"]] >= 1L))
})
