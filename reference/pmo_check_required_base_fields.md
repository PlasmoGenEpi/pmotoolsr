# Check that a PMO has all required top-level fields

Check that a PMO has all required top-level fields

## Usage

``` r
pmo_check_required_base_fields(pmo, schema = NULL)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- schema:

  Optional parsed schema; defaults to the bundled default.

## Value

Invisibly `TRUE`; raises an error listing any missing fields.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_check_required_base_fields(p)
```
