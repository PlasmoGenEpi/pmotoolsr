# Count the number of unique targets in each panel

Count the number of unique targets in each panel

## Usage

``` r
pmo_count_targets_per_panel(pmo)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

## Value

A tibble with columns `panel_name`, `panel_target_count`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_count_targets_per_panel(p)
#> # A tibble: 1 × 2
#>   panel_name panel_target_count
#>   <chr>                   <int>
#> 1 heomev1                   100
```
