# Build minimal library/specimen info from a detected-microhaplotypes structure

Build minimal library/specimen info from a detected-microhaplotypes
structure

## Usage

``` r
pmo_minimum_library_specimen_from_mhap_table(
  detected_microhaps,
  panel_name,
  library_sample_specimen_key = NULL,
  library_sample_name_col = "library_sample_name",
  specimen_name_col = "specimen_name",
  missing_library_sample_becomes_specimen_name = FALSE
)
```

## Arguments

- detected_microhaps:

  The list of detected-microhaplotype sets (the
  `detected_microhaplotypes` element from
  [`pmo_mhap_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_mhap_table_to_pmo.md)).

- panel_name:

  Panel name to assign to each library sample.

- library_sample_specimen_key:

  Optional named character vector or data.frame mapping library sample
  name to specimen name; if `NULL`, specimen name equals library sample
  name.

- library_sample_name_col, specimen_name_col:

  Column names used when `library_sample_specimen_key` is a data.frame.

- missing_library_sample_becomes_specimen_name:

  If `TRUE`, library samples absent from the key fall back to using
  their own name as the specimen name.

## Value

A list with `library_sample_info` and `specimen_info`.

## Examples

``` r
calls <- data.frame(library_sample_name = c("S1", "S2"),
                    target_name = c("t1", "t1"), seq = c("ACGT", "ACGA"),
                    reads = c(120, 95))
mhaps <- pmo_mhap_table_to_pmo(calls)
ls <- pmo_minimum_library_specimen_from_mhap_table(
  mhaps$detected_microhaplotypes, panel_name = "demo_panel")
length(ls$specimen_info)
#> [1] 2
```
