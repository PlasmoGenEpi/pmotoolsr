# Load a bundled PMO JSON schema by version

Load a bundled PMO JSON schema by version

## Usage

``` r
pmo_load_schema_by_version(version)
```

## Arguments

- version:

  Version string (e.g. `"1.0.0"`, `"1.1.0"`).

## Value

The parsed schema as a nested list.

## Examples

``` r
schema <- pmo_load_schema_by_version("1.1.0")
head(names(schema[["$defs"]]))
#> [1] "BioMethod"                        "BioinformaticsMethodInfo"        
#> [3] "BioinformaticsRunInfo"            "DetectedMicrohaplotypes"         
#> [5] "DetectedMicrohaplotypesForSample" "DetectedMicrohaplotypesForTarget"
```
