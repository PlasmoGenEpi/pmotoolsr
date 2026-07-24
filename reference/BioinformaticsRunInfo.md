# BioinformaticsRunInfo

Information about the pipeline run that generated
microhaplotype_detected and reads_by_stage.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `bioinformatics_methods_id`: The index into the
  bioinformatics_methods_info list.

- `bioinformatics_run_name`: A name to for this run, needs to be unique
  to each run.

- `run_date`: The date when the run was done, should be YYYY-MM-DD.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `bioinformatics_methods_id`:

  The index into the bioinformatics_methods_info list.

- `bioinformatics_run_name`:

  A name to for this run, needs to be unique to each run.

- `run_date`:

  The date when the run was done, should be YYYY-MM-DD.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`BioinformaticsRunInfo$new()`](#method-BioinformaticsRunInfo-initialize)

- [`BioinformaticsRunInfo$validate()`](#method-BioinformaticsRunInfo-validate)

- [`BioinformaticsRunInfo$to_list()`](#method-BioinformaticsRunInfo-to_list)

- [`BioinformaticsRunInfo$to_json_list()`](#method-BioinformaticsRunInfo-to_json_list)

- [`BioinformaticsRunInfo$to_json()`](#method-BioinformaticsRunInfo-to_json)

- [`BioinformaticsRunInfo$clone()`](#method-BioinformaticsRunInfo-clone)

------------------------------------------------------------------------

### `BioinformaticsRunInfo$new()`

Create a new instance.

#### Usage

    BioinformaticsRunInfo$new(
      bioinformatics_methods_id = NA_real_,
      bioinformatics_run_name = NA_character_,
      run_date = NULL,
      extras = list()
    )

#### Arguments

- `bioinformatics_methods_id`:

  The index into the bioinformatics_methods_info list.

- `bioinformatics_run_name`:

  A name to for this run, needs to be unique to each run.

- `run_date`:

  The date when the run was done, should be YYYY-MM-DD.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `BioinformaticsRunInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    BioinformaticsRunInfo$validate()

------------------------------------------------------------------------

### `BioinformaticsRunInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    BioinformaticsRunInfo$to_list()

------------------------------------------------------------------------

### `BioinformaticsRunInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    BioinformaticsRunInfo$to_json_list()

------------------------------------------------------------------------

### `BioinformaticsRunInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    BioinformaticsRunInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `BioinformaticsRunInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    BioinformaticsRunInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
