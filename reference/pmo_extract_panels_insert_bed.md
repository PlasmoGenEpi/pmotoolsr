# Extract panel insert locations as BED rows

Returns a single tibble covering all requested panels, with `panel_name`
and `reaction_name` columns identifying each insert's source.

## Usage

``` r
pmo_extract_panels_insert_bed(pmo, select_panel_ids = NULL, sort_output = TRUE)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- select_panel_ids:

  Optional 1-based panel ids (default all).

- sort_output:

  Sort by panel, chrom, start, end.

## Value

A tibble of BED rows plus `panel_name` and `reaction_name`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_extract_panels_insert_bed(p))
#> # A tibble: 6 × 10
#>   chrom        start    end name  score strand ref_seq     extra_info panel_name
#>   <chr>        <int>  <int> <chr> <int> <chr>  <chr>       <chr>      <chr>     
#> 1 Pf3D7_01_v3 145449 145622 t1      173 +      AAACTTTTTT… [genome_n… heomev1   
#> 2 Pf3D7_01_v3 179903 180115 t2      212 +      CTTTCGATAC… [genome_n… heomev1   
#> 3 Pf3D7_01_v3 181557 181673 t3      116 +      TTCATTCTTT… [genome_n… heomev1   
#> 4 Pf3D7_01_v3 495971 496143 t4      172 +      TGAAAGTAGC… [genome_n… heomev1   
#> 5 Pf3D7_01_v3 512199 512388 t5      189 +      TTAAATAAAT… [genome_n… heomev1   
#> 6 Pf3D7_01_v3 531682 531900 t6      218 +      AAAAGAAAGA… [genome_n… heomev1   
#> # ℹ 1 more variable: reaction_name <chr>
```
