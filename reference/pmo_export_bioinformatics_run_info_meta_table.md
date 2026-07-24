# Export bioinformatics run info metadata

Export bioinformatics run info metadata

## Usage

``` r
pmo_export_bioinformatics_run_info_meta_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A tibble with a 1-based `run_id` column.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_export_bioinformatics_run_info_meta_table(p)
#> # A tibble: 1 × 4
#>   run_id bioinformatics_methods_id bioinformatics_run_name run_date  
#>    <int>                     <dbl> <chr>                   <chr>     
#> 1      1                         1 Mozambique2018-SeekDeep 2022-04-01
```
