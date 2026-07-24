# Validate a PMO against the JSON Schema

Performs full JSON Schema validation using jsonvalidate (ajv engine).
The PMO is converted to its on-disk (0-based) JSON form before
validation.

## Usage

``` r
pmo_validate_jsonschema(
  pmo,
  schema = NULL,
  version = NULL,
  engine = c("ajv", "imjv"),
  error = TRUE,
  verbose = TRUE
)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject`, parsed PMO list, file path, or JSON
  string.

- schema:

  Optional schema (file path, JSON string, or parsed list). If `NULL`,
  the bundled schema for `version` is used.

- version:

  Optional schema version to validate against (defaults to
  [`pmo_schema_version()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_schema_version.md)).
  Lets you validate a raw PMO against a different schema version than
  the one the R6 classes were generated from.

- engine:

  jsonvalidate engine, `"ajv"` (default) or `"imjv"`.

- error:

  If `TRUE` (default), raise an error when validation fails; otherwise
  return the logical result (with an `errors` attribute).

- verbose:

  Passed to the validator to collect error details.

## Value

Invisibly `TRUE` when valid (or the logical result when
`error = FALSE`).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_validate_jsonschema(p)
```
