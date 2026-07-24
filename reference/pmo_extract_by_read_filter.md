# Filter detected microhaplotypes by a minimum read count

Returns a new PMO (as a raw nested list) keeping only detected
microhaplotypes with `reads >= read_filter`. Targets with no surviving
microhaplotypes, and samples with no surviving targets, are dropped. All
other sections (including `representative_microhaplotypes` and
`read_counts_by_stage`) are carried over unchanged.

## Usage

``` r
pmo_extract_by_read_filter(pmo, read_filter)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- read_filter:

  Minimum read count for a microhaplotype to be kept.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
sub <- pmo_extract_by_read_filter(p, 100)
```
