# GenomeInfo

Information on a genome.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `chromosomes`: A list of the chromosomes/contigs found within this
  genome.

- `genome_version`: The genome version.

- `gff_url`: A link to the where this genome's annotation file could be
  downloaded.

- `name`: Name of the genome.

- `taxon_id`: The NCBI taxonomy number, can be a list of values if it's
  a genome file that has been created by combining gnomes from different
  species.

- `url`: A link to the where this genome file could be downloaded.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `chromosomes`:

  A list of the chromosomes/contigs found within this genome.

- `genome_version`:

  The genome version.

- `gff_url`:

  A link to the where this genome's annotation file could be downloaded.

- `name`:

  Name of the genome.

- `taxon_id`:

  The NCBI taxonomy number, can be a list of values if it's a genome
  file that has been created by combining gnomes from different species.

- `url`:

  A link to the where this genome file could be downloaded.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`GenomeInfo$new()`](#method-GenomeInfo-initialize)

- [`GenomeInfo$validate()`](#method-GenomeInfo-validate)

- [`GenomeInfo$to_list()`](#method-GenomeInfo-to_list)

- [`GenomeInfo$to_json_list()`](#method-GenomeInfo-to_json_list)

- [`GenomeInfo$to_json()`](#method-GenomeInfo-to_json)

- [`GenomeInfo$clone()`](#method-GenomeInfo-clone)

------------------------------------------------------------------------

### `GenomeInfo$new()`

Create a new instance.

#### Usage

    GenomeInfo$new(
      chromosomes = NULL,
      genome_version = NA_character_,
      gff_url = NULL,
      name = NA_character_,
      taxon_id = numeric(),
      url = NA_character_,
      extras = list()
    )

#### Arguments

- `chromosomes`:

  A list of the chromosomes/contigs found within this genome.

- `genome_version`:

  The genome version.

- `gff_url`:

  A link to the where this genome's annotation file could be downloaded.

- `name`:

  Name of the genome.

- `taxon_id`:

  The NCBI taxonomy number, can be a list of values if it's a genome
  file that has been created by combining gnomes from different species.

- `url`:

  A link to the where this genome file could be downloaded.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `GenomeInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    GenomeInfo$validate()

------------------------------------------------------------------------

### `GenomeInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    GenomeInfo$to_list()

------------------------------------------------------------------------

### `GenomeInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    GenomeInfo$to_json_list()

------------------------------------------------------------------------

### `GenomeInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    GenomeInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `GenomeInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    GenomeInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
