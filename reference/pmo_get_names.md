# Get entity names from a PMO

Return the names of PMO entities in the order they appear. Each function
has a `pmo_get_sorted_*` companion returning the names sorted
alphabetically.

## Usage

``` r
pmo_get_specimen_names(pmo)

pmo_get_sorted_specimen_names(pmo)

pmo_get_library_sample_names(pmo)

pmo_get_sorted_library_sample_names(pmo)

pmo_get_target_names(pmo)

pmo_get_sorted_target_names(pmo)

pmo_get_panel_names(pmo)

pmo_get_sorted_panel_names(pmo)

pmo_get_bioinformatics_run_names(pmo)

pmo_get_sorted_bioinformatics_run_names(pmo)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

## Value

A character vector of names.

## Examples

``` r
pmo <- read_pmo(
  system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
head(pmo_get_specimen_names(pmo))
#> [1] "SRR30825770" "SRR30825771" "SRR30825772" "SRR30825773" "SRR30825774"
#> [6] "SRR30825775"
pmo_get_sorted_target_names(pmo)[1:3]
#> [1] "SA_1021483" "SA_11537"   "SA_11580"  
```
