# ReadCountsByStageForTarget

Information on the reads counts at several stages of a pipeline for a
target.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `stages`: The read counts by each stage.

- `target_id`: The index into the target_info list.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `stages`:

  The read counts by each stage.

- `target_id`:

  The index into the target_info list.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ReadCountsByStageForTarget$new()`](#method-ReadCountsByStageForTarget-initialize)

- [`ReadCountsByStageForTarget$validate()`](#method-ReadCountsByStageForTarget-validate)

- [`ReadCountsByStageForTarget$to_list()`](#method-ReadCountsByStageForTarget-to_list)

- [`ReadCountsByStageForTarget$to_json_list()`](#method-ReadCountsByStageForTarget-to_json_list)

- [`ReadCountsByStageForTarget$to_json()`](#method-ReadCountsByStageForTarget-to_json)

- [`ReadCountsByStageForTarget$clone()`](#method-ReadCountsByStageForTarget-clone)

------------------------------------------------------------------------

### `ReadCountsByStageForTarget$new()`

Create a new instance.

#### Usage

    ReadCountsByStageForTarget$new(
      stages = list(),
      target_id = NA_real_,
      extras = list()
    )

#### Arguments

- `stages`:

  The read counts by each stage.

- `target_id`:

  The index into the target_info list.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ReadCountsByStageForTarget$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ReadCountsByStageForTarget$validate()

------------------------------------------------------------------------

### `ReadCountsByStageForTarget$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ReadCountsByStageForTarget$to_list()

------------------------------------------------------------------------

### `ReadCountsByStageForTarget$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ReadCountsByStageForTarget$to_json_list()

------------------------------------------------------------------------

### `ReadCountsByStageForTarget$to_json()`

Convert the object to a JSON string.

#### Usage

    ReadCountsByStageForTarget$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `ReadCountsByStageForTarget$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ReadCountsByStageForTarget$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
