# SequencingInfo

Information on sequencing info.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `library_kit`: Name, version, and applicable cell or cycle numbers for
  the kit used to prepare libraries and load cells or chips for
  sequencing. If possible, include a part number, e.g. MiSeq Reagent Kit
  v3 (150-cycle), MS-102-3001.

- `library_layout`: Specify the configuration of reads, e.g. paired-end,
  single.

- `library_screen`: Describe enrichment, screening, or normalization
  methods applied during amplification or library preparation, e.g. size
  selection 390bp, diluted to 1 ng DNA/sample.

- `library_selection`: How amplification was done (common are PCR=Source
  material was selected by designed primers, RANDOM =Random selection by
  shearing or other method).

- `library_source`: Source of amplification material e.g. was it DNA
  (GENOMIC) or RNA (TRANSCRIPTOMIC) (common names GENOMIC,
  TRANSCRIPTOMIC).

- `library_strategy`: What the nuceloacid sequencing/amplification
  strategy was (common names are AMPLICON, WGS).

- `nucl_acid_amp`: Link to a reference or kit that describes the
  enzymatic amplification of nucleic acids.

- `nucl_acid_amp_date`: The date of the nucleoacid amplification.

- `nucl_acid_ext`: Link to a reference or kit that describes the
  recovery of nucleic acids from the sample.

- `nucl_acid_ext_date`: The date of the nucleoacid extraction.

- `pcr_cond`: The method/conditions for PCR, List PCR cycles used to
  amplify the target.

- `seq_center`: Name of facility where sequencing was performed (lab,
  core facility, or company).

- `seq_date`: The date of sequencing, should be YYYY-MM or YYYY-MM-DD.

- `seq_instrument_model`: The sequencing instrument model used to
  sequence the run, e.g. NextSeq 2000, MinION, Revio.

- `seq_platform`: The sequencing technology used to sequence the run,
  e.g. ILLUMINA, NANOPORE, PACBIO.

- `sequencing_info_name`: A name for a specific sequencing run, e.g.
  batch1.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `library_kit`:

  Name, version, and applicable cell or cycle numbers for the kit used
  to prepare libraries and load cells or chips for sequencing. If
  possible, include a part number, e.g. MiSeq Reagent Kit v3
  (150-cycle), MS-102-3001.

- `library_layout`:

  Specify the configuration of reads, e.g. paired-end, single.

- `library_screen`:

  Describe enrichment, screening, or normalization methods applied
  during amplification or library preparation, e.g. size selection
  390bp, diluted to 1 ng DNA/sample.

- `library_selection`:

  How amplification was done (common are PCR=Source material was
  selected by designed primers, RANDOM =Random selection by shearing or
  other method).

- `library_source`:

  Source of amplification material e.g. was it DNA (GENOMIC) or RNA
  (TRANSCRIPTOMIC) (common names GENOMIC, TRANSCRIPTOMIC).

- `library_strategy`:

  What the nuceloacid sequencing/amplification strategy was (common
  names are AMPLICON, WGS).

- `nucl_acid_amp`:

  Link to a reference or kit that describes the enzymatic amplification
  of nucleic acids.

- `nucl_acid_amp_date`:

  The date of the nucleoacid amplification.

- `nucl_acid_ext`:

  Link to a reference or kit that describes the recovery of nucleic
  acids from the sample.

- `nucl_acid_ext_date`:

  The date of the nucleoacid extraction.

- `pcr_cond`:

  The method/conditions for PCR, List PCR cycles used to amplify the
  target.

- `seq_center`:

  Name of facility where sequencing was performed (lab, core facility,
  or company).

- `seq_date`:

  The date of sequencing, should be YYYY-MM or YYYY-MM-DD.

- `seq_instrument_model`:

  The sequencing instrument model used to sequence the run, e.g. NextSeq
  2000, MinION, Revio.

- `seq_platform`:

  The sequencing technology used to sequence the run, e.g. ILLUMINA,
  NANOPORE, PACBIO.

- `sequencing_info_name`:

  A name for a specific sequencing run, e.g. batch1.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`SequencingInfo$new()`](#method-SequencingInfo-initialize)

- [`SequencingInfo$validate()`](#method-SequencingInfo-validate)

- [`SequencingInfo$to_list()`](#method-SequencingInfo-to_list)

- [`SequencingInfo$to_json_list()`](#method-SequencingInfo-to_json_list)

- [`SequencingInfo$to_json()`](#method-SequencingInfo-to_json)

- [`SequencingInfo$clone()`](#method-SequencingInfo-clone)

------------------------------------------------------------------------

### `SequencingInfo$new()`

Create a new instance.

#### Usage

    SequencingInfo$new(
      library_kit = NULL,
      library_layout = NA_character_,
      library_screen = NULL,
      library_selection = NA_character_,
      library_source = NA_character_,
      library_strategy = NA_character_,
      nucl_acid_amp = NULL,
      nucl_acid_amp_date = NULL,
      nucl_acid_ext = NULL,
      nucl_acid_ext_date = NULL,
      pcr_cond = NULL,
      seq_center = NULL,
      seq_date = NULL,
      seq_instrument_model = NA_character_,
      seq_platform = NA_character_,
      sequencing_info_name = NA_character_,
      extras = list()
    )

#### Arguments

- `library_kit`:

  Name, version, and applicable cell or cycle numbers for the kit used
  to prepare libraries and load cells or chips for sequencing. If
  possible, include a part number, e.g. MiSeq Reagent Kit v3
  (150-cycle), MS-102-3001.

- `library_layout`:

  Specify the configuration of reads, e.g. paired-end, single.

- `library_screen`:

  Describe enrichment, screening, or normalization methods applied
  during amplification or library preparation, e.g. size selection
  390bp, diluted to 1 ng DNA/sample.

- `library_selection`:

  How amplification was done (common are PCR=Source material was
  selected by designed primers, RANDOM =Random selection by shearing or
  other method).

- `library_source`:

  Source of amplification material e.g. was it DNA (GENOMIC) or RNA
  (TRANSCRIPTOMIC) (common names GENOMIC, TRANSCRIPTOMIC).

- `library_strategy`:

  What the nuceloacid sequencing/amplification strategy was (common
  names are AMPLICON, WGS).

- `nucl_acid_amp`:

  Link to a reference or kit that describes the enzymatic amplification
  of nucleic acids.

- `nucl_acid_amp_date`:

  The date of the nucleoacid amplification.

- `nucl_acid_ext`:

  Link to a reference or kit that describes the recovery of nucleic
  acids from the sample.

- `nucl_acid_ext_date`:

  The date of the nucleoacid extraction.

- `pcr_cond`:

  The method/conditions for PCR, List PCR cycles used to amplify the
  target.

- `seq_center`:

  Name of facility where sequencing was performed (lab, core facility,
  or company).

- `seq_date`:

  The date of sequencing, should be YYYY-MM or YYYY-MM-DD.

- `seq_instrument_model`:

  The sequencing instrument model used to sequence the run, e.g. NextSeq
  2000, MinION, Revio.

- `seq_platform`:

  The sequencing technology used to sequence the run, e.g. ILLUMINA,
  NANOPORE, PACBIO.

- `sequencing_info_name`:

  A name for a specific sequencing run, e.g. batch1.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `SequencingInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    SequencingInfo$validate()

------------------------------------------------------------------------

### `SequencingInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    SequencingInfo$to_list()

------------------------------------------------------------------------

### `SequencingInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    SequencingInfo$to_json_list()

------------------------------------------------------------------------

### `SequencingInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    SequencingInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `SequencingInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    SequencingInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
