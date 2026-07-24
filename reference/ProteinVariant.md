# ProteinVariant

Information on a variant in protein sequence.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `alternative_gene_name`: An alternative gene name.

- `codon_genomic_location`: The position within the genomic sequence of
  the codon.

- `gene_name`: An identifier of the gene, if any, is being covered with
  this targeted.

- `protein_location`: The position within the protein, the chromosome in
  this case would be the transcript name.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `alternative_gene_name`:

  An alternative gene name.

- `codon_genomic_location`:

  The position within the genomic sequence of the codon.

- `gene_name`:

  An identifier of the gene, if any, is being covered with this
  targeted.

- `protein_location`:

  The position within the protein, the chromosome in this case would be
  the transcript name.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`ProteinVariant$new()`](#method-ProteinVariant-initialize)

- [`ProteinVariant$validate()`](#method-ProteinVariant-validate)

- [`ProteinVariant$to_list()`](#method-ProteinVariant-to_list)

- [`ProteinVariant$to_json_list()`](#method-ProteinVariant-to_json_list)

- [`ProteinVariant$to_json()`](#method-ProteinVariant-to_json)

- [`ProteinVariant$clone()`](#method-ProteinVariant-clone)

------------------------------------------------------------------------

### `ProteinVariant$new()`

Create a new instance.

#### Usage

    ProteinVariant$new(
      alternative_gene_name = NULL,
      codon_genomic_location = NULL,
      gene_name = NULL,
      protein_location = NULL,
      extras = list()
    )

#### Arguments

- `alternative_gene_name`:

  An alternative gene name.

- `codon_genomic_location`:

  The position within the genomic sequence of the codon.

- `gene_name`:

  An identifier of the gene, if any, is being covered with this
  targeted.

- `protein_location`:

  The position within the protein, the chromosome in this case would be
  the transcript name.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `ProteinVariant$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    ProteinVariant$validate()

------------------------------------------------------------------------

### `ProteinVariant$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    ProteinVariant$to_list()

------------------------------------------------------------------------

### `ProteinVariant$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    ProteinVariant$to_json_list()

------------------------------------------------------------------------

### `ProteinVariant$to_json()`

Convert the object to a JSON string.

#### Usage

    ProteinVariant$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `ProteinVariant$clone()`

The objects of this class are cloneable with this method.

#### Usage

    ProteinVariant$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
