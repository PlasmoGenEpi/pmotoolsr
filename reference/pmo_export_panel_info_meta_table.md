# Export panel info metadata

One row per (panel, target), with `reaction_name` listing the reactions
a target appears in.

## Usage

``` r
pmo_export_panel_info_meta_table(pmo, separator = ",")
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
head(pmo_export_panel_info_meta_table(p))
#> # A tibble: 6 × 3
#>   panel_name target_name reaction_name
#>   <chr>      <chr>       <chr>        
#> 1 heomev1    t96         full         
#> 2 heomev1    t95         full         
#> 3 heomev1    t94         full         
#> 4 heomev1    t50         full         
#> 5 heomev1    t36         full         
#> 6 heomev1    t88         full         
```
