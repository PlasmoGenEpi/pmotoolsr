# Merge two lists of dicts by a shared key field

The first list is the base; the second provides updates applied on top,
matched by `key_field`. Both inputs are left unmodified.

## Usage

``` r
pmo_merge_dicts_by_key(
  main_list,
  update_list,
  key_field,
  replace = FALSE,
  ignore_fields = NULL
)
```

## Arguments

- main_list:

  The base list of named lists (source of truth).

- update_list:

  The list of named lists whose values are merged in.

- key_field:

  The field used to match records across the two lists.

- replace:

  If `TRUE`, update values overwrite existing fields; if `FALSE` a
  conflicting field raises an error.

- ignore_fields:

  Optional field names never copied from `update_list`.

## Value

A new list of merged named lists, in `main_list` order.

## Examples

``` r
main <- list(list(name = "a", x = 1), list(name = "b", x = 2))
upd <- list(list(name = "a", y = 10))
pmo_merge_dicts_by_key(main, upd, "name")
#> Warning: The following 'name' values are in main_list but not in update_list (skipping): b
#> [[1]]
#> [[1]]$name
#> [1] "a"
#> 
#> [[1]]$x
#> [1] 1
#> 
#> [[1]]$y
#> [1] 10
#> 
#> 
#> [[2]]
#> [[2]]$name
#> [1] "b"
#> 
#> [[2]]$x
#> [1] 2
#> 
#> 
```
