# Resolve entity names to their 1-based PMO indices

Convert a vector of names into the corresponding 1-based indices,
returned in the same order as the input. Unknown names raise an error.

## Usage

``` r
pmo_index_of_specimen_names(pmo, specimen_names)

pmo_index_of_library_sample_names(pmo, library_sample_names)

pmo_index_of_target_names(pmo, target_names)

pmo_index_of_panel_names(pmo, panel_names)

pmo_index_of_bioinformatics_run_names(pmo, bioinformatics_run_names)

pmo_index_of_target_in_representative_microhaplotypes(pmo, target_names)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- specimen_names, library_sample_names, target_names, panel_names,
  bioinformatics_run_names:

  A character vector of names to resolve.

## Value

An integer vector of 1-based indices.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_index_of_specimen_names(p, pmo_get_specimen_names(p)[1:2])
#> [1] 1 2
```
