# Filter a PMO down to selected specimens

Filter a PMO down to selected specimens

## Usage

``` r
pmo_filter_by_specimen_ids(pmo, specimen_ids)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- specimen_ids:

  Integer vector of 1-based specimen ids.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
sub <- pmo_filter_by_specimen_ids(p, 1L)
```
