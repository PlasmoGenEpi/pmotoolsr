# ReadCountsByStage

Information on the reads counts at several stages of a pipeline.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `bioinformatics_run_id`: The index into bioinformatics_run_info list.

- `read_counts_by_library_sample_by_stage`: A list by library_sample for
  the counts at each stage.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `bioinformatics_run_id`:

  The index into bioinformatics_run_info list.

- `read_counts_by_library_sample_by_stage`:

  A list by library_sample for the counts at each stage.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ReadCountsByStage$new()`](#method-ReadCountsByStage-initialize)

- [`ReadCountsByStage$validate()`](#method-ReadCountsByStage-validate)

- [`ReadCountsByStage$to_list()`](#method-ReadCountsByStage-to_list)

- [`ReadCountsByStage$to_json_list()`](#method-ReadCountsByStage-to_json_list)

- [`ReadCountsByStage$to_json()`](#method-ReadCountsByStage-to_json)

- [`ReadCountsByStage$clone()`](#method-ReadCountsByStage-clone)

------------------------------------------------------------------------

### `ReadCountsByStage$new()`

Create a new instance.

#### Usage

    ReadCountsByStage$new(
      bioinformatics_run_id = NULL,
      read_counts_by_library_sample_by_stage = list(),
      extras = list()
    )

#### Arguments

- `bioinformatics_run_id`:

  The index into bioinformatics_run_info list.

- `read_counts_by_library_sample_by_stage`:

  A list by library_sample for the counts at each stage.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ReadCountsByStage$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ReadCountsByStage$validate()

------------------------------------------------------------------------

### `ReadCountsByStage$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ReadCountsByStage$to_list()

------------------------------------------------------------------------

### `ReadCountsByStage$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ReadCountsByStage$to_json_list()

------------------------------------------------------------------------

### `ReadCountsByStage$to_json()`

Convert the object to a JSON string.

#### Usage

    ReadCountsByStage$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `ReadCountsByStage$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ReadCountsByStage$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
