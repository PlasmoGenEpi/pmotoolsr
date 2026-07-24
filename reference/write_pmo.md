# Write a PMO object to a file

Information on final microhaplotype results from a targeted amplicon
analysis with associated meta data.

## Usage

``` r
write_pmo(pmo, path, pretty = FALSE, auto_unbox = TRUE, validate = TRUE, ...)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` instance.

- path:

  Output path.

- pretty:

  Logical; pretty-print the JSON.

- auto_unbox:

  Logical; passed to
  [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).

- validate:

  Logical; if `TRUE`, validate before writing.

- ...:

  Additional arguments passed through to `to_json()`.

## Value

Invisibly returns `path`.

## Details

Writes a PMO object to JSON, with optional compression inferred from the
file extension.

## Examples

``` r
pmo <- read_pmo(
  system.file('extdata', 'example_pmo.json.gz', package = 'pmotoolsr'))
write_pmo(pmo, tempfile(fileext = '.json'))
```
