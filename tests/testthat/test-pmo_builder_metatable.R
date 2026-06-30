# Builder chunk C: specimen / library metadata tables -> PMO structures.
# Structure verified against pmotools-python.

spec_fixture_df <- function() {
  data.frame(
    specimen_name = c("sp1", "sp2"),
    collection_country = c("Mozambique", "Mozambique"),
    alt_ids = c("A,B", "C"),
    plate = c("plateX", "plateX"), row = c("A", "B"), col = c(1L, 2L),
    density = c(1200, 800), method = c("microscopy", "qpcr"),
    stringsAsFactors = FALSE
  )
}

build_spec_fixture <- function() {
  pmo_specimen_info_table_to_pmo(
    spec_fixture_df(), collection_country_col = "collection_country",
    alternate_identifiers_col = "alt_ids", storage_plate_name_col = "plate",
    storage_plate_row_col = "row", storage_plate_col_col = "col",
    parasite_density_col = "density", parasite_density_method_col = "method")
}

test_that("specimen records carry mapped + list + nested fields", {
  out <- build_spec_fixture()
  expect_length(out, 2L)
  sp1 <- out[[1]]
  expect_equal(sp1$specimen_name, "sp1")
  expect_equal(sp1$collection_country, "Mozambique")
  expect_equal(sp1$alternate_identifiers, c("A", "B"))
  expect_equal(sp1$storage_plate_info,
               list(plate_name = "plateX", plate_row = "A", plate_col = 1L))
  expect_length(sp1$parasite_density_info, 1L)
  expect_equal(sp1$parasite_density_info[[1]]$parasite_density, 1200)
  expect_equal(sp1$parasite_density_info[[1]]$parasite_density_method,
               "microscopy")
  # single-value list field still becomes a length-1 vector
  expect_equal(out[[2]]$alternate_identifiers, "C")
})

test_that("empty optional (non-recommended) fields are omitted", {
  df <- spec_fixture_df()
  df$admin1 <- c("Inhambane", NA)
  out <- pmo_specimen_info_table_to_pmo(df, geo_admin1_col = "admin1")
  expect_true("geo_admin1" %in% names(out[[1]]))
  expect_false("geo_admin1" %in% names(out[[2]]))
})

test_that("null recommended column errors", {
  df <- spec_fixture_df()
  df$collection_country <- c("Mozambique", NA)
  expect_error(
    pmo_specimen_info_table_to_pmo(df,
      collection_country_col = "collection_country"),
    "null values"
  )
})

test_that("plate position is parsed into row/col", {
  df <- data.frame(specimen_name = c("sp1", "sp2"),
                   pos = c("A01", "h12"), stringsAsFactors = FALSE)
  out <- pmo_specimen_info_table_to_pmo(df, storage_plate_name_col = NULL,
                                        storage_plate_position_col = "pos")
  expect_equal(out[[1]]$storage_plate_info$plate_row, "A")
  expect_equal(out[[1]]$storage_plate_info$plate_col, 1L)
  expect_equal(out[[2]]$storage_plate_info$plate_row, "H")
  expect_equal(out[[2]]$storage_plate_info$plate_col, 12L)
})

test_that("invalid plate position errors", {
  df <- data.frame(specimen_name = "sp1", pos = "Z99", stringsAsFactors = FALSE)
  expect_error(
    pmo_specimen_info_table_to_pmo(df, storage_plate_position_col = "pos"),
    "plate position"
  )
})

test_that("position + col together errors", {
  df <- data.frame(specimen_name = "sp1", pos = "A01", col = 1L,
                   row = "A", stringsAsFactors = FALSE)
  expect_error(
    pmo_specimen_info_table_to_pmo(df, storage_plate_position_col = "pos",
                                   storage_plate_col_col = "col",
                                   storage_plate_row_col = "row"),
    "not both"
  )
})

