# Convert a raw PMO list into a PortableMicrohaplotypeObject

Wraps a plain nested PMO list (1-based ids, as produced by the filter
functions or
[`read_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo_raw.md))
into a
[PortableMicrohaplotypeObject](https://plasmogenepi.github.io/pmotoolsr/reference/PortableMicrohaplotypeObject.md)
R6 instance. Ids are preserved (the round-trip applies the write offset
and the read offset, which cancel out).

## Usage

``` r
pmo_list_to_r6(pmo_list, validate = TRUE)
```

## Arguments

- pmo_list:

  A PMO list with 1-based id fields.

- validate:

  Logical; validate the resulting object.

## Value

A `PortableMicrohaplotypeObject` instance.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
filtered <- pmo_filter_by_specimen_ids(p, 1L)
obj <- pmo_list_to_r6(filtered)
```
