# Convert a specimen metadata table into PMO specimen_info

Convert a specimen metadata table into PMO specimen_info

## Usage

``` r
pmo_specimen_info_table_to_pmo(
  contents,
  specimen_name_col = "specimen_name",
  specimen_taxon_id_col = NULL,
  host_taxon_id_col = NULL,
  collection_date_col = NULL,
  collection_country_col = NULL,
  project_name_col = NULL,
  alternate_identifiers_col = NULL,
  blood_meal_col = NULL,
  drug_usage_col = NULL,
  env_broad_scale_col = NULL,
  env_local_scale_col = NULL,
  env_medium_col = NULL,
  geo_admin1_col = NULL,
  geo_admin2_col = NULL,
  geo_admin3_col = NULL,
  gravid_col = NULL,
  gravidity_col = NULL,
  has_travel_out_six_month_col = NULL,
  host_age_col = NULL,
  host_sex_col = NULL,
  host_subject_id = NULL,
  lat_lon_col = NULL,
  parasite_density_col = NULL,
  parasite_density_method_col = NULL,
  specimen_accession_col = NULL,
  storage_plate_col_col = NULL,
  storage_plate_name_col = NULL,
  storage_plate_row_col = NULL,
  storage_plate_position_col = NULL,
  specimen_collect_device_col = NULL,
  specimen_comments_col = NULL,
  specimen_store_loc_col = NULL,
  specimen_type_col = NULL,
  treatment_status_col = NULL,
  additional_specimen_cols = NULL,
  list_values_specimen_values = c("alternate_identifiers", "drug_usage",
    "specimen_comments", "treatment_status", "specimen_taxon_id"),
  list_values_specimen_values_delimiter = ","
)
```

## Arguments

- contents:

  A data.frame, one row per specimen.

- specimen_name_col:

  Column name for specimen names.

- specimen_taxon_id_col, host_taxon_id_col, collection_date_col,
  collection_country_col, project_name_col, alternate_identifiers_col,
  blood_meal_col, drug_usage_col, env_broad_scale_col,
  env_local_scale_col, env_medium_col, geo_admin1_col, geo_admin2_col,
  geo_admin3_col, gravid_col, gravidity_col,
  has_travel_out_six_month_col, host_age_col, host_sex_col,
  host_subject_id, lat_lon_col, specimen_accession_col,
  specimen_collect_device_col, specimen_comments_col,
  specimen_store_loc_col, specimen_type_col, treatment_status_col:

  Optional column names mapped to the corresponding PMO fields.

- parasite_density_col, parasite_density_method_col:

  Optional density column(s).

- storage_plate_name_col, storage_plate_col_col, storage_plate_row_col,
  storage_plate_position_col:

  Optional plate-location columns.

- additional_specimen_cols:

  Extra columns to copy through.

- list_values_specimen_values, list_values_specimen_values_delimiter:

  Fields that may hold delimited lists, and the delimiter.

## Value

A list of specimen records (name-based).

## Examples

``` r
df <- data.frame(specimen_name = c("sp1", "sp2"),
                 collection_country = c("Mozambique", "Mozambique"))
pmo_specimen_info_table_to_pmo(df, collection_country_col = "collection_country")
#> [[1]]
#> [[1]]$specimen_name
#> [1] "sp1"
#> 
#> [[1]]$collection_country
#> [1] "Mozambique"
#> 
#> 
#> [[2]]
#> [[2]]$specimen_name
#> [1] "sp2"
#> 
#> [[2]]$collection_country
#> [1] "Mozambique"
#> 
#> 
```
