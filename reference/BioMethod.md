# BioMethod

Bioinformatics methodology description with info on program, version,
and arguments different from the default.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `additional_argument`: Any additional arguments that differ from the
  default arguments.

- `program`: Name of the program used for this portion of the pipeline.

- `program_description`: A short description of what this method does.

- `program_url`: A url pointing to code base of a program, e.g. a github
  link.

- `program_version`: The version of program, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `additional_argument`:

  Any additional arguments that differ from the default arguments.

- `program`:

  Name of the program used for this portion of the pipeline.

- `program_description`:

  A short description of what this method does.

- `program_url`:

  A url pointing to code base of a program, e.g. a github link.

- `program_version`:

  The version of program, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`BioMethod$new()`](#method-BioMethod-initialize)

- [`BioMethod$validate()`](#method-BioMethod-validate)

- [`BioMethod$to_list()`](#method-BioMethod-to_list)

- [`BioMethod$to_json_list()`](#method-BioMethod-to_json_list)

- [`BioMethod$to_json()`](#method-BioMethod-to_json)

- [`BioMethod$clone()`](#method-BioMethod-clone)

------------------------------------------------------------------------

### `BioMethod$new()`

Create a new instance.

#### Usage

    BioMethod$new(
      additional_argument = NULL,
      program = NA_character_,
      program_description = NULL,
      program_url = NULL,
      program_version = NA_character_,
      extras = list()
    )

#### Arguments

- `additional_argument`:

  Any additional arguments that differ from the default arguments.

- `program`:

  Name of the program used for this portion of the pipeline.

- `program_description`:

  A short description of what this method does.

- `program_url`:

  A url pointing to code base of a program, e.g. a github link.

- `program_version`:

  The version of program, should be in the format of
  v\[MAJOR\].\[MINOR\].\[PATCH\].

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `BioMethod$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    BioMethod$validate()

------------------------------------------------------------------------

### `BioMethod$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    BioMethod$to_list()

------------------------------------------------------------------------

### `BioMethod$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    BioMethod$to_json_list()

------------------------------------------------------------------------

### `BioMethod$to_json()`

Convert the object to a JSON string.

#### Usage

    BioMethod$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `BioMethod$clone()`

The objects of this class are cloneable with this method.

#### Usage

    BioMethod$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
