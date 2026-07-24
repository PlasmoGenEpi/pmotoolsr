# Export target info metadata

Primer sequences and primer/insert genomic locations are flattened into
`forward_primer_*`, `reverse_primer_*`, and `insert_*` columns.

## Usage

``` r
pmo_export_target_info_meta_table(pmo, separator = ",")
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
head(pmo_export_target_info_meta_table(p))
#> # A tibble: 6 × 21
#>   target_name forward_primer_seq         reverse_primer_seq forward_primer_chrom
#>   <chr>       <chr>                      <chr>              <chr>               
#> 1 t96         TTTTTCTCCACTTTGTAATTTTTAT… CGGGTGGTATCATGAGA… Pf3D7_14_v3         
#> 2 t95         ACACTTCAACTACACTTTTTAATTT… AGATCTTATGTTAAACT… Pf3D7_14_v3         
#> 3 t94         AAAATCTTTTGGTATTGTATTTTGA… AAACGGAATCACTTATG… Pf3D7_14_v3         
#> 4 t50         TGTAAAAGGAAAATGTCTTACGTGG… ATTCAAAACCAATAGTA… Pf3D7_08_v3         
#> 5 t36         GGAATATTTGTGATTTAGGATGTAA… CAAATATATCTCTTCGC… Pf3D7_05_v3         
#> 6 t88         ATTTACATGATGTAACTGAATCTCA… AGCCAGTATTCTTTTTA… Pf3D7_13_v3         
#> # ℹ 17 more variables: forward_primer_end <int>,
#> #   forward_primer_genome_id <dbl>, forward_primer_start <int>,
#> #   forward_primer_strand <chr>, gene_name <chr>, insert_chrom <chr>,
#> #   insert_end <int>, insert_genome_id <dbl>, insert_ref_seq <chr>,
#> #   insert_start <int>, insert_strand <chr>, reverse_primer_chrom <chr>,
#> #   reverse_primer_end <int>, reverse_primer_genome_id <dbl>,
#> #   reverse_primer_start <int>, reverse_primer_strand <chr>, …
```
