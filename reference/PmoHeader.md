# PmoHeader

Information on the PMO file itself.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `creation_date`: The date of when the PMO file was created or
  modified, should be YYYY-MM-DD.

- `generation_method`: The generation method to create this PMO.

- `pmo_version`: The version of the PMO file, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `creation_date`:

  The date of when the PMO file was created or modified, should be
  YYYY-MM-DD.

- `generation_method`:

  The generation method to create this PMO.

- `pmo_version`:

  The version of the PMO file, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`PmoHeader$new()`](#method-PmoHeader-initialize)

- [`PmoHeader$validate()`](#method-PmoHeader-validate)

- [`PmoHeader$to_list()`](#method-PmoHeader-to_list)

- [`PmoHeader$to_json_list()`](#method-PmoHeader-to_json_list)

- [`PmoHeader$to_json()`](#method-PmoHeader-to_json)

- [`PmoHeader$clone()`](#method-PmoHeader-clone)

------------------------------------------------------------------------

### `PmoHeader$new()`

Create a new instance.

#### Usage

    PmoHeader$new(
      creation_date = NULL,
      generation_method = NULL,
      pmo_version = NA_character_,
      extras = list()
    )

#### Arguments

- `creation_date`:

  The date of when the PMO file was created or modified, should be
  YYYY-MM-DD.

- `generation_method`:

  The generation method to create this PMO.

- `pmo_version`:

  The version of the PMO file, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `PmoHeader$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    PmoHeader$validate()

------------------------------------------------------------------------

### `PmoHeader$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    PmoHeader$to_list()

------------------------------------------------------------------------

### `PmoHeader$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    PmoHeader$to_json_list()

------------------------------------------------------------------------

### `PmoHeader$to_json()`

Convert the object to a JSON string.

#### Usage

    PmoHeader$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `PmoHeader$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PmoHeader$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
