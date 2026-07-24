# Test whether an optional PMO section is present and non-empty

Test whether an optional PMO section is present and non-empty

## Usage

``` r
pmo_has_section(pmo, section)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

- section:

  The name of a top-level PMO section.

## Value

`TRUE` if the section is present and contains at least one element.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
pmo_has_section(p, "sequencing_info")
#> [1] TRUE
```
