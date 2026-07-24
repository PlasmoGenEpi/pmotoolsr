# Filter a PMO down to selected targets

Returns a new PMO (as a raw nested list) restricted to the supplied
targets, remapping `target_info`, `panel_info`,
`representative_microhaplotypes`, `detected_microhaplotypes`, and
`read_counts_by_stage` to the new target positions.

## Usage

``` r
pmo_filter_by_target_ids(pmo, target_ids)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- target_ids:

  Integer vector of 1-based target ids.

## Value

A PMO list (write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)).

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
sub <- pmo_filter_by_target_ids(p, 1:3)
```
