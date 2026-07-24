# RepresentativeMicrohaplotype

The representative sequence for a microhaplotype.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `alt_annotations`: A list of additional annotations associated with
  this microhaplotype, e.g. wildtype.

- `associated_protein_variants`: A list of protein variants for this
  haplotype, e.g. amino acid changes/INDELS.

- `associated_seq_variants`: A list of sequence variants for this
  haplotype, e.g. SNPS, indels.

- `masking`: Masking info for the sequence.

- `microhaplotype_name`: An optional name for this microhaplotype.

- `pseudocigar`: The pseudocigar of the haplotype.

- `quality`: The ASCII fastq per base quality score for this sequence,
  this is optional, must be same length as the sequence.

- `seq`: The sequence.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `alt_annotations`:

  A list of additional annotations associated with this microhaplotype,
  e.g. wildtype.

- `associated_protein_variants`:

  A list of protein variants for this haplotype, e.g. amino acid
  changes/INDELS.

- `associated_seq_variants`:

  A list of sequence variants for this haplotype, e.g. SNPS, indels.

- `masking`:

  Masking info for the sequence.

- `microhaplotype_name`:

  An optional name for this microhaplotype.

- `pseudocigar`:

  The pseudocigar of the haplotype.

- `quality`:

  The ASCII fastq per base quality score for this sequence, this is
  optional, must be same length as the sequence.

- `seq`:

  The sequence.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`RepresentativeMicrohaplotype$new()`](#method-RepresentativeMicrohaplotype-initialize)

- [`RepresentativeMicrohaplotype$validate()`](#method-RepresentativeMicrohaplotype-validate)

- [`RepresentativeMicrohaplotype$to_list()`](#method-RepresentativeMicrohaplotype-to_list)

- [`RepresentativeMicrohaplotype$to_json_list()`](#method-RepresentativeMicrohaplotype-to_json_list)

- [`RepresentativeMicrohaplotype$to_json()`](#method-RepresentativeMicrohaplotype-to_json)

- [`RepresentativeMicrohaplotype$clone()`](#method-RepresentativeMicrohaplotype-clone)

------------------------------------------------------------------------

### `RepresentativeMicrohaplotype$new()`

Create a new instance.

#### Usage

    RepresentativeMicrohaplotype$new(
      alt_annotations = NULL,
      associated_protein_variants = NULL,
      associated_seq_variants = NULL,
      masking = NULL,
      microhaplotype_name = NULL,
      pseudocigar = NULL,
      quality = NULL,
      seq = NA_character_,
      extras = list()
    )

#### Arguments

- `alt_annotations`:

  A list of additional annotations associated with this microhaplotype,
  e.g. wildtype.

- `associated_protein_variants`:

  A list of protein variants for this haplotype, e.g. amino acid
  changes/INDELS.

- `associated_seq_variants`:

  A list of sequence variants for this haplotype, e.g. SNPS, indels.

- `masking`:

  Masking info for the sequence.

- `microhaplotype_name`:

  An optional name for this microhaplotype.

- `pseudocigar`:

  The pseudocigar of the haplotype.

- `quality`:

  The ASCII fastq per base quality score for this sequence, this is
  optional, must be same length as the sequence.

- `seq`:

  The sequence.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `RepresentativeMicrohaplotype$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    RepresentativeMicrohaplotype$validate()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotype$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    RepresentativeMicrohaplotype$to_list()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotype$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    RepresentativeMicrohaplotype$to_json_list()

------------------------------------------------------------------------

### `RepresentativeMicrohaplotype$to_json()`

Convert the object to a JSON string.

#### Usage

    RepresentativeMicrohaplotype$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `RepresentativeMicrohaplotype$clone()`

The objects of this class are cloneable with this method.

#### Usage

    RepresentativeMicrohaplotype$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
