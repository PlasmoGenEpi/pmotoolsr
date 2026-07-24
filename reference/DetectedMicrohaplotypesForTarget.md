# DetectedMicrohaplotypesForTarget

Microhaplotypes detected for a specific target.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `mhaps`: A list of the microhaplotypes detected for this target.

- `mhaps_target_id`: The index for a target in the
  representative_microhaplotypes list.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `mhaps`:

  A list of the microhaplotypes detected for this target.

- `mhaps_target_id`:

  The index for a target in the representative_microhaplotypes list.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`DetectedMicrohaplotypesForTarget$new()`](#method-DetectedMicrohaplotypesForTarget-initialize)

- [`DetectedMicrohaplotypesForTarget$validate()`](#method-DetectedMicrohaplotypesForTarget-validate)

- [`DetectedMicrohaplotypesForTarget$to_list()`](#method-DetectedMicrohaplotypesForTarget-to_list)

- [`DetectedMicrohaplotypesForTarget$to_json_list()`](#method-DetectedMicrohaplotypesForTarget-to_json_list)

- [`DetectedMicrohaplotypesForTarget$to_json()`](#method-DetectedMicrohaplotypesForTarget-to_json)

- [`DetectedMicrohaplotypesForTarget$clone()`](#method-DetectedMicrohaplotypesForTarget-clone)

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForTarget$new()`

Create a new instance.

#### Usage

    DetectedMicrohaplotypesForTarget$new(
      mhaps = list(),
      mhaps_target_id = NA_real_,
      extras = list()
    )

#### Arguments

- `mhaps`:

  A list of the microhaplotypes detected for this target.

- `mhaps_target_id`:

  The index for a target in the representative_microhaplotypes list.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForTarget$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    DetectedMicrohaplotypesForTarget$validate()

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForTarget$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    DetectedMicrohaplotypesForTarget$to_list()

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForTarget$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    DetectedMicrohaplotypesForTarget$to_json_list()

------------------------------------------------------------------------

### `DetectedMicrohaplotypesForTarget$to_json()`

Convert the object to a JSON string.

#### Usage

    DetectedMicrohaplotypesForTarget$to_json(
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

### `DetectedMicrohaplotypesForTarget$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DetectedMicrohaplotypesForTarget$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
