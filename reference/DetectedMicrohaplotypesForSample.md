# DetectedMicrohaplotypesForSample

Microhaplotypes detected for a sample for all targets.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `library_sample_id`: The index into the library_sample_info list.

- `target_results`: A list of the microhaplotypes detected for a list of
  targets.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `library_sample_id`:

  The index into the library_sample_info list.

- `target_results`:

  A list of the microhaplotypes detected for a list of targets.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`DetectedMicrohaplotypesForSample$new()`](#method-DetectedMicrohaplotypesForSample-initialize)

- [`DetectedMicrohaplotypesForSample$validate()`](#method-DetectedMicrohaplotypesForSample-validate)

- [`DetectedMicrohaplotypesForSample$to_list()`](#method-DetectedMicrohaplotypesForSample-to_list)

- [`DetectedMicrohaplotypesForSample$to_json_list()`](#method-DetectedMicrohaplotypesForSample-to_json_list)

- [`DetectedMicrohaplotypesForSample$to_json()`](#method-DetectedMicrohaplotypesForSample-to_json)

- [`DetectedMicrohaplotypesForSample$clone()`](#method-DetectedMicrohaplotypesForSample-clone)

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForSample$new()`

Create a new instance.

#### Usage

    DetectedMicrohaplotypesForSample$new(
      library_sample_id = NA_real_,
      target_results = list(),
      extras = list()
    )

#### Arguments

- `library_sample_id`:

  The index into the library_sample_info list.

- `target_results`:

  A list of the microhaplotypes detected for a list of targets.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForSample$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    DetectedMicrohaplotypesForSample$validate()

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForSample$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    DetectedMicrohaplotypesForSample$to_list()

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForSample$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    DetectedMicrohaplotypesForSample$to_json_list()

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForSample$to_json()`

Convert the object to a JSON string.

#### Usage

    DetectedMicrohaplotypesForSample$to_json(
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

### `DetectedMicrohaplotypesForSample$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DetectedMicrohaplotypesForSample$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
