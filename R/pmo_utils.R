# Internal helpers shared by the hand-written parts of the package.
#
# R/pmo_r6.R is generated from the schema, so new hand-written code belongs here
# or in the module that uses it.

# Encode a JSON-ready list as JSON text. `digits = NA` writes up to 15
# significant digits (jsonlite's default of 4 decimal places changes the data);
# a `digits` or `na` passed by the caller wins.
.pmo_json_encode <- function(x, pretty = FALSE, auto_unbox = TRUE, ...) {
  args <- list(...)
  if (!("digits" %in% names(args))) args$digits <- NA
  if (!("na" %in% names(args))) args$na <- "string"
  do.call(jsonlite::toJSON,
          c(list(x, pretty = pretty, auto_unbox = auto_unbox), args))
}
