# PMO schema checking / validation utilities
#
# Ported from pmotools-python's pmo_checker.py. The PMO JSON Schema is bundled
# under inst/extdata/schemas/. Validation uses jsonvalidate's ajv engine, which
# handles the schema's Draft 2019-09 dialect. The schema validates the *on-disk*
# (0-based) JSON form, so in-memory (1-based) PMOs are converted to their JSON
# representation (applying the write offset) before validation.

#' Default PMO schema version targeted by this package
#'
#' The R6 classes in this package were generated from this schema version.
#' @return A version string.
#' @examples
#' pmo_schema_version()
#' @export
pmo_schema_version <- function() {
  "1.1.0"
}

#' Path to a bundled PMO schema file
#' @keywords internal
.pmo_schema_path <- function(version = pmo_schema_version()) {
  fn <- sprintf("portable_microhaplotype_object_v%s.schema.json", version)
  p <- system.file("extdata", "schemas", fn, package = "pmotoolsr")
  if (!nzchar(p)) {
    stop("PMO schema version '", version,
         "' is not bundled with pmotoolsr (looked for ", fn, ")")
  }
  p
}

#' Load a bundled PMO JSON schema
#'
#' @param name Schema filename (e.g.
#'   `"portable_microhaplotype_object_v1.1.0.schema.json"`).
#' @return The parsed schema as a nested list.
#' @examples
#' schema <- pmo_load_schema("portable_microhaplotype_object_v1.1.0.schema.json")
#' names(schema)
#' @export
pmo_load_schema <- function(name) {
  p <- system.file("extdata", "schemas", name, package = "pmotoolsr")
  if (!nzchar(p)) {
    stop("PMO schema '", name, "' not found in pmotoolsr")
  }
  jsonlite::fromJSON(p, simplifyVector = FALSE)
}

#' Load a bundled PMO JSON schema by version
#'
#' @param version Version string (e.g. `"1.0.0"`, `"1.1.0"`).
#' @return The parsed schema as a nested list.
#' @examples
#' schema <- pmo_load_schema_by_version("1.1.0")
#' head(names(schema[["$defs"]]))
#' @export
pmo_load_schema_by_version <- function(version) {
  pmo_load_schema(sprintf("portable_microhaplotype_object_v%s.schema.json",
                          version))
}

#' @keywords internal
.pmo_default_schema <- function() {
  pmo_load_schema_by_version(pmo_schema_version())
}

#' Get the required fields for a PMO schema class
#'
#' @param class_name A schema class name (a key under the schema's `$defs`,
#'   e.g. `"SpecimenInfo"`).
#' @param schema Optional parsed schema; defaults to the bundled default.
#' @return A character vector of required field names (possibly empty).
#' @examples
#' pmo_required_fields_for_class("SpecimenInfo")
#' pmo_required_fields_for_class("LibrarySampleInfo")
#' @export
pmo_required_fields_for_class <- function(class_name, schema = NULL) {
  if (is.null(schema)) schema <- .pmo_default_schema()
  defs <- schema[["$defs"]]
  if (!(class_name %in% names(defs))) {
    stop("PMO class '", class_name, "' is not found in schema; available: ",
         paste(names(defs), collapse = ", "))
  }
  req <- unlist(defs[[class_name]][["required"]], use.names = FALSE)
  if (is.null(req)) character(0) else as.character(req)
}

#' Check that a PMO has all required top-level fields
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param schema Optional parsed schema; defaults to the bundled default.
#' @return Invisibly `TRUE`; raises an error listing any missing fields.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_check_required_base_fields(p)
#' @export
pmo_check_required_base_fields <- function(pmo, schema = NULL) {
  if (is.null(schema)) schema <- .pmo_default_schema()
  required <- unlist(schema[["required"]], use.names = FALSE)
  present <- names(.pmo_as_list(pmo))
  missing <- setdiff(required, present)
  if (length(missing) > 0) {
    stop("Missing required base fields: ", paste(missing, collapse = ", "))
  }
  invisible(TRUE)
}

#' Convert a PMO input to on-disk (0-based) JSON text
#'
#' Accepts an R6 PMO, a parsed PMO list, a path to a (optionally compressed)
#' JSON file, or a JSON string.
#' @keywords internal
.pmo_to_json_text <- function(x) {
  if (inherits(x, "PortableMicrohaplotypeObject")) {
    return(as.character(x$to_json()))
  }
  if (is.character(x) && length(x) == 1) {
    if (file.exists(x)) {
      con <- open_text_connection(x, "rt")
      on.exit(close(con), add = TRUE)
      return(paste(readLines(con, warn = FALSE), collapse = "\n"))
    }
    return(x) # assume already JSON text
  }
  if (is.list(x)) {
    json_ready <- pmo_raw_prepare_for_json(x)
    return(as.character(jsonlite::toJSON(json_ready, auto_unbox = TRUE,
                                         na = "string")))
  }
  stop("cannot convert input to PMO JSON text; supply an R6 PMO, a PMO list, ",
       "a file path, or a JSON string")
}

