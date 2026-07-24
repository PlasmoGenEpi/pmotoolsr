# Pseudocigar

Information on pseudocigar for a sequence.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `pseudocigar_generation_description`: A description of how the
  pseudocigar information was generated.

- `pseudocigar_seq`: The pseudocigar itself.

- `ref_loc`: The genomic location the pseudocigar is in reference to.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `pseudocigar_generation_description`:

  A description of how the pseudocigar information was generated.

- `pseudocigar_seq`:

  The pseudocigar itself.

- `ref_loc`:

  The genomic location the pseudocigar is in reference to.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`Pseudocigar$new()`](#method-Pseudocigar-initialize)

- [`Pseudocigar$validate()`](#method-Pseudocigar-validate)

- [`Pseudocigar$to_list()`](#method-Pseudocigar-to_list)

- [`Pseudocigar$to_json_list()`](#method-Pseudocigar-to_json_list)

- [`Pseudocigar$to_json()`](#method-Pseudocigar-to_json)

- [`Pseudocigar$clone()`](#method-Pseudocigar-clone)

------------------------------------------------------------------------

### `Pseudocigar$new()`

Create a new instance.

#### Usage

    Pseudocigar$new(
      pseudocigar_generation_description = NULL,
      pseudocigar_seq = NA_character_,
      ref_loc = NULL,
      extras = list()
    )

#### Arguments

- `pseudocigar_generation_description`:

  A description of how the pseudocigar information was generated.

- `pseudocigar_seq`:

  The pseudocigar itself.

- `ref_loc`:

  The genomic location the pseudocigar is in reference to.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `Pseudocigar$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    Pseudocigar$validate()

------------------------------------------------------------------------

### `Pseudocigar$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    Pseudocigar$to_list()

------------------------------------------------------------------------

### `Pseudocigar$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    Pseudocigar$to_json_list()

------------------------------------------------------------------------

### `Pseudocigar$to_json()`

Convert the object to a JSON string.

#### Usage

    Pseudocigar$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `Pseudocigar$clone()`

The objects of this class are cloneable with this method.

#### Usage

    Pseudocigar$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
