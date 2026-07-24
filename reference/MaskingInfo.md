# MaskingInfo

Information about a subsegment of the sequence that should be masked.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `masking_generation_description`: A description of how the masking
  information was generated.

- `replacement_size`: The size of replacement mask.

- `seq_segment_size`: The size of the masking.

- `seq_start`: The start of the masking.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `masking_generation_description`:

  A description of how the masking information was generated.

- `replacement_size`:

  The size of replacement mask.

- `seq_segment_size`:

  The size of the masking.

- `seq_start`:

  The start of the masking.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`MaskingInfo$new()`](#method-MaskingInfo-initialize)

- [`MaskingInfo$validate()`](#method-MaskingInfo-validate)

- [`MaskingInfo$to_list()`](#method-MaskingInfo-to_list)

- [`MaskingInfo$to_json_list()`](#method-MaskingInfo-to_json_list)

- [`MaskingInfo$to_json()`](#method-MaskingInfo-to_json)

- [`MaskingInfo$clone()`](#method-MaskingInfo-clone)

------------------------------------------------------------------------

### `MaskingInfo$new()`

Create a new instance.

#### Usage

    MaskingInfo$new(
      masking_generation_description = NULL,
      replacement_size = NA_real_,
      seq_segment_size = NA_real_,
      seq_start = NA_real_,
      extras = list()
    )

#### Arguments

- `masking_generation_description`:

  A description of how the masking information was generated.

- `replacement_size`:

  The size of replacement mask.

- `seq_segment_size`:

  The size of the masking.

- `seq_start`:

  The start of the masking.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `MaskingInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    MaskingInfo$validate()

------------------------------------------------------------------------

### `MaskingInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    MaskingInfo$to_list()

------------------------------------------------------------------------

### `MaskingInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    MaskingInfo$to_json_list()

------------------------------------------------------------------------

### `MaskingInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    MaskingInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `MaskingInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    MaskingInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
