# Export project info metadata

Export project info metadata

## Usage

``` r
pmo_export_project_info_meta_table(pmo, separator = ",")
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
pmo_export_project_info_meta_table(p)
#> # A tibble: 1 × 3
#>   project_collector_chief_scientist project_description             project_name
#>   <chr>                             <chr>                           <chr>       
#> 1 Greenhouse, Bryan                 Heome1 targeted amplicon seque… MOZ2018     
```
