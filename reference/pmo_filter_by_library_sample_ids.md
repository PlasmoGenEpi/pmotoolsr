# Filter a PMO down to selected library samples

Returns a new PMO (as a raw nested list) containing only the supplied
library samples, their parent specimens, and their detected
microhaplotypes and read counts, with all ids remapped to the new
positions.

## Usage

``` r
pmo_filter_by_library_sample_ids(pmo, library_sample_ids)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- library_sample_ids:

  Integer vector of 1-based library sample ids.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
sub <- pmo_filter_by_library_sample_ids(p, 1L)
length(sub$library_sample_info)
#> [1] 1
```
