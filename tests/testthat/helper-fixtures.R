# Shared fixture loaders for the test suite.
#
# `full` is a fully-populated PMO exercising every optional section.
# `minimum` is a truly minimal PMO carrying only the required sections, used to
# confirm that accessors for optional sections fail loudly when those sections
# are absent.

full_pmo <- function() {
  read_pmo(test_path("fixtures", "full_pmo_example.json"))
}

minimum_pmo <- function() {
  read_pmo(test_path("fixtures", "minimum_Furstenau2025_PMO.json.gz"))
}
