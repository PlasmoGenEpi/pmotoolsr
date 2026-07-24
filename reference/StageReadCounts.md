# StageReadCounts

Information on the reads counts at several stages.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `reads`: The read counts for this stage.

- `stage`: The stage of the pipeline, e.g. demultiplexed, denoised, etc.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `reads`:

  The read counts for this stage.

- `stage`:

  The stage of the pipeline, e.g. demultiplexed, denoised, etc.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`StageReadCounts$new()`](#method-StageReadCounts-initialize)

- [`StageReadCounts$validate()`](#method-StageReadCounts-validate)

- [`StageReadCounts$to_list()`](#method-StageReadCounts-to_list)

- [`StageReadCounts$to_json_list()`](#method-StageReadCounts-to_json_list)

- [`StageReadCounts$to_json()`](#method-StageReadCounts-to_json)

- [`StageReadCounts$clone()`](#method-StageReadCounts-clone)

------------------------------------------------------------------------

### `StageReadCounts$new()`

Create a new instance.

#### Usage

    StageReadCounts$new(reads = NA_real_, stage = NA_character_, extras = list())

#### Arguments

- `reads`:

  The read counts for this stage.

- `stage`:

  The stage of the pipeline, e.g. demultiplexed, denoised, etc.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `StageReadCounts$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    StageReadCounts$validate()

------------------------------------------------------------------------

### `StageReadCounts$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    StageReadCounts$to_list()

------------------------------------------------------------------------

### `StageReadCounts$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    StageReadCounts$to_json_list()

------------------------------------------------------------------------

### `StageReadCounts$to_json()`

Convert the object to a JSON string.

#### Usage

    StageReadCounts$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `StageReadCounts$clone()`

The objects of this class are cloneable with this method.

#### Usage

    StageReadCounts$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
