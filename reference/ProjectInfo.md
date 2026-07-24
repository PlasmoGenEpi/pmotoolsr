# ProjectInfo

Information on a project underwhich a collection of specimens belong to.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `BioProject_accession`: An SRA bioproject accession e.g. PRJNA33823.

- `project_collector_chief_scientist`: Can be collection of names
  separated by a semicolon if multiple people involved or can just be
  the name of the primary person managing the specimen.

- `project_contributors`: A list of collaborators who contributed to
  this project.

- `project_description`: A short description of the project.

- `project_name`: A name for the project, should be unique if multiple
  projects listed.

- `project_type`: The type of project conducted, e.g. TES vs
  surveillance vs transmission.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `BioProject_accession`:

  An SRA bioproject accession e.g. PRJNA33823.

- `project_collector_chief_scientist`:

  Can be collection of names separated by a semicolon if multiple people
  involved or can just be the name of the primary person managing the
  specimen.

- `project_contributors`:

  A list of collaborators who contributed to this project.

- `project_description`:

  A short description of the project.

- `project_name`:

  A name for the project, should be unique if multiple projects listed.

- `project_type`:

  The type of project conducted, e.g. TES vs surveillance vs
  transmission.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ProjectInfo$new()`](#method-ProjectInfo-initialize)

- [`ProjectInfo$validate()`](#method-ProjectInfo-validate)

- [`ProjectInfo$to_list()`](#method-ProjectInfo-to_list)

- [`ProjectInfo$to_json_list()`](#method-ProjectInfo-to_json_list)

- [`ProjectInfo$to_json()`](#method-ProjectInfo-to_json)

- [`ProjectInfo$clone()`](#method-ProjectInfo-clone)

------------------------------------------------------------------------

### `ProjectInfo$new()`

Create a new instance.

#### Usage

    ProjectInfo$new(
      BioProject_accession = NULL,
      project_collector_chief_scientist = NULL,
      project_contributors = NULL,
      project_description = NA_character_,
      project_name = NA_character_,
      project_type = NULL,
      extras = list()
    )

#### Arguments

- `BioProject_accession`:

  An SRA bioproject accession e.g. PRJNA33823.

- `project_collector_chief_scientist`:

  Can be collection of names separated by a semicolon if multiple people
  involved or can just be the name of the primary person managing the
  specimen.

- `project_contributors`:

  A list of collaborators who contributed to this project.

- `project_description`:

  A short description of the project.

- `project_name`:

  A name for the project, should be unique if multiple projects listed.

- `project_type`:

  The type of project conducted, e.g. TES vs surveillance vs
  transmission.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ProjectInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ProjectInfo$validate()

------------------------------------------------------------------------

### `ProjectInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ProjectInfo$to_list()

------------------------------------------------------------------------

### `ProjectInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ProjectInfo$to_json_list()

------------------------------------------------------------------------

### `ProjectInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    ProjectInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `ProjectInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ProjectInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
