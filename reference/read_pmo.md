# Read a PMO object from a file

Information on final microhaplotype results from a targeted amplicon
analysis with associated meta data.

## Usage

``` r
read_pmo(path, validate = TRUE)
```

## Arguments

- path:

  Path to the PMO JSON file.

- validate:

  Logical; if `TRUE`, validate the parsed object.

## Value

A `PortableMicrohaplotypeObject` instance.

## Details

Reads a PMO JSON file from disk, including compressed files ending in
`.gz`, `.bz2`, or `.xz`, and parses it into a PMO R6 instance.

## Examples

``` r
pmo <- read_pmo(
  system.file('extdata', 'example_pmo.json.gz', package = 'pmotoolsr'))
```
