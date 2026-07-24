# Parse a metadata-grouping specification

Accepts either a path to a tab-delimited file with columns `field`,
`values` (comma-separated) and an optional `group`, or an inline string
of the form `field1=v1,v2:field2=v3;field1=v4` where groups are
separated by `;`, fields within a group by `:`, field/values by `=`, and
values by `,`.

## Usage

``` r
.parse_meta_groupings(meta_fields_values)
```

## Arguments

- meta_fields_values:

  File path or inline specification string.

## Value

A named list keyed by group, each a named list of
`field -> character vector of values`.
