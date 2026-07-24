# Filter a PMO down to selected specimens by name

Filter a PMO down to selected specimens by name

## Usage

``` r
pmo_filter_by_specimen_names(pmo, specimen_names)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- specimen_names:

  Character vector of specimen names.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
nm <- pmo_get_specimen_names(p)[1]
sub <- pmo_filter_by_specimen_names(p, nm)
```
