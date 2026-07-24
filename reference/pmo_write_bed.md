# Write BED rows to a file

Write BED rows to a file

## Usage

``` r
pmo_write_bed(bed, path, add_header = FALSE)
```

## Arguments

- bed:

  A tibble/data.frame as returned by
  [`pmo_extract_targets_insert_bed()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_targets_insert_bed.md).

- path:

  Output file path (overwritten if present).

- add_header:

  Write a commented `#chrom ...` header line.

## Value

Invisibly `path`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
bed <- pmo_extract_targets_insert_bed(p)
pmo_write_bed(bed, tempfile(fileext = ".bed"))
```
