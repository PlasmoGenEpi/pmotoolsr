# PlateInfo

Information about a plate location, e.g. a standard 96 well plate with
row having a letter and column having a number.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `plate_col`: The column position.

- `plate_name`: A name for the plate.

- `plate_row`: The row position.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `plate_col`:

  The column position.

- `plate_name`:

  A name for the plate.

- `plate_row`:

  The row position.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`PlateInfo$new()`](#method-PlateInfo-initialize)

- [`PlateInfo$validate()`](#method-PlateInfo-validate)

- [`PlateInfo$to_list()`](#method-PlateInfo-to_list)

- [`PlateInfo$to_json_list()`](#method-PlateInfo-to_json_list)

- [`PlateInfo$to_json()`](#method-PlateInfo-to_json)

- [`PlateInfo$clone()`](#method-PlateInfo-clone)

------------------------------------------------------------------------

### `PlateInfo$new()`

Create a new instance.

#### Usage

    PlateInfo$new(
      plate_col = NA_real_,
      plate_name = NA_character_,
      plate_row = NA_character_,
      extras = list()
    )

#### Arguments

- `plate_col`:

  The column position.

- `plate_name`:

  A name for the plate.

- `plate_row`:

  The row position.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `PlateInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    PlateInfo$validate()

------------------------------------------------------------------------

### `PlateInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    PlateInfo$to_list()

------------------------------------------------------------------------

### `PlateInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    PlateInfo$to_json_list()

------------------------------------------------------------------------

### `PlateInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    PlateInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `PlateInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PlateInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
