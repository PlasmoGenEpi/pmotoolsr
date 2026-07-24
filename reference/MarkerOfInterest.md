# MarkerOfInterest

A specific genomic location of interest, e.g. drug resistance, or other
phenotypical marker.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `associations`: A list of associations with this marker, e.g. SP
  resistance, etc.

- `marker_location`: The genomic location.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `associations`:

  A list of associations with this marker, e.g. SP resistance, etc.

- `marker_location`:

  The genomic location.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`MarkerOfInterest$new()`](#method-MarkerOfInterest-initialize)

- [`MarkerOfInterest$validate()`](#method-MarkerOfInterest-validate)

- [`MarkerOfInterest$to_list()`](#method-MarkerOfInterest-to_list)

- [`MarkerOfInterest$to_json_list()`](#method-MarkerOfInterest-to_json_list)

- [`MarkerOfInterest$to_json()`](#method-MarkerOfInterest-to_json)

- [`MarkerOfInterest$clone()`](#method-MarkerOfInterest-clone)

------------------------------------------------------------------------

### `MarkerOfInterest$new()`

Create a new instance.

#### Usage

    MarkerOfInterest$new(
      associations = NULL,
      marker_location = NULL,
      extras = list()
    )

#### Arguments

- `associations`:

  A list of associations with this marker, e.g. SP resistance, etc.

- `marker_location`:

  The genomic location.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `MarkerOfInterest$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    MarkerOfInterest$validate()

------------------------------------------------------------------------

### `MarkerOfInterest$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    MarkerOfInterest$to_list()

------------------------------------------------------------------------

### `MarkerOfInterest$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    MarkerOfInterest$to_json_list()

------------------------------------------------------------------------

### `MarkerOfInterest$to_json()`

Convert the object to a JSON string.

#### Usage

    MarkerOfInterest$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `MarkerOfInterest$clone()`

The objects of this class are cloneable with this method.

#### Usage

    MarkerOfInterest$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
