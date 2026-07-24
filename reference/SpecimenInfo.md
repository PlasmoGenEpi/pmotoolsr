# SpecimenInfo

Information on specimen info.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `alternate_identifiers`: A list of alternative names.

- `blood_meal`: Whether host specimen has had a recent blood meal.

- `collection_country`: The name of country collected in, would be the
  same as admin level 0.

- `collection_date`: The date of the specimen collection, can be YYYY,
  YYYY-MM, or YYYY-MM-DD.

- `drug_usage`: Any drug used by subject and the frequency of usage; can
  include multiple drugs used.

- `env_broad_scale`: The broad environment from which the specimen was
  collected, e.g. highlands, lowlands, mountainous region.

- `env_local_scale`: The local environment from which the specimen was
  collected, e.g. jungle, urban, rural.

- `env_medium`: The environment medium from which the specimen was
  collected from.

- `geo_admin1`: Geographical admin level 1, the secondary large
  demarcation of a nation (nation = admin level 0).

- `geo_admin2`: Geographical admin level 2, the third large demarcation
  of a nation (nation = admin level 0).

- `geo_admin3`: Geographical admin level 3, the third large demarcation
  of a nation (nation = admin level 0).

- `gravid`: Whether host specimen is currently pregnant.

- `gravidity`: The gravidity of the specimen host (number of previous
  pregnancies).

- `has_travel_out_six_month`: Has travelled out from local region in the
  last six months.

- `host_age`: If specimen is from a person, the age in years of the
  person, can be float value so for 3 month old put 0.25.

- `host_sex`: If specimen is collected from a host with a sex, the sex
  listed for that host.

- `host_subject_name`: An identifier for the individual/person/patient a
  specimen was collected from.

- `host_taxon_id`: The NCBI taxonomy number of the host that the
  specimen was collected from.

- `lat_lon`: The latitude and longitude of a specific site.

- `parasite_density_info`: One or more parasite densities in microliters
  for this specimen.

- `project_id`: The index into the project_info list.

- `specimen_accession`: If specimen is deposited in a database, what
  accession is it associated with.

- `specimen_collect_device`: The way the specimen was collected, e.g.
  whole blood, dried blood spot.

- `specimen_comments`: Any additional comments about the specimen.

- `specimen_name`: An identifier for the specimen, should be unique
  within this sample set.

- `specimen_store_loc`: The specimen store site, address or facility
  name.

- `specimen_taxon_id`: The NCBI taxonomy number of the organism(s) in
  the specimen, can list multiple if a mixed sample.

- `specimen_type`: What type of specimen this is, e.g. negative_control,
  positive_control, field_sample.

- `storage_plate_info`: Plate location of where specimen is stored if
  stored in a plate.

- `travel_out_six_month`: Specification of the countries travelled in
  the last six months; can include multiple travels.

- `treatment_status`: If person has been treated with drugs, what was
  the treatment outcome.

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `alternate_identifiers`:

  A list of alternative names.

- `blood_meal`:

  Whether host specimen has had a recent blood meal.

- `collection_country`:

  The name of country collected in, would be the same as admin level 0.

- `collection_date`:

  The date of the specimen collection, can be YYYY, YYYY-MM, or
  YYYY-MM-DD.

- `drug_usage`:

  Any drug used by subject and the frequency of usage; can include
  multiple drugs used.

- `env_broad_scale`:

  The broad environment from which the specimen was collected, e.g.
  highlands, lowlands, mountainous region.

- `env_local_scale`:

  The local environment from which the specimen was collected, e.g.
  jungle, urban, rural.

- `env_medium`:

  The environment medium from which the specimen was collected from.

- `geo_admin1`:

  Geographical admin level 1, the secondary large demarcation of a
  nation (nation = admin level 0).

- `geo_admin2`:

  Geographical admin level 2, the third large demarcation of a nation
  (nation = admin level 0).

- `geo_admin3`:

  Geographical admin level 3, the third large demarcation of a nation
  (nation = admin level 0).

- `gravid`:

  Whether host specimen is currently pregnant.

- `gravidity`:

  The gravidity of the specimen host (number of previous pregnancies).

- `has_travel_out_six_month`:

  Has travelled out from local region in the last six months.

- `host_age`:

  If specimen is from a person, the age in years of the person, can be
  float value so for 3 month old put 0.25.

- `host_sex`:

  If specimen is collected from a host with a sex, the sex listed for
  that host.

- `host_subject_name`:

  An identifier for the individual/person/patient a specimen was
  collected from.

- `host_taxon_id`:

  The NCBI taxonomy number of the host that the specimen was collected
  from.

- `lat_lon`:

  The latitude and longitude of a specific site.

- `parasite_density_info`:

  One or more parasite densities in microliters for this specimen.

- `project_id`:

  The index into the project_info list.

- `specimen_accession`:

  If specimen is deposited in a database, what accession is it
  associated with.

- `specimen_collect_device`:

  The way the specimen was collected, e.g. whole blood, dried blood
  spot.

- `specimen_comments`:

  Any additional comments about the specimen.

- `specimen_name`:

  An identifier for the specimen, should be unique within this sample
  set.

- `specimen_store_loc`:

  The specimen store site, address or facility name.

- `specimen_taxon_id`:

  The NCBI taxonomy number of the organism(s) in the specimen, can list
  multiple if a mixed sample.

