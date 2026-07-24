# PrimerInfo

Information on a primer sequence.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `location`: What the intended genomic location of the primer is.

- `seq`: The sequence.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `location`:

  What the intended genomic location of the primer is.

- `seq`:

  The sequence.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`PrimerInfo$new()`](#method-PrimerInfo-initialize)

- [`PrimerInfo$validate()`](#method-PrimerInfo-validate)

- [`PrimerInfo$to_list()`](#method-PrimerInfo-to_list)

- [`PrimerInfo$to_json_list()`](#method-PrimerInfo-to_json_list)

- [`PrimerInfo$to_json()`](#method-PrimerInfo-to_json)

- [`PrimerInfo$clone()`](#method-PrimerInfo-clone)

------------------------------------------------------------------------

### `PrimerInfo$new()`

Create a new instance.

#### Usage

    PrimerInfo$new(location = NULL, seq = NA_character_, extras = list())

#### Arguments

- `location`:

  What the intended genomic location of the primer is.

- `seq`:

  The sequence.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `PrimerInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    PrimerInfo$validate()

------------------------------------------------------------------------

### `PrimerInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    PrimerInfo$to_list()

------------------------------------------------------------------------

### `PrimerInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    PrimerInfo$to_json_list()

------------------------------------------------------------------------

### `PrimerInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    PrimerInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `PrimerInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PrimerInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
