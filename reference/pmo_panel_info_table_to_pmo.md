# Convert a panel/target table into PMO target_info + panel_info

Convert a panel/target table into PMO target_info + panel_info

## Usage

``` r
pmo_panel_info_table_to_pmo(
  target_table,
  panel_name,
  genome_info = NULL,
  target_name_col = "target_name",
  forward_primers_seq_col = "fwd_primer",
  reverse_primers_seq_col = "rev_primer",
  reaction_name_col = NULL,
  reaction_name_col_delimiter = ",",
  forward_primers_start_col = NULL,
  forward_primers_end_col = NULL,
  reverse_primers_start_col = NULL,
  reverse_primers_end_col = NULL,
  insert_start_col = NULL,
  insert_end_col = NULL,
  chrom_col = NULL,
  strand_col = NULL,
  ref_seq_col = NULL,
  gene_name_col = NULL,
  genome_id_col = NULL,
  target_attributes_col = NULL,
  target_attributes_col_delimiter = ",",
  additional_target_info_cols = NULL
)
```

## Arguments

- target_table:

  A data.frame with one row per target.

- panel_name:

  Name assigned to the panel.

- genome_info:

  Optional genome metadata (a single genome list or a list of them);
  required if any location columns are used.

- target_name_col, forward_primers_seq_col, reverse_primers_seq_col:

  Column names for the required fields.

- reaction_name_col, reaction_name_col_delimiter:

  Optional reaction column (targets split into reactions); without it
  all targets form one `full` reaction.

- forward_primers_start_col, forward_primers_end_col,
  reverse_primers_start_col, reverse_primers_end_col, insert_start_col,
  insert_end_col, chrom_col, strand_col, ref_seq_col:

  Optional genomic-location columns (0-based coordinates).

- gene_name_col, genome_id_col, target_attributes_col,
  target_attributes_col_delimiter, additional_target_info_cols:

  Optional extra columns. `genome_id_col` values are 1-based; without it
  genome id defaults to 1.

## Value

A list with `panel_info`, `target_info`, and (if `genome_info` given)
`targeted_genomes`.

## Examples

``` r
primers <- data.frame(target_name = c("t1", "t2"),
                      fwd_primer = c("AAAA", "CCCC"),
                      rev_primer = c("TTTT", "GGGG"))
panel <- pmo_panel_info_table_to_pmo(primers, "demo_panel")
length(panel$target_info)
#> [1] 2
```
