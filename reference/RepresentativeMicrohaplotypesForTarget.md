# RepresentativeMicrohaplotypesForTarget

A list of the representative sequence for the microhaplotypes for a
target.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `mhap_location`: A genomic location that was analyzed for this target
  info, this allows listing location that may be different from the full
  target location (e.g 1 trimmed off the full length).

- `microhaplotypes`: A list of all the microhaplotypes for a target.

- `target_id`: The index into the target_info list.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `mhap_location`:

  A genomic location that was analyzed for this target info, this allows
  listing location that may be different from the full target location
  (e.g 1 trimmed off the full length).

- `microhaplotypes`:

  A list of all the microhaplotypes for a target.

- `target_id`:

  The index into the target_info list.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`RepresentativeMicrohaplotypesForTarget$new()`](#method-RepresentativeMicrohaplotypesForTarget-initialize)

- [`RepresentativeMicrohaplotypesForTarget$validate()`](#method-RepresentativeMicrohaplotypesForTarget-validate)

- [`RepresentativeMicrohaplotypesForTarget$to_list()`](#method-RepresentativeMicrohaplotypesForTarget-to_list)

- [`RepresentativeMicrohaplotypesForTarget$to_json_list()`](#method-RepresentativeMicrohaplotypesForTarget-to_json_list)

- [`RepresentativeMicrohaplotypesForTarget$to_json()`](#method-RepresentativeMicrohaplotypesForTarget-to_json)

- [`RepresentativeMicrohaplotypesForTarget$clone()`](#method-RepresentativeMicrohaplotypesForTarget-clone)

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypesForTarget$new()`

Create a new instance.

#### Usage

    RepresentativeMicrohaplotypesForTarget$new(
      mhap_location = NULL,
      microhaplotypes = list(),
      target_id = NA_real_,
      extras = list()
    )

#### Arguments

- `mhap_location`:

  A genomic location that was analyzed for this target info, this allows
  listing location that may be different from the full target location
  (e.g 1 trimmed off the full length).

- `microhaplotypes`:

  A list of all the microhaplotypes for a target.

- `target_id`:

  The index into the target_info list.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypesForTarget$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    RepresentativeMicrohaplotypesForTarget$validate()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypesForTarget$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    RepresentativeMicrohaplotypesForTarget$to_list()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypesForTarget$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    RepresentativeMicrohaplotypesForTarget$to_json_list()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotypesForTarget$to_json()`

Convert the object to a JSON string.

#### Usage

    RepresentativeMicrohaplotypesForTarget$to_json(
      pretty = FALSE,
      auto_unbox = TRUE,
      ...
    )

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

### `RepresentativeMicrohaplotypesForTarget$clone()`

The objects of this class are cloneable with this method.

#### Usage

    RepresentativeMicrohaplotypesForTarget$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
