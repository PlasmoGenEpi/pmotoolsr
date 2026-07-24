# Export library sample metadata

Export library sample metadata

## Usage

``` r
pmo_export_library_sample_meta_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A tibble (`sequencing_info_id`/`specimen_id`/`panel_id` resolved to
their names).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_export_library_sample_meta_table(p))
#> # A tibble: 2 × 4
#>   library_sample_name sequencing_info_name specimen_name panel_name
#>   <chr>               <chr>                <chr>         <chr>     
#> 1 8025874217_lib_name Mozambique2018       8025874217    heomev1   
#> 2 8025874266_lib_name Mozambique2018       8025874266    heomev1   
```
