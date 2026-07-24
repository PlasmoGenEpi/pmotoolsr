# Building a full PMO

This vignette assembles a **fully-populated PMO** from separate tables —
project, specimen, panel, library, sequencing, bioinformatics, and
microhaplotype information — and mirrors the pmotools-python “dataset1”
generation tutorial.

The example data is a **downsampled** copy of public *Plasmodium
falciparum* genomic-surveillance data (Elimination-8 region) bundled
with the package: a handful of specimens, their library samples, and the
drug-resistance targets of the [MAD4HatTeR
panel](https://doi.org/10.1038/s41598-025-94716-5).

``` r

library(pmotoolsr)

d <- system.file("extdata", "building_a_pmo", package = "pmotoolsr")
mhap_df <- read.delim(file.path(d, "allele_data.txt.gz"))
spec_df <- read.delim(file.path(d, "specimen_info.tsv"), check.names = FALSE)
lib_df  <- read.delim(file.path(d, "library_sample_info.tsv"))
a52_df  <- read.delim(file.path(d, "a52_pools.tsv"))
ab2_df  <- read.delim(file.path(d, "ab2_pools.tsv"))
```

A PMO is built section by section and merged at the end. Any builder’s
options are documented in its help page
(e.g. [`?pmo_merge_to_pmo`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_to_pmo.md)).

## Project information

``` r

project <- list(list(
  project_name = "RegGenE8",
  project_description = "P. falciparum surveillance demo (downsampled)",
  project_collector_chief_scientist = "Jennifer Smith",
  project_type = "cross-sectional"
))
```

## Specimen information

``` r

spec <- pmo_specimen_info_table_to_pmo(
  spec_df,
  specimen_name_col = "form participant_id",
  specimen_taxon_id_col = "specimen_taxon_id",
  host_taxon_id_col = "host_taxon_id",
  collection_date_col = "form date_diagnosis",
  collection_country_col = "country",
  project_name_col = "project_name",
  geo_admin1_col = "facility_province",
  geo_admin2_col = "facility_district",
  geo_admin3_col = "facility_name"
)
```

## Panel information

Two pool combinations were used; both reference the same genome. We
build each panel, then merge them with
[`pmo_merge_panel_info_dicts()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_panel_info_dicts.md)
(which deduplicates shared targets and genomes and remaps indices).

``` r

genome <- list(
  name = "3D7", genome_version = "65", taxon_id = 5833,
  url = "https://plasmodb.org/PlasmoDB-65_Pfalciparum3D7_Genome.fasta"
)

a52_panel <- pmo_panel_info_table_to_pmo(a52_df, "A52", genome_info = genome,
                                         target_name_col = "amplicon")
ab2_panel <- pmo_panel_info_table_to_pmo(ab2_df, "AB2", genome_info = genome,
                                         target_name_col = "amplicon")
panel <- pmo_merge_panel_info_dicts(list(a52_panel, ab2_panel))

length(panel$target_info)
#> [1] 81
```

## Library sample information

``` r

lib <- pmo_library_sample_info_table_to_pmo(
  lib_df,
  library_sample_name_col = "SampleID",
  sequencing_info_name_col = "SSPOOL",
  specimen_name_col = "specimen_id",
  panel_name_col = "Pools"
)
```

## Sequencing information

One record per sequencing run:

``` r

seq_info <- lapply(unique(lib_df$SSPOOL), function(run) list(
  sequencing_info_name = run, seq_platform = "Illumina",
  seq_instrument_model = "MiSeq", library_layout = "paired-end",
  library_strategy = "AMPLICON", library_source = "GENOMIC",
  library_selection = "PCR", seq_center = "NICD"
))
```

## Bioinformatics methods and runs

``` r

methods <- list(list(methods = list(
  list(program = "DADA2", program_version = "v3.17"),
  list(program = "cutadapt", program_version = "v4.4")
)))

# bioinformatics_methods_id is 1-based in R (points to the first methods entry)
runs <- lapply(unique(lib_df$SSPOOL), function(run) list(
  bioinformatics_run_name = run, bioinformatics_methods_id = 1L
))
```

## Microhaplotype information

``` r

mhaps <- pmo_mhap_table_to_pmo(
  mhap_df,
  bioinformatics_run_name = "SSPOOL",
  library_sample_name_col = "SampleID",
  target_name_col = "Locus",
  seq_col = "ASV",
  reads_col = "Reads"
)
```

## Merge

[`pmo_merge_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_to_pmo.md)
stitches the sections together, replacing every name with its index.
Inconsistencies (a library referencing an unknown panel, etc.) raise
descriptive errors.

``` r

pmo <- pmo_merge_to_pmo(
  project_info = project,
  specimen_info = spec,
  panel_target_info = panel,
  library_sample_info = lib,
  sequencing_info = seq_info,
  bioinfo_method_info = methods,
  bioinfo_run_info = runs,
  mhap_info = mhaps
)

c(specimens = length(pmo$specimen_info),
  libraries = length(pmo$library_sample_info),
  targets = length(pmo$target_info),
  runs = length(pmo$bioinformatics_run_info))
#> specimens libraries   targets      runs 
#>         8        27        81        17

pmo_validate(pmo)
```

``` r

out <- tempfile(fileext = ".json.gz")
write_pmo_raw(pmo, out)
```

The result is a complete, schema-valid PMO ready to share or analyze.
\`\`\`
