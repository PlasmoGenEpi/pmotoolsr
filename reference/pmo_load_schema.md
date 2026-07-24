# Load a bundled PMO JSON schema

Load a bundled PMO JSON schema

## Usage

``` r
pmo_load_schema(name)
```

## Arguments

- name:

  Schema filename (e.g.
  `"portable_microhaplotype_object_v1.1.0.schema.json"`).

## Value

The parsed schema as a nested list.

## Examples

``` r
schema <- pmo_load_schema("portable_microhaplotype_object_v1.1.0.schema.json")
names(schema)
#>  [1] "$defs"                "$id"                  "$schema"             
#>  [4] "additionalProperties" "description"          "metamodel_version"   
#>  [7] "properties"           "required"             "title"               
#> [10] "type"                 "version"             
```
