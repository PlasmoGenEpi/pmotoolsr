# Export a PMO to a multi-sheet Excel workbook

Export a PMO to a multi-sheet Excel workbook

## Usage

``` r
pmo_export_to_excel(pmo, output_path)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- output_path:

  Path to write the `.xlsx` file.

## Value

Invisibly `output_path`.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
# \donttest{
pmo_export_to_excel(p, tempfile(fileext = ".xlsx"))
# }
```
