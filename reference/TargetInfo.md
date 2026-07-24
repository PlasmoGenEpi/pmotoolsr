# TargetInfo

Information about a specific targeted microhaplotype.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `forward_primer`: The forward primer for this target.

- `gene_name`: An identifier of the gene, if any, is being covered with
  this targeted.

- `insert_location`: The intended genomic location of the insert of the
  amplicon (the location between the end of the forward primer and the
  beginning of the reverse primer).

- `markers_of_interest`: A list of markers of interest that are covered
  by this target.

- `reverse_primer`: The reverse primer for this target.

- `target_attributes`: A list of classification types for this target.

- `target_name`: A name for this target.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `forward_primer`:

  The forward primer for this target.

- `gene_name`:

  An identifier of the gene, if any, is being covered with this
  targeted.

- `insert_location`:

  The intended genomic location of the insert of the amplicon (the
  location between the end of the forward primer and the beginning of
  the reverse primer).

- `markers_of_interest`:

  A list of markers of interest that are covered by this target.

- `reverse_primer`:

  The reverse primer for this target.

- `target_attributes`:

  A list of classification types for this target.

- `target_name`:

  A name for this target.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`TargetInfo$new()`](#method-TargetInfo-initialize)

- [`TargetInfo$validate()`](#method-TargetInfo-validate)

- [`TargetInfo$to_list()`](#method-TargetInfo-to_list)

- [`TargetInfo$to_json_list()`](#method-TargetInfo-to_json_list)

- [`TargetInfo$to_json()`](#method-TargetInfo-to_json)

- [`TargetInfo$clone()`](#method-TargetInfo-clone)

------------------------------------------------------------------------

### `TargetInfo$new()`

Create a new instance.

#### Usage

    TargetInfo$new(
      forward_primer = NULL,
      gene_name = NULL,
      insert_location = NULL,
      markers_of_interest = NULL,
      reverse_primer = NULL,
      target_attributes = NULL,
      target_name = NA_character_,
      extras = list()
    )

#### Arguments

- `forward_primer`:

  The forward primer for this target.

- `gene_name`:

  An identifier of the gene, if any, is being covered with this
  targeted.

- `insert_location`:

  The intended genomic location of the insert of the amplicon (the
  location between the end of the forward primer and the beginning of
  the reverse primer).

- `markers_of_interest`:

  A list of markers of interest that are covered by this target.

- `reverse_primer`:

  The reverse primer for this target.

- `target_attributes`:

  A list of classification types for this target.

- `target_name`:

  A name for this target.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `TargetInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    TargetInfo$validate()

------------------------------------------------------------------------

### `TargetInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    TargetInfo$to_list()

------------------------------------------------------------------------

### `TargetInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    TargetInfo$to_json_list()

------------------------------------------------------------------------

### `TargetInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    TargetInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `TargetInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    TargetInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
