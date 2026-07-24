# TravelInfo

Information on travel info.

Auto-generated R6 class from JSON Schema.

## Format

An [`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)
generator object.

## Constructor

`new(...)` supports the following arguments.

- `bed_net_usage`: Approximate usage of bed net while traveling, 1 =
  100% nights with bed net, 0 = 0% no bed net usage.

- `geo_admin1`: Geographical admin level 1, the secondary large
  demarcation of a nation (nation = admin level 0).

- `geo_admin2`: Geographical admin level 2, the third large demarcation
  of a nation (nation = admin level 0).

- `geo_admin3`: Geographical admin level 3, the third large demarcation
  of a nation (nation = admin level 0).

- `lat_lon`: The latitude and longitude of a specific site.

- `travel_country`: The name of country, would be the same as admin
  level 0.

- `travel_end_date`: The date of the end of travel, can be approximate,
  should be YYYY-MM or YYYY-MM-DD (preferred).

- `travel_start_date`: The date of the start of travel, can be
  approximate, should be YYYY-MM or YYYY-MM-DD (preferred).

- `extras`: Additional properties not explicitly defined in the schema.

## Methods

See inline method documentation for `initialize()`, `validate()`,
`to_list()`, `to_json_list()`, and `to_json()`.

## Public fields

- `bed_net_usage`:

  Approximate usage of bed net while traveling, 1 = 100% nights with bed
  net, 0 = 0% no bed net usage.

- `geo_admin1`:

  Geographical admin level 1, the secondary large demarcation of a
  nation (nation = admin level 0).

- `geo_admin2`:

  Geographical admin level 2, the third large demarcation of a nation
  (nation = admin level 0).

- `geo_admin3`:

  Geographical admin level 3, the third large demarcation of a nation
  (nation = admin level 0).

- `lat_lon`:

  The latitude and longitude of a specific site.

- `travel_country`:

  The name of country, would be the same as admin level 0.

- `travel_end_date`:

  The date of the end of travel, can be approximate, should be YYYY-MM
  or YYYY-MM-DD (preferred).

- `travel_start_date`:

  The date of the start of travel, can be approximate, should be YYYY-MM
  or YYYY-MM-DD (preferred).

- `extras`:

  Additional properties not explicitly defined in the schema.

## Methods

### Public methods

- [`TravelInfo$new()`](#method-TravelInfo-initialize)

- [`TravelInfo$validate()`](#method-TravelInfo-validate)

- [`TravelInfo$to_list()`](#method-TravelInfo-to_list)

- [`TravelInfo$to_json_list()`](#method-TravelInfo-to_json_list)

- [`TravelInfo$to_json()`](#method-TravelInfo-to_json)

- [`TravelInfo$clone()`](#method-TravelInfo-clone)

------------------------------------------------------------------------

### `TravelInfo$new()`

Create a new instance.

#### Usage

    TravelInfo$new(
      bed_net_usage = NULL,
      geo_admin1 = NULL,
      geo_admin2 = NULL,
      geo_admin3 = NULL,
      lat_lon = NULL,
      travel_country = NA_character_,
      travel_end_date = NA_character_,
      travel_start_date = NA_character_,
      extras = list()
    )

#### Arguments

- `bed_net_usage`:

  Approximate usage of bed net while traveling, 1 = 100% nights with bed
  net, 0 = 0% no bed net usage.

- `geo_admin1`:

  Geographical admin level 1, the secondary large demarcation of a
  nation (nation = admin level 0).

- `geo_admin2`:

  Geographical admin level 2, the third large demarcation of a nation
  (nation = admin level 0).

- `geo_admin3`:

  Geographical admin level 3, the third large demarcation of a nation
  (nation = admin level 0).

- `lat_lon`:

  The latitude and longitude of a specific site.

- `travel_country`:

  The name of country, would be the same as admin level 0.

- `travel_end_date`:

  The date of the end of travel, can be approximate, should be YYYY-MM
  or YYYY-MM-DD (preferred).

- `travel_start_date`:

  The date of the start of travel, can be approximate, should be YYYY-MM
  or YYYY-MM-DD (preferred).

- `extras`:

  Additional properties not explicitly defined in the schema.

------------------------------------------------------------------------

### `TravelInfo$validate()`

Validate the current instance against schema-derived constraints.

#### Usage

    TravelInfo$validate()

------------------------------------------------------------------------

### `TravelInfo$to_list()`

Convert the object to a plain R list using in-memory values.

#### Usage

    TravelInfo$to_list()

------------------------------------------------------------------------

### `TravelInfo$to_json_list()`

Convert the object to a JSON-ready R list.

#### Usage

    TravelInfo$to_json_list()

------------------------------------------------------------------------

### `TravelInfo$to_json()`

Convert the object to a JSON string.

#### Usage

    TravelInfo$to_json(pretty = FALSE, auto_unbox = TRUE, ...)

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

### `TravelInfo$clone()`

The objects of this class are cloneable with this method.

#### Usage

    TravelInfo$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
