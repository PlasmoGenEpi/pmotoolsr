# Extract allele (microhaplotype) counts and frequencies

Tallies, per bioinformatics run and target, how many samples carry each
representative microhaplotype, and the within-target frequency. This is
the table consumed by downstream tools such as dcifer and moire.

## Usage

``` r
pmo_extract_allele_counts_freq(
  pmo,
  bioinformatics_run_ids = NULL,
  library_sample_names = NULL,
  target_names = NULL,
  collapse_across_runs = FALSE
)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- bioinformatics_run_ids:

  Optional integer vector of 1-based run ids to include.

- library_sample_names:

  Optional character vector of library sample names to include.

- target_names:

  Optional character vector of target names to include.

- collapse_across_runs:

  If `TRUE`, collapse counts/frequencies across runs.

## Value

A tibble. If `collapse_across_runs = FALSE`: columns
`bioinformatics_run_id`, `target_name`, `mhap_id`, `count`, `freq`,
`total_haps_per_target`. If `TRUE`: `target_name`, `mhap_id`, `count`,
`freq`, `target_total`. Note: `mhap_id` and `bioinformatics_run_id` are
1-based.

## Details

Requires each detected-microhaplotypes set to have a
`bioinformatics_run_id`; an informative error is raised if that optional
field is absent.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_extract_allele_counts_freq(p))
#> # A tibble: 6 × 6
#>   bioinformatics_run_id target_name mhap_id count  freq total_haps_per_target
#>                   <int> <chr>         <int> <int> <dbl>                 <int>
#> 1                     1 t1                1     2   0.5                     4
#> 2                     1 t1                2     2   0.5                     4
#> 3                     1 t10               1     2   1                       2
#> 4                     1 t100              1     1   0.5                     2
#> 5                     1 t100              2     1   0.5                     2
#> 6                     1 t11               1     1   0.5                     2
```
