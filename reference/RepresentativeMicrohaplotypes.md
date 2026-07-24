# RepresentativeMicrohaplotypes

A collection of representative sequences for microhaplotypes for all
targets.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `targets`: A list of the microhaplotypes for each targets.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `targets`:

  A list of the microhaplotypes for each targets.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`RepresentativeMicrohaplotypes$new()`](#method-RepresentativeMicrohaplotypes-initialize)

- [`RepresentativeMicrohaplotypes$validate()`](#method-RepresentativeMicrohaplotypes-validate)

- [`RepresentativeMicrohaplotypes$to_list()`](#method-RepresentativeMicrohaplotypes-to_list)

- [`RepresentativeMicrohaplotypes$to_json_list()`](#method-RepresentativeMicrohaplotypes-to_json_list)

- [`RepresentativeMicrohaplotypes$to_json()`](#method-RepresentativeMicrohaplotypes-to_json)

- [`RepresentativeMicrohaplotypes$clone()`](#method-RepresentativeMicrohaplotypes-clone)

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypes$new()`

Create a new instance.

#### Usage

    RepresentativeMicrohaplotypes$new(targets = list(), extras = list())

#### Arguments

- `targets`:

  A list of the microhaplotypes for each targets.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypes$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    RepresentativeMicrohaplotypes$validate()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypes$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    RepresentativeMicrohaplotypes$to_list()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypes$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    RepresentativeMicrohaplotypes$to_json_list()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypes$to_json()`

Convert the object to a JSON string.

#### Usage

    RepresentativeMicrohaplotypes$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `RepresentativeMicrohaplotypes$clone()`

The objects of this class are cloneable with this method.

#### Usage

    RepresentativeMicrohaplotypes$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
