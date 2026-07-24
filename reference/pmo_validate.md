# Validate a PMO (structural and, by default, schema)

Runs the always-available structural checks (required base fields plus
the generated R6 `$validate()` constraints) and, when
`schema_check = TRUE`, full JSON Schema validation via
[`pmo_validate_jsonschema()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate_jsonschema.md).

## Usage

``` r
pmo_validate(pmo, schema_check = TRUE, schema = NULL, version = NULL)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- schema_check:

  If `TRUE` (default), also run JSON Schema validation.

- schema, version:

  Passed through to
  [`pmo_validate_jsonschema()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate_jsonschema.md).

## Value

Invisibly `TRUE`; raises an error on the first failure.

## Examples

``` r
pmo <- read_pmo(
  system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
pmo_validate(pmo)
```
