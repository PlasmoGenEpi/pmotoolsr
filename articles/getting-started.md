# Getting started with pmotoolsr

`pmotoolsr` reads, writes, validates, processes, builds, and combines
**Portable Microhaplotype Objects (PMOs)** — the JSON format for
targeted amplicon (microhaplotype) sequencing data and its metadata.
This vignette is a quick tour using a small example PMO bundled with the
package.

``` r

library(pmotoolsr)

pmo_path <- system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr")
pmo <- read_pmo(pmo_path)
```

## A note on indices: 0-based on disk, 1-based in R

A PMO links its sections with integer indices (a library sample points
to its specimen via `specimen_id`, a detected microhaplotype points into
`representative_microhaplotypes` via `mhaps_target_id`, and so on). **On
disk these indices are 0-based.** When read into R they are shifted to
be **1-based**, so they behave like ordinary R indices and can be used
directly:

``` r

lib <- pmo$library_sample_info[[1]]
pmo$specimen_info[[lib$specimen_id]]$specimen_name
#> [1] "SRR30825770"
```

On write, the shift is reversed automatically, so files stay
interoperable with
[pmotools-python](https://github.com/PlasmoGenEpi/pmotools-python) and
other tooling. (`taxon_id` fields are not indices and are never
shifted.)

Every `pmo_*` function accepts either a
[`read_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo.md)
R6 object or a plain list from
[`read_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo_raw.md).

## Exploring a PMO

``` r

length(pmo_get_specimen_names(pmo))
#> [1] 129
length(pmo_get_target_names(pmo))
#> [1] 27
pmo_get_panel_names(pmo)
#> [1] "staph_aureus_Furstenau2025"

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

[`pmo_has_section()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_has_section.md)
checks for optional sections before you use them:

``` r

pmo_has_section(pmo, "sequencing_info")
#> [1] FALSE
```

## Validating

[`pmo_validate()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate.md)
runs structural checks plus full JSON Schema validation:

``` r

pmo_validate(pmo)
```

## Subsetting

Filters return a new PMO (as a plain list) with every index remapped:

``` r

some_targets <- pmo_get_target_names(pmo)[1:3]
sub <- pmo_filter_by_target_names(pmo, some_targets)
length(sub$target_info)
#> [1] 3

out <- tempfile(fileext = ".json.gz")
write_pmo_raw(sub, out)   # compression inferred from the extension
```

## Exporting tables

``` r

head(pmo_export_specimen_meta_table(pmo))
#> # A tibble: 6 × 1
#>   specimen_name
#>   <chr>        
#> 1 SRR30825770  
#> 2 SRR30825771  
#> 3 SRR30825772  
#> 4 SRR30825773  
#> 5 SRR30825774  
#> 6 SRR30825775
head(pmo_extract_alleles_per_sample_table(pmo))
#> # A tibble: 6 × 4
#>   library_sample_name target_name seq                     bioinformatics_run_n…¹
#>   <chr>               <chr>       <chr>                   <chr>                 
#> 1 SRR30825770         SA_1021483  CAATATAATAACCTAATAAAAT… detected_microhaploty…
#> 2 SRR30825770         SA_11537    AAAGGTAAAGAAGTTTCTGTAA… detected_microhaploty…
#> 3 SRR30825770         SA_11580    TGCGCCGACCATTTATGGTGGT… detected_microhaploty…
#> 4 SRR30825770         SA_1281766  TAGCATTTGTAAATGAAAGTAA… detected_microhaploty…
#> 5 SRR30825770         SA_131432   GATAAGCTGATGCGTTACATTA… detected_microhaploty…
#> 6 SRR30825770         SA_166442   GTTTCATAAAAAAACCACCTTT… detected_microhaploty…
#> # ℹ abbreviated name: ¹​bioinformatics_run_name
```

The allele table is the input many downstream tools (e.g. dcifer, moire)
expect. There are many more exporters (`pmo_export_*`), a BED extractor
([`pmo_extract_targets_insert_bed()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_targets_insert_bed.md)),
and a multi-sheet Excel writer
([`pmo_export_to_excel()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_to_excel.md)).

## Where to next

- [`vignette("building-a-minimal-pmo")`](https://plasmogenepi.github.io/pmotoolsr/articles/building-a-minimal-pmo.md)
  — build a PMO from a microhaplotype table and a primer panel, then add
  metadata.
- [`vignette("building-a-full-pmo")`](https://plasmogenepi.github.io/pmotoolsr/articles/building-a-full-pmo.md)
  — assemble a fully-populated PMO from separate project, specimen,
  panel, library, sequencing, and bioinformatics tables. \`\`\`
