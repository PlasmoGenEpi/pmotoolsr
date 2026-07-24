# List library sample names per specimen

List library sample names per specimen

## Usage

``` r
pmo_list_library_samples_per_specimen(
  pmo,
  select_specimen_ids = NULL,
  select_specimen_names = NULL
)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- select_specimen_ids:

  Optional 1-based specimen ids.

- select_specimen_names:

  Optional specimen names (mutually exclusive with
  `select_specimen_ids`).

## Value

A tibble with columns `specimen_name`, `library_sample_name`,
`library_sample_count`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_list_library_samples_per_specimen(p))
#> # A tibble: 2 × 3
#>   specimen_name library_sample_name library_sample_count
#>   <chr>         <chr>                              <int>
#> 1 8025874217    8025874217_lib_name                    1
#> 2 8025874266    8025874266_lib_name                    1
```
