# Export specimen metadata

Export specimen metadata

## Usage

``` r
pmo_export_specimen_meta_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A tibble of specimen metadata (`project_id` resolved to `project_name`;
complex nested fields omitted).

## Examples

``` r
pmo <- read_pmo(
  system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
head(pmo_export_specimen_meta_table(pmo))
#> # A tibble: 6 × 1
#>   specimen_name
#>   <chr>        
#> 1 SRR30825770  
#> 2 SRR30825771  
#> 3 SRR30825772  
#> 4 SRR30825773  
#> 5 SRR30825774  
#> 6 SRR30825775  
```
