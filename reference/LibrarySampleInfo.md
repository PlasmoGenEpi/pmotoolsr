# LibrarySampleInfo

Information about a specific amplification and sequencing of a specimen.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `alternate_identifiers`: A list of alternative names.

- `experiment_accession`: ERA/SRA experiment accession number for the
  sample if it was submitted.

- `fastqs_loc`: The location (url or filename path) of the fastqs for a
  library run.

- `library_prep_plate_info`: Plate location of where library was
  prepared for sequencing.

- `library_sample_name`: A unique identifier for this
  sequencing/amplification run.

- `panel_id`: The index into the panel_info list.

- `qpcr_parasite_density_info`: Qpcr parasite density measurement for
  this extracted sample.

- `run_accession`: ERA/SRA run accession number for the sample if it was
  submitted.

- `sequencing_info_id`: The index into the sequencing_info list.

- `specimen_id`: The index into the specimen_info list.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `alternate_identifiers`:

  A list of alternative names.

- `experiment_accession`:

  ERA/SRA experiment accession number for the sample if it was
  submitted.

- `fastqs_loc`:

  The location (url or filename path) of the fastqs for a library run.

- `library_prep_plate_info`:

  Plate location of where library was prepared for sequencing.

- `library_sample_name`:

  A unique identifier for this sequencing/amplification run.

- `panel_id`:

  The index into the panel_info list.

- `qpcr_parasite_density_info`:

  Qpcr parasite density measurement for this extracted sample.

- `run_accession`:

  ERA/SRA run accession number for the sample if it was submitted.

- `sequencing_info_id`:

  The index into the sequencing_info list.

- `specimen_id`:

  The index into the specimen_info list.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`LibrarySampleInfo$new()`](#method-LibrarySampleInfo-initialize)

- [`LibrarySampleInfo$validate()`](#method-LibrarySampleInfo-validate)

- [`LibrarySampleInfo$to_list()`](#method-LibrarySampleInfo-to_list)

- [`LibrarySampleInfo$to_json_list()`](#method-LibrarySampleInfo-to_json_list)

- [`LibrarySampleInfo$to_json()`](#method-LibrarySampleInfo-to_json)

- [`LibrarySampleInfo$clone()`](#method-LibrarySampleInfo-clone)

------------------------------------------------------------------------

### `LibrarySampleInfo$new()`

Create a new instance.

#### Usage

    LibrarySampleInfo$new(
      alternate_identifiers = NULL,
      experiment_accession = NULL,
      fastqs_loc = NULL,
      library_prep_plate_info = NULL,
      library_sample_name = NA_character_,
      panel_id = NA_real_,
      qpcr_parasite_density_info = NULL,
      run_accession = NULL,
      sequencing_info_id = NULL,
      specimen_id = NA_real_,
      extras = list()
    )

#### Arguments

- `alternate_identifiers`:

  A list of alternative names.

- `experiment_accession`:

  ERA/SRA experiment accession number for the sample if it was
  submitted.

- `fastqs_loc`:

  The location (url or filename path) of the fastqs for a library run.

- `library_prep_plate_info`:

  Plate location of where library was prepared for sequencing.

- `library_sample_name`:

  A unique identifier for this sequencing/amplification run.

- `panel_id`:

  The index into the panel_info list.

- `qpcr_parasite_density_info`:

  Qpcr parasite density measurement for this extracted sample.

- `run_accession`:

  ERA/SRA run accession number for the sample if it was submitted.

- `sequencing_info_id`:

  The index into the sequencing_info list.

- `specimen_id`:

  The index into the specimen_info list.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `LibrarySampleInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    LibrarySampleInfo$validate()

------------------------------------------------------------------------

### `LibrarySampleInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    LibrarySampleInfo$to_list()

------------------------------------------------------------------------

### `LibrarySampleInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    LibrarySampleInfo$to_json_list()

------------------------------------------------------------------------

### `LibrarySampleInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    LibrarySampleInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `LibrarySampleInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    LibrarySampleInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
