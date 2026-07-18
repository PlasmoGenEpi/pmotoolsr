# pmo_checker: schema loading, required-field helpers, JSON Schema validation

test_that("schema loading and version helpers work", {
  expect_equal(pmo_schema_version(), "1.1.0")
  schema <- pmo_load_schema_by_version("1.1.0")
  expect_true("$defs" %in% names(schema))
  expect_true("SpecimenInfo" %in% names(schema[["$defs"]]))
  expect_error(pmo_load_schema_by_version("9.9.9"), "not found")
})

test_that("required fields per class", {
  expect_equal(pmo_required_fields_for_class("SpecimenInfo"), "specimen_name")
  expect_setequal(
    pmo_required_fields_for_class("LibrarySampleInfo"),
    c("library_sample_name", "panel_id", "specimen_id")
  )
  expect_error(pmo_required_fields_for_class("NotAClass"), "not found in schema")
})

test_that("required base field check", {
  expect_true(pmo_check_required_base_fields(full_pmo()))
  expect_true(pmo_check_required_base_fields(minimum_pmo()))

  bad <- read_pmo_raw(test_path("fixtures", "full_pmo_example.json"))
  bad$panel_info <- NULL
  expect_error(pmo_check_required_base_fields(bad),
               "Missing required base fields: panel_info")
})

test_that("JSON Schema validation accepts valid PMOs (R6, file, list)", {
  pmo <- full_pmo()
  expect_true(pmo_validate_jsonschema(pmo))                      # R6
  expect_true(pmo_validate_jsonschema(                          # file path
    test_path("fixtures", "full_pmo_example.json")))
  expect_true(pmo_validate_jsonschema(                          # gzipped file
    test_path("fixtures", "minimum_Furstenau2025_PMO.json.gz")))
  raw <- read_pmo_raw(test_path("fixtures", "full_pmo_example.json"))
  expect_true(pmo_validate_jsonschema(raw))                     # raw list
})

test_that("JSON Schema validation against an explicit version", {
  expect_true(pmo_validate_jsonschema(full_pmo(), version = "1.0.0"))
})

test_that("JSON Schema validation rejects invalid PMOs", {
  raw <- read_pmo_raw(test_path("fixtures", "full_pmo_example.json"))
  raw$panel_info <- NULL
  expect_error(pmo_validate_jsonschema(raw), "failed JSON Schema validation")
  res <- pmo_validate_jsonschema(raw, error = FALSE)
  expect_false(isTRUE(res))
})

test_that("filter output validates against the schema", {
  pmo <- full_pmo()
  filtered <- pmo_filter_by_library_sample_ids(pmo, 1L)
  expect_true(pmo_validate_jsonschema(filtered))

  tgt <- pmo_filter_by_target_names(
    pmo, names(pmo_index_key_target_in_representative_microhaplotypes(pmo))[1:5]
  )
  expect_true(pmo_validate_jsonschema(tgt))
})

test_that("pmo_validate runs structural + schema checks", {
  pmo <- full_pmo()
  expect_true(pmo_validate(pmo))
  expect_true(pmo_validate(minimum_pmo()))
  # structural-only path
  expect_true(pmo_validate(pmo, schema_check = FALSE))
  # on a filtered raw list
  filtered <- pmo_filter_by_specimen_ids(pmo, 1L)
  expect_true(pmo_validate(filtered))
})
