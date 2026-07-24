# DetectedMicrohaplotypes

The microhaplotypes detected in a targeted amplicon analysis.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `bioinformatics_run_id`: The index into bioinformatics_run_info list.

- `library_samples`: A list of the microhaplotypes detected for all
  samples with a list for each target.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `bioinformatics_run_id`:

  The index into bioinformatics_run_info list.

- `library_samples`:

  A list of the microhaplotypes detected for all samples with a list for
  each target.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`DetectedMicrohaplotypes$new()`](#method-DetectedMicrohaplotypes-initialize)

- [`DetectedMicrohaplotypes$validate()`](#method-DetectedMicrohaplotypes-validate)

- [`DetectedMicrohaplotypes$to_list()`](#method-DetectedMicrohaplotypes-to_list)

- [`DetectedMicrohaplotypes$to_json_list()`](#method-DetectedMicrohaplotypes-to_json_list)

- [`DetectedMicrohaplotypes$to_json()`](#method-DetectedMicrohaplotypes-to_json)

- [`DetectedMicrohaplotypes$clone()`](#method-DetectedMicrohaplotypes-clone)

------------------------------------------------------------------------

### `DetectedMicrohaplotypes$new()`

Create a new instance.

#### Usage

    DetectedMicrohaplotypes$new(
      bioinformatics_run_id = NULL,
      library_samples = list(),
      extras = list()
    )

#### Arguments

- `bioinformatics_run_id`:

  The index into bioinformatics_run_info list.

- `library_samples`:

  A list of the microhaplotypes detected for all samples with a list for
  each target.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `DetectedMicrohaplotypes$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    DetectedMicrohaplotypes$validate()

------------------------------------------------------------------------

### `DetectedMicrohaplotypes$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    DetectedMicrohaplotypes$to_list()

------------------------------------------------------------------------

### `DetectedMicrohaplotypes$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    DetectedMicrohaplotypes$to_json_list()

------------------------------------------------------------------------

### `DetectedMicrohaplotypes$to_json()`

Convert the object to a JSON string.

#### Usage

    DetectedMicrohaplotypes$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `DetectedMicrohaplotypes$clone()`

The objects of this class are cloneable with this method.

#### Usage

    DetectedMicrohaplotypes$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
