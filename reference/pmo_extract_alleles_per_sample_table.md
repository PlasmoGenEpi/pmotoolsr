# Extract a per-sample allele table

Builds a long table of library sample, target, and representative
microhaplotype sequence, with optional additional metadata columns. This
is the table consumed by downstream tools (dcifer, moire, ...).

## Usage

``` r
pmo_extract_alleles_per_sample_table(
  pmo,
  additional_specimen_info_fields = NULL,
  additional_library_sample_info_fields = NULL,
  additional_microhap_fields = NULL,
  additional_representative_info_fields = NULL,
  default_base_col_names = c("library_sample_name", "target_name", "seq"),
  validate = FALSE
)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- additional_specimen_info_fields,
  additional_library_sample_info_fields, additional_microhap_fields,
  additional_representative_info_fields:

  Optional character vectors of extra fields to include from the
  respective objects; an error is raised if a requested field exists
  nowhere.

- default_base_col_names:

  Length-3 character vector naming the sample, target, and sequence
  columns.

- validate:

  If `TRUE`, validate the PMO against the schema first.

## Value

A tibble.

## Examples

``` r
pmo <- read_pmo(
  system.file("extdata", "example_pmo.json.gz", package = "pmotoolsr"))
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
