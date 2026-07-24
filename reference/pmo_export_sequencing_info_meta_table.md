# Export sequencing info metadata

Export sequencing info metadata

## Usage

``` r
pmo_export_sequencing_info_meta_table(pmo, separator = ",")
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
head(pmo_export_sequencing_info_meta_table(p))
#> # A tibble: 1 × 16
#>   library_kit     library_layout library_screen library_selection library_source
#>   <chr>           <chr>          <chr>          <chr>             <chr>         
#> 1 TruSeq i5/i7 b… paired-end     40 uL reactio… RANDOM            GENOMIC       
#> # ℹ 11 more variables: library_strategy <chr>, nucl_acid_amp <chr>,
#> #   nucl_acid_amp_date <chr>, nucl_acid_ext <chr>, nucl_acid_ext_date <chr>,
#> #   pcr_cond <chr>, seq_center <chr>, seq_date <chr>,
#> #   seq_instrument_model <chr>, seq_platform <chr>, sequencing_info_name <chr>
```
