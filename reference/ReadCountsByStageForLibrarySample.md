# ReadCountsByStageForLibrarySample

Information on the reads counts at several stages of a pipeline for a
library_sample.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `library_sample_id`: The index into the library_sample_info list.

- `read_counts_for_targets`: A list of counts by stage for a target.

- `total_raw_count`: The raw counts off the sequencing machine that a
  sample began with.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `library_sample_id`:

  The index into the library_sample_info list.

- `read_counts_for_targets`:

  A list of counts by stage for a target.

- `total_raw_count`:

  The raw counts off the sequencing machine that a sample began with.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ReadCountsByStageForLibrarySample$new()`](#method-ReadCountsByStageForLibrarySample-initialize)

- [`ReadCountsByStageForLibrarySample$validate()`](#method-ReadCountsByStageForLibrarySample-validate)

- [`ReadCountsByStageForLibrarySample$to_list()`](#method-ReadCountsByStageForLibrarySample-to_list)

- [`ReadCountsByStageForLibrarySample$to_json_list()`](#method-ReadCountsByStageForLibrarySample-to_json_list)

- [`ReadCountsByStageForLibrarySample$to_json()`](#method-ReadCountsByStageForLibrarySample-to_json)

- [`ReadCountsByStageForLibrarySample$clone()`](#method-ReadCountsByStageForLibrarySample-clone)

------------------------------------------------------------------------

### `ReadCountsByStageForLibrarySample$new()`

Create a new instance.

#### Usage

    ReadCountsByStageForLibrarySample$new(
      library_sample_id = NA_real_,
      read_counts_for_targets = NULL,
      total_raw_count = NA_real_,
      extras = list()
    )

#### Arguments

- `library_sample_id`:

  The index into the library_sample_info list.

- `read_counts_for_targets`:

  A list of counts by stage for a target.

- `total_raw_count`:

  The raw counts off the sequencing machine that a sample began with.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ReadCountsByStageForLibrarySample$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ReadCountsByStageForLibrarySample$validate()

------------------------------------------------------------------------

### `ReadCountsByStageForLibrarySample$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ReadCountsByStageForLibrarySample$to_list()

------------------------------------------------------------------------

### `ReadCountsByStageForLibrarySample$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ReadCountsByStageForLibrarySample$to_json_list()

------------------------------------------------------------------------

### `ReadCountsByStageForLibrarySample$to_json()`

Convert the object to a JSON string.

#### Usage

    ReadCountsByStageForLibrarySample$to_json(
      pretty = FALSE,
      auto_unbox = TRUE,
      ...
    )

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

### `ReadCountsByStageForLibrarySample$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ReadCountsByStageForLibrarySample$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
