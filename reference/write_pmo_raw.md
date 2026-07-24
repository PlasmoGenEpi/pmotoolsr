# Write a raw PMO nested list to a file

Writes a PMO represented as nested R lists back to JSON, reapplying
JSON-facing conventions such as zero-based `_id` fields.

## Usage

``` r
write_pmo_raw(x, path, pretty = FALSE, auto_unbox = TRUE)
```

## Arguments

- x:

  A nested list as returned by
  [`read_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo_raw.md).

- path:

  Output path.

- pretty:

  Logical; pretty-print the JSON.

- auto_unbox:

  Logical; passed to
  [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).

## Value

Invisibly returns `path`.

## Examples

``` r
raw <- read_pmo_raw(
  system.file('extdata', 'example_pmo.json.gz', package = 'pmotoolsr'))
write_pmo_raw(raw, tempfile(fileext = '.json.gz'))
```
