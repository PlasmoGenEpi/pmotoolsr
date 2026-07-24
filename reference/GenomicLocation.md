# GenomicLocation

Information on the genomic location of specific sequence.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `alt_seq`: A possible alternative sequence of this genomic location.

- `chrom`: The chromosome name.

- `end`: The end of the location, 0-based positioning.

- `genome_id`: The index to the genome in the targeted_genomes list that
  this location refers to.

- `ref_seq`: The reference sequence of this genomic location.

- `start`: The start of the location, 0-based positioning.

- `strand`: Which strand the location is, either + for plus strand or -
  for negative strand.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `alt_seq`:

  A possible alternative sequence of this genomic location.

- `chrom`:

  The chromosome name.

- `end`:

  The end of the location, 0-based positioning.

- `genome_id`:

  The index to the genome in the targeted_genomes list that this
  location refers to.

- `ref_seq`:

  The reference sequence of this genomic location.

- `start`:

  The start of the location, 0-based positioning.

- `strand`:

  Which strand the location is, either + for plus strand or - for
  negative strand.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`GenomicLocation$new()`](#method-GenomicLocation-initialize)

- [`GenomicLocation$validate()`](#method-GenomicLocation-validate)

- [`GenomicLocation$to_list()`](#method-GenomicLocation-to_list)

- [`GenomicLocation$to_json_list()`](#method-GenomicLocation-to_json_list)

- [`GenomicLocation$to_json()`](#method-GenomicLocation-to_json)

- [`GenomicLocation$clone()`](#method-GenomicLocation-clone)

------------------------------------------------------------------------

### `GenomicLocation$new()`

Create a new instance.

#### Usage

    GenomicLocation$new(
      alt_seq = NULL,
      chrom = NA_character_,
      end = NA_real_,
      genome_id = NA_real_,
      ref_seq = NULL,
      start = NA_real_,
      strand = NULL,
      extras = list()
    )

#### Arguments

- `alt_seq`:

  A possible alternative sequence of this genomic location.

- `chrom`:

  The chromosome name.

- `end`:

  The end of the location, 0-based positioning.

- `genome_id`:

  The index to the genome in the targeted_genomes list that this
  location refers to.

- `ref_seq`:

  The reference sequence of this genomic location.

- `start`:

  The start of the location, 0-based positioning.

- `strand`:

  Which strand the location is, either + for plus strand or - for
  negative strand.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `GenomicLocation$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    GenomicLocation$validate()

------------------------------------------------------------------------

### `GenomicLocation$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    GenomicLocation$to_list()

------------------------------------------------------------------------

### `GenomicLocation$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    GenomicLocation$to_json_list()

------------------------------------------------------------------------

### `GenomicLocation$to_json()`

Convert the object to a JSON string.

#### Usage

    GenomicLocation$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `GenomicLocation$clone()`

The objects of this class are cloneable with this method.

#### Usage

    GenomicLocation$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
