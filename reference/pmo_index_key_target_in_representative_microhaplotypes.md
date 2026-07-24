# Build a target-name to representative-microhaplotype-index lookup

Returns a named integer vector mapping each target name to its 1-based
index within `representative_microhaplotypes$targets` (which may be
ordered differently from, and may not cover all of, `target_info`).

## Usage

``` r
pmo_index_key_target_in_representative_microhaplotypes(pmo)
```

## Arguments

- pmo:

  A `PortableMicrohaplotypeObject` or parsed PMO list.

## Value

A named integer vector of 1-based indices keyed by target name.

## Examples

``` r
p <- read_pmo(
  system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
head(pmo_index_key_target_in_representative_microhaplotypes(p))
#>   t1  t10 t100  t11  t12  t13 
#>    1    2    3    4    5    6 
```
