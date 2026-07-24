# Flatten the exportable (primitive / primitive-list) fields of an object

Scalars are kept as-is, atomic vectors and unnamed scalar lists are
joined with `separator`, and nested objects / lists of objects are
skipped.

## Usage

``` r
.flatten_obj(obj, separator, skip = character(0))
```
