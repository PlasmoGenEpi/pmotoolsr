# Read a PMO file as a raw nested list

Reads a PMO JSON file directly into nested R lists without wrapping it
into R6 classes. This is useful for performance comparisons or workflows
that do not need the object-oriented API.

## Usage

``` r
read_pmo_raw(path)
```

## Arguments

- path:

  Path to the PMO JSON file.

## Value

A nested list parsed from JSON.

## Examples

``` r
raw <- read_pmo_raw(
  system.file('extdata', 'example_pmo.json.gz', package = 'pmotoolsr'))
```
