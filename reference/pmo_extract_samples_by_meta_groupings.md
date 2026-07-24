# Extract specimens matching metadata groupings

Keeps the specimens (and their libraries/results) that satisfy any of
the supplied metadata groups, returning the filtered PMO and a per-group
count table. A specimen matches a group when it has every field in that
group and the field's value is among the group's listed values.

## Usage

``` r
pmo_extract_samples_by_meta_groupings(pmo, meta_fields_values)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- meta_fields_values:

  File path or inline specification (see
  [`.parse_meta_groupings()`](https://plasmogenepi.github.io/pmotoolsr/reference/dot-parse_meta_groupings.md)).

## Value

A list with `pmo` (a filtered PMO list) and `group_counts` (a tibble
with a `group` column, one column per field, and a `count` column).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
res <- pmo_extract_samples_by_meta_groupings(p, "collection_country=Mozambique")
res$group_counts
#> # A tibble: 1 × 3
#>   group collection_country count
#>   <chr> <chr>              <int>
#> 1 0     Mozambique             2
```
