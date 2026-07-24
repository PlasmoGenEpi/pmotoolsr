# Merge multiple panel_info dictionaries

Concatenates target lists (deduplicated by `target_name`), collapses
duplicate genomes, and remaps all genome ids and panel target indices so
they remain valid across the merged structure.

## Usage

``` r
pmo_merge_panel_info_dicts(panel_info_dicts)
```

## Arguments

- panel_info_dicts:

  A list of outputs from
  [`pmo_panel_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_panel_info_table_to_pmo.md).

## Value

A merged list with `panel_info`, `target_info`, and (if any genomes)
`targeted_genomes`.

## Examples

``` r
mk <- function(t) pmo_panel_info_table_to_pmo(
  data.frame(target_name = t, fwd_primer = "AAAA", rev_primer = "TTTT"),
  paste0("panel_", t))
merged <- pmo_merge_panel_info_dicts(list(mk("t1"), mk("t2")))
length(merged$target_info)
#> [1] 2
```
