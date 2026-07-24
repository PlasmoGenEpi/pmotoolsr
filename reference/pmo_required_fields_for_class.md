# Get the required fields for a PMO schema class

Get the required fields for a PMO schema class

## Usage

``` r
pmo_required_fields_for_class(class_name, schema = NULL)
```

## Arguments

- class_name:

  A schema class name (a key under the schema's `$defs`, e.g.
  `"SpecimenInfo"`).

- schema:

  Optional parsed schema; defaults to the bundled default.

## Value

A character vector of required field names (possibly empty).

## Examples

``` r
pmo_required_fields_for_class("SpecimenInfo")
#> [1] "specimen_name"
pmo_required_fields_for_class("LibrarySampleInfo")
#> [1] "specimen_id"         "panel_id"            "library_sample_name"
```
