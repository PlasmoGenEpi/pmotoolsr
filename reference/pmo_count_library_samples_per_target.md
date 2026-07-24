# Count the number of library samples a target is detected in

Count the number of library samples a target is detected in

## Usage

``` r
pmo_count_library_samples_per_target(
  pmo,
  min_reads = 0,
  collapse_across_runs = FALSE
)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- min_reads:

  Minimum summed reads for a target to be counted in a sample.

- collapse_across_runs:

  If `TRUE`, sum counts across bioinformatics runs.

## Value

A tibble. If `collapse_across_runs = FALSE`: columns
`bioinformatics_run_id`, `target_name`, `sample_count`. If `TRUE`:
`target_name`, `sample_count`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_count_library_samples_per_target(p, collapse_across_runs = TRUE))
#> # A tibble: 6 × 2
#>   target_name sample_count
#>   <chr>              <int>
#> 1 t1                     2
#> 2 t10                    2
#> 3 t100                   2
#> 4 t11                    2
#> 5 t12                    2
#> 6 t13                    2
```
