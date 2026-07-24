# Count specimens grouped by combinations of metadata field values

Specimens missing a requested field are recorded as `"NA"` for that
field.

## Usage

``` r
pmo_count_specimen_by_field_value(pmo, meta_fields)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- meta_fields:

  A character vector of specimen metadata fields to group by.

## Value

A tibble with one column per requested field plus `specimens_count`,
`specimens_freq`, and `total_specimen_count`, sorted by the fields.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_count_specimen_by_field_value(p, "collection_country")
#> # A tibble: 1 × 4
#>   collection_country specimens_count specimens_freq total_specimen_count
#>   <chr>                        <int>          <dbl>                <int>
#> 1 Mozambique                       2              1                    2
```
