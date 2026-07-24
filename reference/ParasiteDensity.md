# ParasiteDensity

Method and value of determined parasite density.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `date_measured`: The date the qpcr was performed, can be YYYY,
  YYYY-MM, or YYYY-MM-DD.

- `density_method_comments`: Additional comments about how the density
  was performed.

- `parasite_density`: The density in microliters.

- `parasite_density_method`: The method of how this density was
  obtained.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `date_measured`:

  The date the qpcr was performed, can be YYYY, YYYY-MM, or YYYY-MM-DD.

- `density_method_comments`:

  Additional comments about how the density was performed.

- `parasite_density`:

  The density in microliters.

- `parasite_density_method`:

  The method of how this density was obtained.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ParasiteDensity$new()`](#method-ParasiteDensity-initialize)

- [`ParasiteDensity$validate()`](#method-ParasiteDensity-validate)

- [`ParasiteDensity$to_list()`](#method-ParasiteDensity-to_list)

- [`ParasiteDensity$to_json_list()`](#method-ParasiteDensity-to_json_list)

- [`ParasiteDensity$to_json()`](#method-ParasiteDensity-to_json)

- [`ParasiteDensity$clone()`](#method-ParasiteDensity-clone)

------------------------------------------------------------------------

### `ParasiteDensity$new()`

Create a new instance.

#### Usage

    ParasiteDensity$new(
      date_measured = NULL,
      density_method_comments = NULL,
      parasite_density = NA_real_,
      parasite_density_method = NA_character_,
      extras = list()
    )

#### Arguments

- `date_measured`:

  The date the qpcr was performed, can be YYYY, YYYY-MM, or YYYY-MM-DD.

- `density_method_comments`:

  Additional comments about how the density was performed.

- `parasite_density`:

  The density in microliters.

- `parasite_density_method`:

  The method of how this density was obtained.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ParasiteDensity$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ParasiteDensity$validate()

------------------------------------------------------------------------

### `ParasiteDensity$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ParasiteDensity$to_list()

------------------------------------------------------------------------

### `ParasiteDensity$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ParasiteDensity$to_json_list()

------------------------------------------------------------------------

### `ParasiteDensity$to_json()`

Convert the object to a JSON string.

#### Usage

    ParasiteDensity$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

#### Arguments

- `pretty`:

  Logical; pretty-print the JSON.

- `auto_unbox`:

  Logical; passed to
  [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).

- `...`:

  Additional arguments passed to
  [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).

------------------------------------------------------------------------

### `ParasiteDensity$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ParasiteDensity$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