#' Resolve a schema argument to schema text for jsonvalidate
#' @keywords internal
.pmo_resolve_schema_text <- function(schema = NULL, version = NULL) {
  if (!is.null(schema)) {
    if (is.character(schema) && length(schema) == 1) {
      if (file.exists(schema)) {
        return(paste(readLines(schema, warn = FALSE), collapse = "\n"))
      }
      return(schema) # JSON text
    }
    if (is.list(schema)) {
      return(as.character(jsonlite::toJSON(schema, auto_unbox = TRUE,
                                           null = "null")))
    }
    stop("`schema` must be a file path, JSON string, or parsed schema list")
  }
  v <- if (is.null(version)) pmo_schema_version() else version
  paste(readLines(.pmo_schema_path(v), warn = FALSE), collapse = "\n")
}

#' Validate a PMO against the JSON Schema
#'
#' Performs full JSON Schema validation using \pkg{jsonvalidate} (ajv engine).
#' The PMO is converted to its on-disk (0-based) JSON form before validation.
#'
#' @param pmo A `PortableMicrohaplotypeObject`, parsed PMO list, file path, or
#'   JSON string.
#' @param schema Optional schema (file path, JSON string, or parsed list). If
#'   `NULL`, the bundled schema for `version` is used.
#' @param version Optional schema version to validate against (defaults to
#'   [pmo_schema_version()]). Lets you validate a raw PMO against a different
#'   schema version than the one the R6 classes were generated from.
#' @param engine jsonvalidate engine, `"ajv"` (default) or `"imjv"`.
#' @param error If `TRUE` (default), raise an error when validation fails;
#'   otherwise return the logical result (with an `errors` attribute).
#' @param verbose Passed to the validator to collect error details.
#' @return Invisibly `TRUE` when valid (or the logical result when
#'   `error = FALSE`).
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' pmo_validate_jsonschema(p)
#' @export
pmo_validate_jsonschema <- function(pmo, schema = NULL, version = NULL,
                                    engine = c("ajv", "imjv"),
                                    error = TRUE, verbose = TRUE) {
  engine <- match.arg(engine)
  schema_text <- .pmo_resolve_schema_text(schema, version)
  validator <- jsonvalidate::json_validator(schema_text, engine = engine)
  json_text <- .pmo_to_json_text(pmo)
  ok <- validator(json_text, verbose = verbose)
  if (!isTRUE(ok) && error) {
    errs <- attr(ok, "errors")
    msg <- "PMO failed JSON Schema validation"
    if (!is.null(errs) && nrow(errs) > 0) {
      pathcol <- intersect(c("instancePath", "dataPath", "schemaPath"),
                           names(errs))
      paths <- if (length(pathcol) > 0) errs[[pathcol[1]]] else rep("", nrow(errs))
      lines <- paste0("  - ", paths, ": ", errs$message)
      msg <- paste0(msg, " (", nrow(errs), " error(s)):\n",
                    paste(utils::head(lines, 20L), collapse = "\n"))
    }
    stop(msg)
  }
  if (error) invisible(isTRUE(ok)) else ok
}

#' Validate a PMO (structural and, by default, schema)
#'
#' Runs the always-available structural checks (required base fields plus the
#' generated R6 `$validate()` constraints) and, when `schema_check = TRUE`, full
#' JSON Schema validation via [pmo_validate_jsonschema()].
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param schema_check If `TRUE` (default), also run JSON Schema validation.
#' @param schema,version Passed through to [pmo_validate_jsonschema()].
#' @return Invisibly `TRUE`; raises an error on the first failure.
#' @examples
#' pmo <- read_pmo(
#'   system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
#' pmo_validate(pmo)
#' @export
pmo_validate <- function(pmo, schema_check = TRUE, schema = NULL,
                         version = NULL) {
  obj <- if (inherits(pmo, "PortableMicrohaplotypeObject")) {
    pmo
  } else {
    pmo_list_to_r6(pmo, validate = FALSE)
  }
  pmo_check_required_base_fields(obj)
  obj$validate()
  if (schema_check) {
    pmo_validate_jsonschema(obj, schema = schema, version = version,
                            error = TRUE)
  }
  invisible(TRUE)
}
