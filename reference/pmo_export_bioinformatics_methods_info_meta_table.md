# Export bioinformatics methods info metadata

One row per method step, with 1-based `bioinformatics_methods_id` and
`method_id` columns.

## Usage

``` r
pmo_export_bioinformatics_methods_info_meta_table(pmo, separator = ",")
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- separator:

  Separator for list-valued fields.

## Value

A tibble.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_export_bioinformatics_methods_info_meta_table(p)
#> # A tibble: 3 × 6
#>   bioinformatics_methods…¹ method_id program program_description program_version
#>                      <int>     <int> <chr>   <chr>               <chr>          
#> 1                        1         1 SeekDe… Takes raw paired-e… v2.6.5         
#> 2                        1         2 SeekDe… Takes sequences pe… v2.6.5         
#> 3                        1         3 SeekDe… Compare across sam… v2.6.5         
#> # ℹ abbreviated name: ¹​bioinformatics_methods_id
#> # ℹ 1 more variable: additional_argument <chr>
```
