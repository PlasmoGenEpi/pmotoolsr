# Count how many specimens carry each metadata field

Count how many specimens carry each metadata field

## Usage

``` r
pmo_count_specimen_per_meta_fields(pmo)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

## Value

A tibble with columns `field`, `present_in_specimens_count`,
`total_specimen_count`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_count_specimen_per_meta_fields(p)
#> # A tibble: 12 × 3
#>    field                   present_in_specimens_count total_specimen_count
#>    <chr>                                        <int>                <int>
#>  1 collection_country                               2                    2
#>  2 collection_date                                  2                    2
#>  3 geo_admin3                                       2                    2
#>  4 host_taxon_id                                    2                    2
#>  5 lat_lon                                          2                    2
#>  6 parasite_density_info                            2                    2
#>  7 project_id                                       2                    2
#>  8 specimen_collect_device                          2                    2
#>  9 specimen_name                                    2                    2
#> 10 specimen_store_loc                               2                    2
#> 11 specimen_taxon_id                                2                    2
#> 12 storage_plate_info                               2                    2
```
