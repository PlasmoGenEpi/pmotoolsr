# Coerce a PMO to a plain nested list

Internal helper that accepts either a
[PortableMicrohaplotypeObject](https://plasmogenepi.github.io/pmotoolsr/reference/PortableMicrohaplotypeObject.md)
R6 instance or an already-parsed PMO list (as returned by
[`read_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo_raw.md))
and returns a plain nested list with 1-based id fields.

## Usage

``` r
.pmo_as_list(pmo)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or a PMO list.

## Value

A nested list representation of the PMO.
