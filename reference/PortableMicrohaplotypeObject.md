# PortableMicrohaplotypeObject

Information on final microhaplotype results from a targeted amplicon
analysis with associated meta data.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `bioinformatics_methods_info`: The bioinformatics pipeline/methods
  used to generated the microhaplotype analysis for this project.

- `bioinformatics_run_info`: The runtime info for the bioinformatics
  pipeline used to generated the microhaplotypes analysis for this
  project.

- `detected_microhaplotypes`: The microhaplotypes detected in this
  projects.

- `library_sample_info`: A list of libraries of all the seq/amp of the
  specimens within this PMO file.

- `panel_info`: A list of info on the panels.

- `pmo_header`: The PMO information for this file including version etc.

- `project_info`: The information about the projects stored in this PMO.

- `read_counts_by_stage`: The read counts for library_samples for
  different stages of the pipeline.

- `representative_microhaplotypes`: A list of the information on the
  representative microhaplotypes.

- `sequencing_info`: A list of sequencing infos for this PMO file.

- `specimen_info`: A list of all the specimens within this PMO file.

- `target_info`: A list of info on the targets.

- `targeted_genomes`: A list of genomes that any genomic location
  information refers to.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `bioinformatics_methods_info`:

  The bioinformatics pipeline/methods used to generated the
  microhaplotype analysis for this project.

- `bioinformatics_run_info`:

  The runtime info for the bioinformatics pipeline used to generated the
  microhaplotypes analysis for this project.

- `detected_microhaplotypes`:

  The microhaplotypes detected in this projects.

- `library_sample_info`:

  A list of libraries of all the seq/amp of the specimens within this
  PMO file.

- `panel_info`:

  A list of info on the panels.

- `pmo_header`:

  The PMO information for this file including version etc.

- `project_info`:

  The information about the projects stored in this PMO.

- `read_counts_by_stage`:

  The read counts for library_samples for different stages of the
  pipeline.

- `representative_microhaplotypes`:

  A list of the information on the representative microhaplotypes.

- `sequencing_info`:

  A list of sequencing infos for this PMO file.

- `specimen_info`:

  A list of all the specimens within this PMO file.

- `target_info`:

  A list of info on the targets.

- `targeted_genomes`:

  A list of genomes that any genomic location information refers to.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`PortableMicrohaplotypeObject$new()`](#method-PortableMicrohaplotypeObject-initialize)

- [`PortableMicrohaplotypeObject$validate()`](#method-PortableMicrohaplotypeObject-validate)

- [`PortableMicrohaplotypeObject$to_list()`](#method-PortableMicrohaplotypeObject-to_list)

- [`PortableMicrohaplotypeObject$to_json_list()`](#method-PortableMicrohaplotypeObject-to_json_list)

- [`PortableMicrohaplotypeObject$to_json()`](#method-PortableMicrohaplotypeObject-to_json)

- [`PortableMicrohaplotypeObject$to_file()`](#method-PortableMicrohaplotypeObject-to_file)

- [`PortableMicrohaplotypeObject$clone()`](#method-PortableMicrohaplotypeObject-clone)

------------------------------------------------------------------------

### `PortableMicrohaplotypeObject$new()`

Create a new instance.

#### Usage

    PortableMicrohaplotypeObject$new(
      bioinformatics_methods_info = NULL,
      bioinformatics_run_info = NULL,
      detected_microhaplotypes = list(),
      library_sample_info = list(),
      panel_info = list(),
      pmo_header = NULL,
      project_info = NULL,
      read_counts_by_stage = NULL,
      representative_microhaplotypes = NULL,
      sequencing_info = NULL,
      specimen_info = list(),
      target_info = list(),
      targeted_genomes = NULL,
      extras = list()
    )

#### Arguments

- `bioinformatics_methods_info`:

  The bioinformatics pipeline/methods used to generated the
  microhaplotype analysis for this project.

- `bioinformatics_run_info`:

  The runtime info for the bioinformatics pipeline used to generated the
  microhaplotypes analysis for this project.

- `detected_microhaplotypes`:

  The microhaplotypes detected in this projects.

- `library_sample_info`:

  A list of libraries of all the seq/amp of the specimens within this
  PMO file.

- `panel_info`:

  A list of info on the panels.

- `pmo_header`:

  The PMO information for this file including version etc.

- `project_info`:

  The information about the projects stored in this PMO.

- `read_counts_by_stage`:

  The read counts for library_samples for different stages of the
  pipeline.

- `representative_microhaplotypes`:

  A list of the information on the representative microhaplotypes.

- `sequencing_info`:

  A list of sequencing infos for this PMO file.

- `specimen_info`:

  A list of all the specimens within this PMO file.

- `target_info`:

  A list of info on the targets.

- `targeted_genomes`:

  A list of genomes that any genomic location information refers to.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `PortableMicrohaplotypeObject$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    PortableMicrohaplotypeObject$validate()

------------------------------------------------------------------------

### `PortableMicrohaplotypeObject$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    PortableMicrohaplotypeObject$to_list()

------------------------------------------------------------------------

### `PortableMicrohaplotypeObject$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    PortableMicrohaplotypeObject$to_json_list()

------------------------------------------------------------------------

### `PortableMicrohaplotypeObject$to_json()`

Convert the object to a JSON string.

#### Usage

    PortableMicrohaplotypeObject$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `PortableMicrohaplotypeObject$to_file()`

Write this object to a JSON file (compression inferred from the file
extension).

#### Usage

    PortableMicrohaplotypeObject$to_file(
      path,
      pretty = FALSE,
      auto_unbox = TRUE,
      validate = TRUE,
      ...
    )

#### Arguments

- `path`:

  Output file path.

- `pretty`:

  Logical; pretty-print the JSON.

- `auto_unbox`:

  Logical; passed to
  [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html).

- `validate`:

  Logical; if `TRUE`, validate before writing.

- `...`:

  Additional arguments passed through to
  [`write_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo.md).

------------------------------------------------------------------------

### `PortableMicrohaplotypeObject$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PortableMicrohaplotypeObject$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
pmo <- read_pmo(
  system.file('extdata', 'example_pmo.json.gz', package = 'pmotoolsr'))
length(pmo$specimen_info)
#> [1] 129
```
