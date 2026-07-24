# Combine multiple PMOs into a single PMO

Combine multiple PMOs into a single PMO

## Usage

``` r
pmo_combine_pmos(pmos)
```

## Arguments

- pmos:

  A list of two or more PMOs (each a `PortableMicrohaplotypeObject` or a
  parsed PMO list).

## Value

The combined PMO as a raw nested list (1-based ids). Write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md),
convert with
[`pmo_list_to_r6()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_list_to_r6.md),
or validate with
[`pmo_validate()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate.md).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
a <- pmo_filter_by_specimen_ids(p, 1L)
b <- pmo_filter_by_specimen_ids(p, 2L)
combined <- pmo_combine_pmos(list(a, b))
length(combined$specimen_info)
#> [1] 2
```
