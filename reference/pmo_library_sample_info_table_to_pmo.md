# Convert a library-sample metadata table into PMO library_sample_info

Convert a library-sample metadata table into PMO library_sample_info

## Usage

``` r
pmo_library_sample_info_table_to_pmo(
  contents,
  library_sample_name_col = "library_sample_name",
  specimen_name_col = "specimen_name",
  panel_name_col = "panel_name",
  sequencing_info_name_col = NULL,
  alternate_identifiers_col = NULL,
  experiment_accession_col = NULL,
  fastqs_loc_col = NULL,
  library_prep_plate_name_col = NULL,
  library_prep_plate_col_col = NULL,
  library_prep_plate_row_col = NULL,
  library_prep_plate_position_col = NULL,
  parasite_density_col = NULL,
  parasite_density_method_col = NULL,
  run_accession_col = NULL,
  additional_library_sample_info_cols = NULL,
  list_values_library_values = c("alternate_identifiers"),
  list_values_library_values_delimiter = ","
)
```

## Arguments

- contents:

  A data.frame, one row per library sample.

- library_sample_name_col, specimen_name_col, panel_name_col:

  Column names for the key fields.

- sequencing_info_name_col, alternate_identifiers_col,
  experiment_accession_col, fastqs_loc_col, run_accession_col:

  Optional column names.

- library_prep_plate_name_col, library_prep_plate_col_col,
  library_prep_plate_row_col, library_prep_plate_position_col:

  Optional plate-location columns.

- parasite_density_col, parasite_density_method_col:

  Optional qPCR density column(s).

- additional_library_sample_info_cols:

  Extra columns to copy through.

- list_values_library_values, list_values_library_values_delimiter:

  Fields that may hold delimited lists, and the delimiter.

## Value

A list of library-sample records (name-based).

## Examples

``` r
df <- data.frame(library_sample_name = c("l1", "l2"),
                 specimen_name = c("sp1", "sp2"),
                 panel_name = c("demo_panel", "demo_panel"))
pmo_library_sample_info_table_to_pmo(df)
#> [[1]]
#> [[1]]$library_sample_name
#> [1] "l1"
#> 
#> [[1]]$specimen_name
#> [1] "sp1"
#> 
#> [[1]]$panel_name
#> [1] "demo_panel"
#> 
#> 
#> [[2]]
#> [[2]]$library_sample_name
#> [1] "l2"
#> 
#> [[2]]$specimen_name
#> [1] "sp2"
#> 
#> [[2]]$panel_name
#> [1] "demo_panel"
#> 
#> 
```
