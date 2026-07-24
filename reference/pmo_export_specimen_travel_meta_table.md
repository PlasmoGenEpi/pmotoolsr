# Export specimen travel metadata

One row per travel record in `travel_out_six_month`.

## Usage

``` r
pmo_export_specimen_travel_meta_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A tibble.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_export_specimen_travel_meta_table(p)
#> # A tibble: 0 × 0
```
