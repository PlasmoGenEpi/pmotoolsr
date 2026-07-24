# PanelInfo

Information on a panel of targeted amplicon primer pairs.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `panel_name`: A name for the panel.

- `reactions`: A list of 1 or more reactions that this panel contains,
  each reactions list the targets that were amplified in that reaction,
  e.g. pool1, pool2.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `panel_name`:

  A name for the panel.

- `reactions`:

  A list of 1 or more reactions that this panel contains, each reactions
  list the targets that were amplified in that reaction, e.g. pool1,
  pool2.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`PanelInfo$new()`](#method-PanelInfo-initialize)

- [`PanelInfo$validate()`](#method-PanelInfo-validate)

- [`PanelInfo$to_list()`](#method-PanelInfo-to_list)

- [`PanelInfo$to_json_list()`](#method-PanelInfo-to_json_list)

- [`PanelInfo$to_json()`](#method-PanelInfo-to_json)

- [`PanelInfo$clone()`](#method-PanelInfo-clone)

------------------------------------------------------------------------

### `PanelInfo$new()`

Create a new instance.

#### Usage

    PanelInfo$new(panel_name = NA_character_, reactions = list(), extras = list())

#### Arguments

- `panel_name`:

  A name for the panel.

- `reactions`:

  A list of 1 or more reactions that this panel contains, each reactions
  list the targets that were amplified in that reaction, e.g. pool1,
  pool2.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `PanelInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    PanelInfo$validate()

------------------------------------------------------------------------

### `PanelInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    PanelInfo$to_list()

------------------------------------------------------------------------

### `PanelInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    PanelInfo$to_json_list()

------------------------------------------------------------------------

### `PanelInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    PanelInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `PanelInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PanelInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
