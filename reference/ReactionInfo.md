# ReactionInfo

Information on a panel of targeted amplicon primer pairs.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `panel_targets`: A list of the target indexes in the target_info list.

- `reaction_name`: A name for this reaction.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `panel_targets`:

  A list of the target indexes in the target_info list.

- `reaction_name`:

  A name for this reaction.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ReactionInfo$new()`](#method-ReactionInfo-initialize)

- [`ReactionInfo$validate()`](#method-ReactionInfo-validate)

- [`ReactionInfo$to_list()`](#method-ReactionInfo-to_list)

- [`ReactionInfo$to_json_list()`](#method-ReactionInfo-to_json_list)

- [`ReactionInfo$to_json()`](#method-ReactionInfo-to_json)

- [`ReactionInfo$clone()`](#method-ReactionInfo-clone)

------------------------------------------------------------------------

### `ReactionInfo$new()`

Create a new instance.

#### Usage

    ReactionInfo$new(
      panel_targets = numeric(),
      reaction_name = NA_character_,
      extras = list()
    )

#### Arguments

- `panel_targets`:

  A list of the target indexes in the target_info list.

- `reaction_name`:

  A name for this reaction.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ReactionInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ReactionInfo$validate()

------------------------------------------------------------------------

### `ReactionInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ReactionInfo$to_list()

------------------------------------------------------------------------

### `ReactionInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ReactionInfo$to_json_list()

------------------------------------------------------------------------

### `ReactionInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    ReactionInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `ReactionInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ReactionInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
