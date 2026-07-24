# Filter a PMO down to selected targets by name

Filter a PMO down to selected targets by name

## Usage

``` r
pmo_filter_by_target_names(pmo, target_names)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- target_names:

  Character vector of target names.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
pmo <- read_pmo(
  system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
keep <- pmo_get_target_names(pmo)[1:3]
sub <- pmo_filter_by_target_names(pmo, keep)
length(sub$target_info)
#> [1] 3
```
