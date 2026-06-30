# pmotoolsr

<!-- badges: start -->
[![R-CMD-check](https://github.com/PlasmoGenEpi/pmotoolsr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PlasmoGenEpi/pmotoolsr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> 📖 **To see full documentation of PMO and its associated tools, please see
> <https://plasmogenepi.github.io/PMO_Docs/>** — the de facto site for all things
> PMO.

Toolkit for working with Portable Microhaplotype Objects (PMOs) using R.
*Version 1.1.0.*

`pmotoolsr` reads, writes, validates, processes, builds, and combines PMO files
— the JSON format for storing targeted amplicon (microhaplotype) sequencing data
and its associated metadata. It is the R companion to
[pmotools-python](https://github.com/PlasmoGenEpi/pmotools-python) and mirrors
much of its functionality.

## Installation

```r
# install.packages("remotes")
remotes::install_github("PlasmoGenEpi/pmotoolsr")
```

## Index convention: 0-based on disk, 1-based in R

This is the most important thing to know when working with PMOs in R.

A PMO links its sections together with integer indices (for example, a
`library_sample_info` entry points to its specimen via `specimen_id`, and a
detected microhaplotype points into `representative_microhaplotypes` via
`mhaps_target_id`). **On disk these indices are 0-based** (the Python/JSON
convention).

When a PMO is read into R with `read_pmo()` or `read_pmo_raw()`, every index /
`*_id` field (and `panel_targets`) is shifted to be **1-based**, so it behaves
like a normal R index. On write, the shift is reversed automatically. Because
both R list indexing *and* the stored ids are 1-based, you can index directly:

```r
pmo <- read_pmo("my_pmo.json")
lib <- pmo$library_sample_info[[1]]
specimen <- pmo$specimen_info[[ lib$specimen_id ]]   # 1-based, works directly
```

`taxon_id` fields are **not** treated as indices and are never shifted.

Every `pmo_*` function in this package works in this 1-based space, and any PMO
written back out (`write_pmo()`, `write_pmo_raw()`) is converted back to 0-based,
so files remain interoperable with pmotools-python and other tooling.

## Quick start

```r
library(pmotoolsr)

pmo <- read_pmo("my_pmo.json")          # or read_pmo_raw() for a plain list

# explore
pmo_get_specimen_names(pmo)
pmo_count_targets_per_library_sample(pmo)
pmo_count_library_samples_per_target(pmo, collapse_across_runs = TRUE)

# validate against the bundled JSON schema
pmo_validate(pmo)

# subset (returns a new PMO list with all indices remapped)
sub <- pmo_filter_by_target_names(pmo, c("t1", "t5", "t9"))
write_pmo_raw(sub, "subset.json.gz")    # compression inferred from extension

# export flat tables / an allele table / a multi-sheet workbook
pmo_export_specimen_meta_table(pmo)
pmo_extract_alleles_per_sample_table(pmo)
pmo_export_to_excel(pmo, "pmo_tables.xlsx")
```

### Representations

PMOs can be held two ways, and the `pmo_*` functions accept either:

- **R6 object** from `read_pmo()` — the typed `PortableMicrohaplotypeObject` API.
- **Plain nested list** from `read_pmo_raw()` — lighter weight.

Functions that build or subset PMOs (the `pmo_*_table_to_pmo()` builders,
`pmo_filter_*`, `pmo_merge_to_pmo()`, `pmo_combine_pmos()`) return a plain PMO
list. Use `pmo_list_to_r6()` to wrap one back into an R6 object, `write_pmo_raw()`
to write it, or `pmo_validate()` to check it against the schema.

## What's included

- **I/O**: `read_pmo()`, `read_pmo_raw()`, `write_pmo()`, `write_pmo_raw()`
  (gzip/bz2/xz inferred from the file extension).
- **Validation** (`pmo_checker`): `pmo_validate()`, `pmo_validate_jsonschema()`,
  `pmo_load_schema()`, `pmo_required_fields_for_class()`. Bundled schemas are
  validated with [`jsonvalidate`](https://docs.ropensci.org/jsonvalidate/).
- **Processing** (`pmo_processor`): name↔index lookups, name getters, filtering
  by specimen / library / target / read count / metadata, counting and
  aggregation, and allele-frequency extraction.
- **Export** (`pmo_exporter`): flat metadata tables, target/panel insert BED
  extraction, the per-sample allele table (for downstream tools such as dcifer
  and moire), and multi-sheet Excel export.
- **Building** (`pmo_builder`): construct a PMO from tables —
  `pmo_mhap_table_to_pmo()`, `pmo_panel_info_table_to_pmo()`,
  `pmo_specimen_info_table_to_pmo()`, `pmo_library_sample_info_table_to_pmo()`,
  `pmo_read_count_by_stage_table_to_pmo()` — then assemble with
  `pmo_merge_to_pmo()`.
- **Combining**: `pmo_combine_pmos()` merges multiple PMOs into one,
  deduplicating shared entities and remapping every index.

See the function reference (`?pmotoolsr` / `help(package = "pmotoolsr")`) for the
full list.

## For developers

### Running the tests

The test suite uses [testthat](https://testthat.r-lib.org/). From the package
root:

```r
devtools::test()        # run the test suite
devtools::check()       # full R CMD check (build, tests, docs, examples)
```

Or from a shell:

```sh
R CMD INSTALL --install-tests .
Rscript -e 'testthat::test_local()'
```

**Tests do not run automatically on installation.**
`remotes::install_github()` builds and installs the package but does not execute
the test suite; run `devtools::test()` (or `devtools::check()`) explicitly during
development.

### Regenerating documentation

Roxygen comments are the source of truth for the `man/` pages and `NAMESPACE`:

```r
devtools::document()
```

### Relationship to pmotools-python

Most functions are ports of their pmotools-python counterparts and the source
comments note the originating module (for example,
`pmo_engine/pmo_processor.py`). The two implementations are kept in sync; the
main difference is the 0-based ↔ 1-based index convention described above.

## Citation

If you use the Portable Microhaplotype Object format or its tools, please cite:

> Hathaway, N. J., Murie, K., Murphy, M., Simkin, A., Amaya-Romero, J., Hubbard,
> A., Briggs, J., Aranda-Díaz, A., Early, A. M., Wesolowski, A., Neafsey, D. E.,
> Bailey, J. A., & Greenhouse, B. (2025). The Portable Microhaplotype Object and
> tools. In bioRxivorg (p. 2025.12.10.693568). bioRxiv.
> https://doi.org/10.64898/2025.12.10.693568

## License

GPL (>= 3).