test_that("multiple parasite density columns produce multiple entries", {
  df <- data.frame(specimen_name = "sp1", d1 = 100, d2 = 200,
                   m1 = "microscopy", m2 = "qpcr", stringsAsFactors = FALSE)
  out <- pmo_specimen_info_table_to_pmo(
    df, parasite_density_col = c("d1", "d2"),
    parasite_density_method_col = c("m1", "m2"))
  expect_length(out[[1]]$parasite_density_info, 2L)
  expect_equal(out[[1]]$parasite_density_info[[2]]$parasite_density, 200)
})

test_that("null required column errors", {
  df <- spec_fixture_df()
  df$specimen_name <- c("sp1", NA)
  expect_error(pmo_specimen_info_table_to_pmo(df), "null values")
})

test_that("duplicate column selection errors", {
  df <- spec_fixture_df()
  expect_error(
    pmo_specimen_info_table_to_pmo(df, collection_country_col = "alt_ids",
                                   alternate_identifiers_col = "alt_ids"),
    "must be unique"
  )
})

# --- library samples -------------------------------------------------------

test_that("library sample records are name-based", {
  lib <- data.frame(library_sample_name = c("l1", "l2"),
                    specimen_name = c("sp1", "sp2"),
                    panel_name = c("p", "p"), stringsAsFactors = FALSE)
  out <- pmo_library_sample_info_table_to_pmo(lib)
  expect_length(out, 2L)
  expect_equal(out[[1]]$library_sample_name, "l1")
  expect_equal(out[[1]]$specimen_name, "sp1")
  expect_equal(out[[1]]$panel_name, "p")
})

test_that("library alternate_identifiers listify and plate info", {
  lib <- data.frame(
    library_sample_name = c("l1", "l2"), specimen_name = c("sp1", "sp2"),
    panel_name = c("p", "p"), alt = c("x,y", "z"),
    plate = c("LP", "LP"), prow = c("A", "B"), pcol = c(1L, 2L),
    stringsAsFactors = FALSE)
  out <- pmo_library_sample_info_table_to_pmo(
    lib, alternate_identifiers_col = "alt",
    library_prep_plate_name_col = "plate",
    library_prep_plate_row_col = "prow", library_prep_plate_col_col = "pcol")
  expect_equal(out[[1]]$alternate_identifiers, c("x", "y"))
  expect_equal(out[[1]]$library_prep_plate_info$plate_name, "LP")
})

test_that("library plate is matched per library (not per specimen)", {
  # two libraries of the SAME specimen but on different plate wells
  lib <- data.frame(
    library_sample_name = c("l1", "l2"), specimen_name = c("sp1", "sp1"),
    panel_name = c("p", "p"), prow = c("A", "B"), pcol = c(1L, 2L),
    stringsAsFactors = FALSE)
  out <- pmo_library_sample_info_table_to_pmo(
    lib, library_prep_plate_row_col = "prow",
    library_prep_plate_col_col = "pcol")
  expect_equal(out[[1]]$library_prep_plate_info$plate_row, "A")
  expect_equal(out[[1]]$library_prep_plate_info$plate_col, 1L)
  # second library gets ITS OWN plate well, not the first's
  expect_equal(out[[2]]$library_prep_plate_info$plate_row, "B")
  expect_equal(out[[2]]$library_prep_plate_info$plate_col, 2L)
})

test_that("library density uses qpcr_parasite_density_info schema field", {
  lib <- data.frame(
    library_sample_name = c("l1", "l2"), specimen_name = c("sp1", "sp2"),
    panel_name = c("p", "p"), density = c(10, 100),
    method = c("qPCR", "microscopy"), stringsAsFactors = FALSE)
  out <- pmo_library_sample_info_table_to_pmo(
    lib, parasite_density_col = "density",
    parasite_density_method_col = "method")
  expect_true("qpcr_parasite_density_info" %in% names(out[[1]]))
  expect_false("parasite_density_info" %in% names(out[[1]]))
  expect_equal(out[[1]]$qpcr_parasite_density_info[[1]]$parasite_density, 10)
})
