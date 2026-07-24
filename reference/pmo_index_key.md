# Build a name-to-index lookup for PMO entities

These helpers return a named integer vector mapping each entity name to
its 1-based position within the corresponding PMO section.

## Usage

``` r
pmo_index_key_specimen_names(pmo)

pmo_index_key_library_sample_names(pmo)

pmo_index_key_target_names(pmo)

pmo_index_key_panel_names(pmo)

pmo_index_key_bioinformatics_run_names(pmo)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

## Value

A named integer vector of 1-based indices keyed by name.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_index_key_target_names(p))
#> t96 t95 t94 t50 t36 t88 
#>   1   2   3   4   5   6 
```
