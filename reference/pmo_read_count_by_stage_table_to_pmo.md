# Convert read-count tables into the PMO read_counts_by_stage structure

Convert read-count tables into the PMO read_counts_by_stage structure

## Usage

``` r
pmo_read_count_by_stage_table_to_pmo(
  total_raw_count_table,
  bioinformatics_run_name = NULL,
  reads_by_stage_table = NULL,
  library_sample_name_col = "library_sample_name",
  target_name_col = "target_name",
  total_raw_count_col = "total_raw_count",
  stage_col = "stage",
  read_count_col = "read_count",
  additional_library_sample_cols = NULL,
  additional_target_cols = NULL
)
```

## Arguments

- total_raw_count_table:

  A data.frame with one row per library sample giving its total raw read
  count.

- bioinformatics_run_name:

  Either a column name in `total_raw_count_table` (one set built per
  unique value) or a single run name, or `NULL`.

- reads_by_stage_table:

  Optional data.frame of per-sample, per-target, per-stage read counts;
  long format (single `stage_col`) or wide format (pass `stage_col` as a
  vector of stage column names).

- library_sample_name_col, target_name_col, total_raw_count_col,
  stage_col, read_count_col:

  Column names.

- additional_library_sample_cols, additional_target_cols:

  Optional extra columns to carry through.

## Value

A list of read-count sets (one per run; always a list).

## Examples

``` r
totals <- data.frame(library_sample_name = c("l1", "l2"),
                     total_raw_count = c(1000, 2000))
pmo_read_count_by_stage_table_to_pmo(totals)
#> [[1]]
#> [[1]]$read_counts_by_library_sample_by_stage
#> [[1]]$read_counts_by_library_sample_by_stage[[1]]
#> [[1]]$read_counts_by_library_sample_by_stage[[1]]$library_sample_name
#> [1] "l1"
#> 
#> [[1]]$read_counts_by_library_sample_by_stage[[1]]$total_raw_count
#> [1] 1000
#> 
#> 
#> [[1]]$read_counts_by_library_sample_by_stage[[2]]
#> [[1]]$read_counts_by_library_sample_by_stage[[2]]$library_sample_name
#> [1] "l2"
#> 
#> [[1]]$read_counts_by_library_sample_by_stage[[2]]$total_raw_count
#> [1] 2000
#> 
#> 
#> 
#> 
```
