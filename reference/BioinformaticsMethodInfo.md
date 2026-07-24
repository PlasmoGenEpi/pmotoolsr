# BioinformaticsMethodInfo

The targeted amplicon bioinformatics methods used to generate the
microhaplotype data in this PMO.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `methods`: Methodology used to generate the microhaplotype data stored
  in this PMO, e.g. demultiplexing method, denosing method, or a
  pipeline method that ties all th steps together.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `methods`:

  Methodology used to generate the microhaplotype data stored in this
  PMO, e.g. demultiplexing method, denosing method, or a pipeline method
  that ties all th steps together.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`BioinformaticsMethodInfo$new()`](#method-BioinformaticsMethodInfo-initialize)

- [`BioinformaticsMethodInfo$validate()`](#method-BioinformaticsMethodInfo-validate)

- [`BioinformaticsMethodInfo$to_list()`](#method-BioinformaticsMethodInfo-to_list)

- [`BioinformaticsMethodInfo$to_json_list()`](#method-BioinformaticsMethodInfo-to_json_list)

- [`BioinformaticsMethodInfo$to_json()`](#method-BioinformaticsMethodInfo-to_json)

- [`BioinformaticsMethodInfo$clone()`](#method-BioinformaticsMethodInfo-clone)

------------------------------------------------------------------------

### `BioinformaticsMethodInfo$new()`

Create a new instance.

#### Usage

    BioinformaticsMethodInfo$new(methods = list(), extras = list())

#### Arguments

- `methods`:

  Methodology used to generate the microhaplotype data stored in this
  PMO, e.g. demultiplexing method, denosing method, or a pipeline method
  that ties all th steps together.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `BioinformaticsMethodInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    BioinformaticsMethodInfo$validate()

------------------------------------------------------------------------

### `BioinformaticsMethodInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    BioinformaticsMethodInfo$to_list()

------------------------------------------------------------------------

### `BioinformaticsMethodInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    BioinformaticsMethodInfo$to_json_list()

------------------------------------------------------------------------

### `BioinformaticsMethodInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    BioinformaticsMethodInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `BioinformaticsMethodInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    BioinformaticsMethodInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
