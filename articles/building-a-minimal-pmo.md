# Building a minimal PMO

This vignette builds a PMO that contains only the **minimum required
information** — microhaplotype calls plus the primer panel — then shows
how to rename specimens and add specimen metadata. It mirrors the
pmotools-python “Create a minimal PMO” and “Update meta in a minimal
PMO” tutorials.

The example data is a downsampled copy of a *Staphylococcus aureus*
targeted amplicon study (Furstenau et al. 2025, *Microbial Genomics*),
bundled with the package.

``` r

library(pmotoolsr)

dir <- system.file("extdata", "building_a_minimum_pmo", package = "pmotoolsr")
mhap_df <- read.delim(file.path(dir, "allele_data.tsv.gz"))
primers <- read.delim(file.path(dir, "Furstenau2025_primers.tsv"))

head(primers)
#>      target                 forward                 reverse
#> 1 SA_131432       GTCCAGGTAGCATGATT TGTCATACCAGTTAGGAATCACA
#> 2 SA_166442 AATTAAGTAAGCTCCAATGCGTT      TAGTTCGCTCTCCCCTTA
#> 3 SA_219791      TCCAATATCCTGGCGTGA      TTCACAACCATTACCAAG
#> 4 SA_303281    TAACGATGCGACAGGTACAG       ATGATGATGCTATGCGT
#> 5 SA_433466      AGGTCTCACGACATCATT     CATAATACCTGCGCCATCA
#> 6 SA_445461      CGGACAAGAACATGTCAC       TGAATTAGTCCCCTGCG
```

## The minimum required pieces

A PMO needs at least the **microhaplotype** data and the **panel** (the
targets’ primers). We convert each into PMO sections, then merge them.

``` r

panel <- pmo_panel_info_table_to_pmo(
  primers,
  panel_name = "staph_aureus_Furstenau2025",
  target_name_col = "target",
  forward_primers_seq_col = "forward",
  reverse_primers_seq_col = "reverse"
)

mhaps <- pmo_mhap_table_to_pmo(
  mhap_df,
  library_sample_name_col = "s_Sample",
  target_name_col = "p_name",
  seq_col = "h_Consensus",
  reads_col = "c_ReadCnt"
)

pmo <- pmo_merge_to_pmo(panel_target_info = panel, mhap_info = mhaps)
pmo_validate(pmo)
```

When only the panel and microhaplotype data are supplied, the specimen
and library-sample info are generated automatically and **each specimen
name equals its library-sample name**:

``` r

before <- pmo_list_library_samples_per_specimen(pmo)
all(before$specimen_name == before$library_sample_name)
#> [1] TRUE
```

Write it out (compression is inferred from the file extension):

``` r

out <- tempfile(fileext = ".json.gz")
write_pmo_raw(pmo, out)
```

## Setting specimen names from a key

Often several library samples come from the same specimen. We can supply
a `library_sample_name -> specimen_name` key. Here we use SRA metadata
(`run_accession -> sample_alias`):

``` r

sra <- read.delim(file.path(dir, "sra_info_table.tsv"))
lib_to_spec <- stats::setNames(sra$sample_alias, sra$run_accession)

renamed <- pmo_minimum_library_specimen_from_mhap_table(
  mhaps$detected_microhaplotypes,
  panel_name = "staph_aureus_Furstenau2025",
  library_sample_specimen_key = lib_to_spec
)

pmo2 <- pmo_merge_to_pmo(
  specimen_info = renamed$specimen_info,
  library_sample_info = renamed$library_sample_info,
  panel_target_info = panel,
  mhap_info = mhaps
)

after <- pmo_list_library_samples_per_specimen(pmo2)
c(libraries = nrow(after), specimens = length(unique(after$specimen_name)))
#> libraries specimens 
#>       129       114
```

## Adding specimen metadata

A minimal specimen record holds only `specimen_name`:

``` r

pmo2$specimen_info[[1]]
#> $specimen_name
#> [1] "85b498-Wk16-Nasal"
```

Build a specimen metadata section from a table and merge it in by
`specimen_name`. We split the SRA `country` column (“Country: State”)
into a country and a first-level admin region:

``` r

meta <- unique(sra[, c("sample_alias", "country", "collection_date")])
parts <- strsplit(meta$country, ":", fixed = TRUE)
meta$country_only <- trimws(vapply(parts, `[`, character(1), 1))
meta$state <- trimws(vapply(
  parts, function(x) if (length(x) > 1) x[2] else NA_character_, character(1)))

spec_meta <- pmo_specimen_info_table_to_pmo(
  meta,
  specimen_name_col = "sample_alias",
  collection_date_col = "collection_date",
  collection_country_col = "country_only",
  geo_admin1_col = "state"
)

pmo2$specimen_info <- pmo_merge_dicts_by_key(
  pmo2$specimen_info, spec_meta, key_field = "specimen_name")

pmo2$specimen_info[[1]]
#> $specimen_name
#> [1] "85b498-Wk16-Nasal"
#> 
#> $collection_date
#> [1] "2022-02-07"
#> 
#> $collection_country
#> [1] "USA"
#> 
#> $geo_admin1
#> [1] "Phoenix"
```

``` r

pmo_validate(pmo2)
```

The PMO now carries specimen-level metadata and still conforms to the
schema. See
[`vignette("building-a-full-pmo")`](https://plasmogenepi.github.io/pmotoolsr/articles/building-a-full-pmo.md)
for assembling a fully-populated PMO. \`\`\`
