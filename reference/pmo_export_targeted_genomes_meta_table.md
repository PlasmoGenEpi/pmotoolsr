# Export targeted genomes metadata

Export targeted genomes metadata

## Usage

``` r
pmo_export_targeted_genomes_meta_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A tibble with a 1-based `genome_id` column.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_export_targeted_genomes_meta_table(p)
#> # A tibble: 1 × 7
#>   name  genome_version taxon_id genome_id url                chromosomes gff_url
#>   <chr> <chr>             <dbl>     <int> <chr>              <chr>       <chr>  
#> 1 3D7   2020-09-01         5833         1 https://plasmodb.… Pf3D7_01_v… https:…
```
