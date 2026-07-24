# Merge name-based PMO components into a complete PMO

Assembles the outputs of the other builders into a full PMO, replacing
every name reference with its 1-based index. If
`specimen_info`/`library_sample_info` are omitted they are derived from
the detected microhaplotypes.

## Usage

``` r
pmo_merge_to_pmo(
  mhap_info,
  panel_target_info,
  specimen_info = NULL,
  library_sample_info = NULL,
  sequencing_info = NULL,
  bioinfo_method_info = NULL,
  bioinfo_run_info = NULL,
  project_info = NULL,
  read_counts_by_stage_info = NULL
)
```

## Arguments

- mhap_info:

  List with `representative_microhaplotypes` and
  `detected_microhaplotypes` (from
  [`pmo_mhap_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_mhap_table_to_pmo.md)).

- panel_target_info:

  List with `panel_info` and `target_info` (and optionally
  `targeted_genomes`) from
  [`pmo_panel_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_panel_info_table_to_pmo.md).

- specimen_info, library_sample_info:

  Optional name-based metadata lists (from
  [`pmo_specimen_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_specimen_info_table_to_pmo.md)
  /
  [`pmo_library_sample_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_library_sample_info_table_to_pmo.md)).

- sequencing_info, bioinfo_method_info, bioinfo_run_info, project_info:

  Optional component lists.

- read_counts_by_stage_info:

  Optional list from
  [`pmo_read_count_by_stage_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_read_count_by_stage_table_to_pmo.md).

## Value

A complete PMO as a raw nested list (1-based ids). Write with
[`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md),
convert with
[`pmo_list_to_r6()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_list_to_r6.md),
or validate with
[`pmo_validate()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate.md).

## Examples

``` r
calls <- data.frame(
  library_sample_name = c("S1", "S2"), target_name = c("t1", "t1"),
  seq = c("ACGT", "ACGA"), reads = c(120, 95))
mhaps <- pmo_mhap_table_to_pmo(calls)
primers <- data.frame(target_name = "t1", fwd_primer = "AAAA",
                      rev_primer = "TTTT")
panel <- pmo_panel_info_table_to_pmo(primers, "demo_panel")
pmo <- pmo_merge_to_pmo(mhap_info = mhaps, panel_target_info = panel)
pmo_validate(pmo)
```
