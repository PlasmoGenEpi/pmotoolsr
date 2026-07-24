# Filter a PMO down to selected library samples by name

Filter a PMO down to selected library samples by name

## Usage

``` r
pmo_filter_by_library_sample_names(pmo, library_sample_names)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- library_sample_names:

  Character vector of library sample names.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
nm <- pmo_get_library_sample_names(p)[1]
sub <- pmo_filter_by_library_sample_names(p, nm)
```
