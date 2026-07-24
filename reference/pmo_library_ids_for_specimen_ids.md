# Get library sample ids for a set of specimen ids

For each supplied specimen id, list the 1-based library sample ids whose
`specimen_id` matches.

## Usage

``` r
pmo_library_ids_for_specimen_ids(pmo, specimen_ids)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- specimen_ids:

  An integer vector of 1-based specimen ids.

## Value

A named list keyed by specimen id (as character), each element an
integer vector of 1-based library sample ids.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_library_ids_for_specimen_ids(p, seq_along(p$specimen_info))
#> $`1`
#> [1] 1
#> 
#> $`2`
#> [1] 2
#> 
```
