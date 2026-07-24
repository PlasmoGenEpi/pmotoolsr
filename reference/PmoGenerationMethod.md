# PmoGenerationMethod

Information about how a PMO was generated.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `program_name`: The name of the program.

- `program_version`: The version of program, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `program_name`:

  The name of the program.

- `program_version`:

  The version of program, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`PmoGenerationMethod$new()`](#method-PmoGenerationMethod-initialize)

- [`PmoGenerationMethod$validate()`](#method-PmoGenerationMethod-validate)

- [`PmoGenerationMethod$to_list()`](#method-PmoGenerationMethod-to_list)

- [`PmoGenerationMethod$to_json_list()`](#method-PmoGenerationMethod-to_json_list)

- [`PmoGenerationMethod$to_json()`](#method-PmoGenerationMethod-to_json)

- [`PmoGenerationMethod$clone()`](#method-PmoGenerationMethod-clone)

------------------------------------------------------------------------

### `PmoGenerationMethod$new()`

Create a new instance.

#### Usage

    PmoGenerationMethod$new(
      program_name = NA_character_,
      program_version = NA_character_,
      extras = list()
    )

#### Arguments

- `program_name`:

  The name of the program.

- `program_version`:

  The version of program, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `PmoGenerationMethod$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    PmoGenerationMethod$validate()

------------------------------------------------------------------------

### `PmoGenerationMethod$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    PmoGenerationMethod$to_list()

------------------------------------------------------------------------

### `PmoGenerationMethod$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    PmoGenerationMethod$to_json_list()

------------------------------------------------------------------------

### `PmoGenerationMethod$to_json()`

Convert the object to a JSON string.

#### Usage

    PmoGenerationMethod$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `PmoGenerationMethod$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PmoGenerationMethod$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
