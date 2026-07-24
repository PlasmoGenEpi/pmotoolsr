# MicrohaplotypeForTarget

Microhaplotype detected for a specific target.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `mhap_id`: The index for a microhaplotype for a target in the
  representative_microhaplotypes list, e.g.
  representative_microhaplotypes\[mhaps_target_id\]\[mhap_id\].

- `reads`: The read count for this microhaplotype.

- `umis`: The unique molecular identifier (umi) count for this
  microhaplotype.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `mhap_id`:

  The index for a microhaplotype for a target in the
  representative_microhaplotypes list, e.g.
  representative_microhaplotypes\[mhaps_target_id\]\[mhap_id\].

- `reads`:

  The read count for this microhaplotype.

- `umis`:

  The unique molecular identifier (umi) count for this microhaplotype.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`MicrohaplotypeForTarget$new()`](#method-MicrohaplotypeForTarget-initialize)

- [`MicrohaplotypeForTarget$validate()`](#method-MicrohaplotypeForTarget-validate)

- [`MicrohaplotypeForTarget$to_list()`](#method-MicrohaplotypeForTarget-to_list)

- [`MicrohaplotypeForTarget$to_json_list()`](#method-MicrohaplotypeForTarget-to_json_list)

- [`MicrohaplotypeForTarget$to_json()`](#method-MicrohaplotypeForTarget-to_json)

- [`MicrohaplotypeForTarget$clone()`](#method-MicrohaplotypeForTarget-clone)

------------------------------------------------------------------------

### `MicrohaplotypeForTarget$new()`

Create a new instance.

#### Usage

    MicrohaplotypeForTarget$new(
      mhap_id = NA_real_,
      reads = NA_real_,
      umis = NULL,
      extras = list()
    )

#### Arguments

- `mhap_id`:

  The index for a microhaplotype for a target in the
  representative_microhaplotypes list, e.g.
  representative_microhaplotypes\[mhaps_target_id\]\[mhap_id\].

- `reads`:

  The read count for this microhaplotype.

- `umis`:

  The unique molecular identifier (umi) count for this microhaplotype.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `MicrohaplotypeForTarget$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    MicrohaplotypeForTarget$validate()

------------------------------------------------------------------------

### `MicrohaplotypeForTarget$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    MicrohaplotypeForTarget$to_list()

------------------------------------------------------------------------

### `MicrohaplotypeForTarget$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    MicrohaplotypeForTarget$to_json_list()

------------------------------------------------------------------------

### `MicrohaplotypeForTarget$to_json()`

Convert the object to a JSON string.

#### Usage

    MicrohaplotypeForTarget$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `MicrohaplotypeForTarget$clone()`

The objects of this class are cloneable with this method.

#### Usage

    MicrohaplotypeForTarget$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
