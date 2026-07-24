# Export PMO header metadata

Export PMO header metadata

## Usage

``` r
pmo_export_pmo_header_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A one-row tibble.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_export_pmo_header_table(p)
#> # A tibble: 1 × 4
#>   pmo_version creation_date generation_method.program_n…¹ generation_method.pr…²
#>   <chr>       <chr>         <chr>                         <chr>                 
#> 1 v1.0.0      2025-11-03    elucidator combingallintopmo… 1.1.1                 
#> # ℹ abbreviated names: ¹​generation_method.program_name,
#> #   ²​generation_method.program_version
```