- `specimen_type`:

  What type of specimen this is, e.g. negative_control,
  positive_control, field_sample.

- `storage_plate_info`:

  Plate location of where specimen is stored if stored in a plate.

- `travel_out_six_month`:

  Specification of the countries travelled in the last six months; can
  include multiple travels.

- `treatment_status`:

  If person has been treated with drugs, what was the treatment outcome.

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`SpecimenInfo$new()`](#method-SpecimenInfo-initialize)

- [`SpecimenInfo$validate()`](#method-SpecimenInfo-validate)

- [`SpecimenInfo$to_list()`](#method-SpecimenInfo-to_list)

- [`SpecimenInfo$to_json_list()`](#method-SpecimenInfo-to_json_list)

- [`SpecimenInfo$to_json()`](#method-SpecimenInfo-to_json)

- [`SpecimenInfo$clone()`](#method-SpecimenInfo-clone)

------------------------------------------------------------------------

### `SpecimenInfo$new()`

Create a new instance.

#### Usage

    SpecimenInfo$new(
      alternate_identifiers = NULL,
      blood_meal = NULL,
      collection_country = NULL,
      collection_date = NULL,
      drug_usage = NULL,
      env_broad_scale = NULL,
      env_local_scale = NULL,
      env_medium = NULL,
      geo_admin1 = NULL,
      geo_admin2 = NULL,
      geo_admin3 = NULL,
      gravid = NULL,
      gravidity = NULL,
      has_travel_out_six_month = NULL,
      host_age = NULL,
      host_sex = NULL,
      host_subject_name = NULL,
      host_taxon_id = NULL,
      lat_lon = NULL,
      parasite_density_info = NULL,
      project_id = NULL,
      specimen_accession = NULL,
      specimen_collect_device = NULL,
      specimen_comments = NULL,
      specimen_name = NA_character_,
      specimen_store_loc = NULL,
      specimen_taxon_id = NULL,
      specimen_type = NULL,
      storage_plate_info = NULL,
      travel_out_six_month = NULL,
      treatment_status = NULL,
      extras = list()
    )

#### Arguments

- `alternate_identifiers`:

  A list of alternative names.

- `blood_meal`:

  Whether host specimen has had a recent blood meal.

- `collection_country`:

  The name of country collected in, would be the same as admin level 0.

- `collection_date`:

  The date of the specimen collection, can be YYYY, YYYY-MM, or
  YYYY-MM-DD.

- `drug_usage`:

  Any drug used by subject and the frequency of usage; can include
  multiple drugs used.

- `env_broad_scale`:

  The broad environment from which the specimen was collected, e.g.
  highlands, lowlands, mountainous region.

- `env_local_scale`:

  The local environment from which the specimen was collected, e.g.
  jungle, urban, rural.

- `env_medium`:

  The environment medium from which the specimen was collected from.

- `geo_admin1`:

  Geographical admin level 1, the secondary large demarcation of a
  nation (nation = admin level 0).

- `geo_admin2`:

  Geographical admin level 2, the third large demarcation of a nation
  (nation = admin level 0).

- `geo_admin3`:

  Geographical admin level 3, the third large demarcation of a nation
  (nation = admin level 0).

- `gravid`:

  Whether host specimen is currently pregnant.

- `gravidity`:

  The gravidity of the specimen host (number of previous pregnancies).

- `has_travel_out_six_month`:

  Has travelled out from local region in the last six months.

- `host_age`:

  If specimen is from a person, the age in years of the person, can be
  float value so for 3 month old put 0.25.

- `host_sex`:

  If specimen is collected from a host with a sex, the sex listed for
  that host.

- `host_subject_name`:

  An identifier for the individual/person/patient a specimen was
  collected from.

- `host_taxon_id`:

  The NCBI taxonomy number of the host that the specimen was collected
  from.

- `lat_lon`:

  The latitude and longitude of a specific site.

- `parasite_density_info`:

  One or more parasite densities in microliters for this specimen.

- `project_id`:

  The index into the project_info list.

- `specimen_accession`:

  If specimen is deposited in a database, what accession is it
  associated with.

- `specimen_collect_device`:

  The way the specimen was collected, e.g. whole blood, dried blood
  spot.

- `specimen_comments`:

  Any additional comments about the specimen.

- `specimen_name`:

  An identifier for the specimen, should be unique within this sample
  set.

- `specimen_store_loc`:

  The specimen store site, address or facility name.

- `specimen_taxon_id`:

  The NCBI taxonomy number of the organism(s) in the specimen, can list
  multiple if a mixed sample.

- `specimen_type`:

  What type of specimen this is, e.g. negative_control,
  positive_control, field_sample.

- `storage_plate_info`:

  Plate location of where specimen is stored if stored in a plate.

- `travel_out_six_month`:

  Specification of the countries travelled in the last six months; can
  include multiple travels.

- `treatment_status`:

  If person has been treated with drugs, what was the treatment outcome.

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `SpecimenInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    SpecimenInfo$validate()

------------------------------------------------------------------------

### `SpecimenInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    SpecimenInfo$to_list()

------------------------------------------------------------------------

### `SpecimenInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    SpecimenInfo$to_json_list()

------------------------------------------------------------------------

### `SpecimenInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    SpecimenInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `SpecimenInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    SpecimenInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
