# Count the number of targets detected per library sample

Count the number of targets detected per library sample

## Usage

``` r
pmo_count_targets_per_library_sample(pmo, min_reads = 0)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- min_reads:

  Minimum summed reads for a target (across its detected
  microhaplotypes) for that target to be counted.

## Value

A tibble with columns `bioinformatics_run_id`, `library_sample_name`,
`target_number`. Note: `bioinformatics_run_id` is 1-based; when a
detected set has no run id, a `detected_microhaplotypes_count_idx_<n>`
label is used.

## Examples

``` r
pmo <- read_pmo(
  system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
head(pmo_count_targets_per_library_sample(pmo))
#> # A tibble: 6 × 3
#>   bioinformatics_run_id                library_sample_name target_number
#>   <chr>                                <chr>                       <int>
#> 1 detected_microhaplotypes_count_idx_0 SRR30825770                    27
#> 2 detected_microhaplotypes_count_idx_0 SRR30825771                    27
#> 3 detected_microhaplotypes_count_idx_0 SRR30825772                    27
#> 4 detected_microhaplotypes_count_idx_0 SRR30825773                    27
#> 5 detected_microhaplotypes_count_idx_0 SRR30825774                    27
#> 6 detected_microhaplotypes_count_idx_0 SRR30825775                    11
```
