# pmotoolsr (development version)

## Changes that can affect existing code

* The table builders now stop on input they used to accept. Each of these
  errors names the table, the argument and the column.
  * A column argument that names a column the table does not have. Before,
    optional arguments such as `reaction_name_col`, `umis_col`,
    `parasite_density_col` and the plate columns were ignored (#8).
  * An empty cell in a required column: the sample name, target name, sequence
    and read count in the microhaplotype table, the target name and primers in
    the panel table, the name column of the specimen and library-sample tables,
    the names and counts in the read-count tables, and the run column when one
    is used. Before, a missing sequence or primer was written as the text
    `"NA"` (#7).
  * A read count that is not a whole number of 0 or more. Counts given as text,
    such as `"10"`, are read as numbers (#7).
  * A masking value that is not a whole number (#7).
* The metadata builders stop when two columns would become the same PMO field,
  for example `specimen_name_col = "sample"` with
  `additional_specimen_cols = "specimen_name"`. Before, the record took
  whichever column came first in the table (#12).
* An index field is shifted between 0-based (on disk) and 1-based (in memory)
  only in the object the PMO schema puts it in. Before, every field whose name
  ended in `_id`, other than the taxon ids, was shifted wherever it appeared, so
  a column of your own such as `household_id` lost 1 on each write. A file
  written by an earlier version has that field 1 too low (#5).
* `pmo_mhap_table_to_pmo()` orders targets and library samples by code point in
  every locale, which matches pmotools-python. Ids in a rebuilt PMO can differ
  from those built by an earlier version on a machine with another locale (#9).
* With duplicate names in a metadata table, each record keeps the plate and
  density values of its own row. Before, every duplicate got the first row's
  values (#12).
* `pmo_count_targets_per_library_sample()` and
  `pmo_count_library_samples_per_target()` label a detected set that has no run
  id with its run name. Before, they used `detected_microhaplotypes_count_idx_<n>`
  even when the set had a name (#14).

## New

* `pmo_read_count_by_stage_table_to_pmo()` has a `wide` argument. Set
  `wide = TRUE` for a wide table with a single stage column (#17).
* `write_pmo()` and `write_pmo_raw()` each accept an R6 object or a PMO list,
  and `write_pmo_raw()` passes `...` to `jsonlite::toJSON()` (#13).
* `pmo_extract_allele_counts_freq()` works on a PMO built without
  `bioinformatics_run_info`. It labels each detected set by its run name, and
  returns an empty table when the filters match nothing (#14).

## Bug fixes

* Numbers are no longer rounded to 4 decimal places on write; they keep up to 15
  significant digits. Before, `parasite_density`, `host_age` and any numeric
  additional column changed each time a PMO was written (#6).
* A field ending in `_id` that holds text can be written, validated and read
  with `read_pmo_raw()` (#5).
* Numeric names work in every builder and are written as text, including run
  names. A target or sample named `100000` is written as `"100000"`, not
  `"1e+05"` (#10).
* `pmo_merge_to_pmo()` accepts a library sample that appears in more than one
  bioinformatics run when `library_sample_info` is not given (#11).
* The metadata builders read the mapped column when another column in the table
  has the PMO field's name (#12).
* An empty text cell in an optional column is left out of the record, as a
  missing value already was (#7).
* A blank plate position leaves that record without a plate position instead of
  stopping the builder, and spaces around a position are ignored (#22).
* The filter functions keep every part of the input they do not change,
  including `bioinformatics_run_name` and fields outside the schema, and
  `pmo_extract_alleles_per_sample_table()` reports the run name (#14).

# pmotoolsr 1.1.0

* First release.
