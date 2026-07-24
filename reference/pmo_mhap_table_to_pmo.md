# Convert a microhaplotype calls table into PMO microhaplotype structures

Builds the `representative_microhaplotypes` and
`detected_microhaplotypes` components from a long table of
microhaplotype calls. The result is a name-based intermediate (see file
notes) suitable for
[`pmo_merge_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_to_pmo.md).

## Usage

``` r
pmo_mhap_table_to_pmo(
  microhaplotype_table,
  bioinformatics_run_name = NULL,
  library_sample_name_col = "library_sample_name",
  target_name_col = "target_name",
  seq_col = "seq",
  reads_col = "reads",
  genome_id = 1,
  umis_col = NULL,
  chrom_col = NULL,
  start_col = NULL,
  end_col = NULL,
  ref_seq_col = NULL,
  strand_col = NULL,
  alt_annotations_col = NULL,
  masking_seq_start_col = NULL,
  masking_seq_segment_size_col = NULL,
  masking_replacement_size_col = NULL,
  masking_delim = ",",
  microhaplotype_name_col = NULL,
  pseudocigar_col = NULL,
  pseudocigar_chrom_col = NULL,
  pseudocigar_start_col = NULL,
  pseudocigar_end_col = NULL,
  pseudocigar_ref_seq_col = NULL,
  pseudocigar_strand_col = NULL,
  pseudocigar_genome_id = NULL,
  pseudocigar_generation_description_col = NULL,
  quality_col = NULL,
  additional_representative_mhap_cols = NULL,
  additional_mhap_detected_cols = NULL
)
```

## Arguments

- microhaplotype_table:

  A data.frame of microhaplotype calls.

- bioinformatics_run_name:

  Either a column name in the table (one detected set is built per
  unique value) or a single run name, or `NULL`.

- library_sample_name_col, target_name_col, seq_col, reads_col:

  Column names for the required fields.

- genome_id:

  1-based genome id for mhap locations (default 1).

- umis_col, chrom_col, start_col, end_col, ref_seq_col, strand_col:

  Optional column names.

- alt_annotations_col, microhaplotype_name_col, pseudocigar_col,
  quality_col:

  Optional column names.

- masking_seq_start_col, masking_seq_segment_size_col,
  masking_replacement_size_col:

  Optional masking column names (all three required together).

- masking_delim:

  Delimiter for masking list values.

- pseudocigar_chrom_col, pseudocigar_start_col, pseudocigar_end_col,
  pseudocigar_ref_seq_col, pseudocigar_strand_col,
  pseudocigar_genome_id, pseudocigar_generation_description_col:

  Columns/value used to build the `Pseudocigar` object's `ref_loc`
  ([GenomicLocation](https://plasmogenepi.github.io/pmotoolsr/reference/GenomicLocation.md))
  when `pseudocigar_col` is set. The chromosome defaults to `chrom_col`
  and the genome id to `genome_id`; `pseudocigar_start_col` and
  `pseudocigar_end_col` are required (an error is raised if
  `pseudocigar_col` is set without a constructable ref_loc).

- additional_representative_mhap_cols, additional_mhap_detected_cols:

  Optional extra columns to carry through.

## Value

A list with `representative_microhaplotypes` and a list of
`detected_microhaplotypes`.

## Examples

``` r
calls <- data.frame(
  library_sample_name = c("S1", "S1", "S2"),
  target_name = c("t1", "t2", "t1"),
  seq = c("ACGT", "TTTT", "ACGA"),
  reads = c(120, 80, 95)
)
mhaps <- pmo_mhap_table_to_pmo(calls)
length(mhaps$representative_microhaplotypes$targets)
#> [1] 2
```
