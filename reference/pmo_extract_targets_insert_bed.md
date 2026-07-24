# Extract target insert locations as BED rows

Extract target insert locations as BED rows

## Usage

``` r
pmo_extract_targets_insert_bed(
  pmo,
  select_target_ids = NULL,
  sort_output = TRUE
)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- select_target_ids:

  Optional 1-based target ids (default all).

- sort_output:

  Sort by chrom, start, end.

## Value

A tibble with columns `chrom`, `start`, `end`, `name`, `score`,
`strand`, `ref_seq`, `extra_info`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_extract_targets_insert_bed(p))
#> # A tibble: 6 × 8
#>   chrom        start    end name  score strand ref_seq                extra_info
#>   <chr>        <int>  <int> <chr> <int> <chr>  <chr>                  <chr>     
#> 1 Pf3D7_01_v3 145449 145622 t1      173 +      AAACTTTTTTTATTTTTTTTG… [genome_n…
#> 2 Pf3D7_01_v3 179903 180115 t2      212 +      CTTTCGATACAGGACATATAG… [genome_n…
#> 3 Pf3D7_01_v3 181557 181673 t3      116 +      TTCATTCTTTTTTTAACGAAA… [genome_n…
#> 4 Pf3D7_01_v3 495971 496143 t4      172 +      TGAAAGTAGCGAATACCCTGT… [genome_n…
#> 5 Pf3D7_01_v3 512199 512388 t5      189 +      TTAAATAAATTAAGTGAAGAT… [genome_n…
#> 6 Pf3D7_01_v3 531682 531900 t6      218 +      AAAAGAAAGATGTTAAGAAAA… [genome_n…
```
