# PMO updater utilities
#
# Ported from pmotools-python pmo_builder/pmo_updater.py. Operates on a PMO and
# returns the modified PMO as a raw nested list (1-based ids).

#' @keywords internal
.pmo_is_yyyy_mm_or_yyyy_mm_dd <- function(s) {
  s <- as.character(s)
  if (grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", s)) {
    return(!is.na(as.Date(s, format = "%Y-%m-%d")))
  }
  if (grepl("^[0-9]{4}-[0-9]{2}$", s)) {
    return(!is.na(as.Date(paste0(s, "-01"), format = "%Y-%m-%d")))
  }
  FALSE
}

#' Add travel history to a PMO's specimens
#'
#' Appends one `travel_out_six_month` (TravelInfo) record per row of
#' `traveler_info` to the matching specimen. Column names default to the schema
#' field names, so the produced records are schema-shaped; non-default column
#' names are used verbatim as keys.
#'
#' @param pmo A `PortableMicrohaplotypeObject` or parsed PMO list.
#' @param traveler_info A data.frame of travel records.
#' @param specimen_name_col Column matching specimens in the PMO.
#' @param travel_country_col,travel_start_col,travel_end_col Required travel
#'   columns; the start/end values must be `YYYY-MM` or `YYYY-MM-DD`.
#' @param bed_net_usage_col,geo_admin1_col,geo_admin2_col,geo_admin3_col,lat_lon_col
#'   Optional travel columns.
#' @param replace_current_traveler_info If `TRUE`, clear any existing travel
#'   records on matched specimens before appending.
#' @return The updated PMO as a raw nested list.
#' @examples
#' p <- read_pmo(
#'   system.file("extdata", "example_full_pmo.json.gz", package = "pmotoolsr"))
#' travel <- data.frame(
#'   specimen_name = pmo_get_specimen_names(p)[1],
#'   travel_country = "Kenya", travel_start_date = "2018-01",
#'   travel_end_date = "2018-02")
#' updated <- pmo_update_specimen_with_traveler_info(p, travel)
#' @export
pmo_update_specimen_with_traveler_info <- function(
    pmo, traveler_info, specimen_name_col = "specimen_name",
    travel_country_col = "travel_country",
    travel_start_col = "travel_start_date", travel_end_col = "travel_end_date",
    bed_net_usage_col = NULL, geo_admin1_col = NULL, geo_admin2_col = NULL,
    geo_admin3_col = NULL, lat_lon_col = NULL,
    replace_current_traveler_info = FALSE) {

  p <- .pmo_as_list(pmo)
  required <- c(specimen_name_col, travel_country_col, travel_start_col,
                travel_end_col, bed_net_usage_col, geo_admin1_col,
                geo_admin2_col, geo_admin3_col, lat_lon_col)
  required <- required[!vapply(required, is.null, logical(1))]
  if (!all(required %in% names(traveler_info))) {
    stop("missing traveler_info columns: ", paste(required, collapse = ","),
         " columns in table: ", paste(names(traveler_info), collapse = ","))
  }

  spec_names_pmo <- pmo_get_specimen_names(p)
  spec_names_tab <- unique(as.character(traveler_info[[specimen_name_col]]))
  missing_specs <- setdiff(spec_names_tab, spec_names_pmo)
  if (length(missing_specs) > 0) {
    stop("Provided traveler info for the following specimens but they are ",
         "missing from the PMO: ", paste(sort(missing_specs), collapse = ", "))
  }
  spec_idx <- pmo_index_key_specimen_names(p)

  for (sn in spec_names_tab) {
    idx <- spec_idx[[sn]]
    if (replace_current_traveler_info ||
        is.null(p$specimen_info[[idx]]$travel_out_six_month)) {
      p$specimen_info[[idx]]$travel_out_six_month <- list()
    }
  }

  for (i in seq_len(nrow(traveler_info))) {
    sn <- as.character(traveler_info[[specimen_name_col]][i])
    for (dcol in c(travel_start_col, travel_end_col)) {
      val <- traveler_info[[dcol]][i]
      if (is.na(val)) {
        stop("Missing required date value in column '", dcol,
             "' for specimen '", sn, "'")
      }
      if (!.pmo_is_yyyy_mm_or_yyyy_mm_dd(val)) {
        stop("Invalid date format in '", dcol, "' for specimen '", sn, "': '",
             val, "'. Expected YYYY-MM or YYYY-MM-DD")
      }
    }
    rec <- list()
    for (col in required) {
      if (col == specimen_name_col) next
      v <- traveler_info[[col]][i]
      if (.meta_present(v)) rec[[col]] <- v
    }
    idx <- spec_idx[[sn]]
    n <- length(p$specimen_info[[idx]]$travel_out_six_month)
    p$specimen_info[[idx]]$travel_out_six_month[[n + 1L]] <- rec
  }
  p
}

#' Merge two lists of dicts by a shared key field
#'
#' The first list is the base; the second provides updates applied on top,
#' matched by `key_field`. Both inputs are left unmodified.
#'
#' @param main_list The base list of named lists (source of truth).
#' @param update_list The list of named lists whose values are merged in.
#' @param key_field The field used to match records across the two lists.
#' @param replace If `TRUE`, update values overwrite existing fields; if `FALSE`
#'   a conflicting field raises an error.
#' @param ignore_fields Optional field names never copied from `update_list`.
#' @return A new list of merged named lists, in `main_list` order.
#' @examples
#' main <- list(list(name = "a", x = 1), list(name = "b", x = 2))
#' upd <- list(list(name = "a", y = 10))
#' pmo_merge_dicts_by_key(main, upd, "name")
#' @export
pmo_merge_dicts_by_key <- function(main_list, update_list, key_field,
                                   replace = FALSE, ignore_fields = NULL) {
  ignore_fields <- if (is.null(ignore_fields)) character(0) else ignore_fields

  check_missing_key <- function(lst, label) {
    bad <- which(vapply(lst, function(d) is.null(d[[key_field]]), logical(1)))
    if (length(bad) > 0) {
      stop(label, " is missing '", key_field, "' at index(es): ",
           paste(bad, collapse = ", "))
    }
  }
  check_missing_key(main_list, "main_list")
  check_missing_key(update_list, "update_list")

  check_duplicates <- function(lst, label) {
    keys <- vapply(lst, function(d) as.character(d[[key_field]]), character(1))
    dups <- unique(keys[duplicated(keys)])
    if (length(dups) > 0) {
      stop(label, " contains duplicate '", key_field, "' values: ",
           paste(sort(dups), collapse = ", "))
    }
  }
  check_duplicates(main_list, "main_list")
  check_duplicates(update_list, "update_list")

  main_keys <- vapply(main_list, function(d) as.character(d[[key_field]]),
                      character(1))
  update_keys <- vapply(update_list, function(d) as.character(d[[key_field]]),
                        character(1))
  main_map <- stats::setNames(main_list, main_keys)
  update_map <- stats::setNames(update_list, update_keys)

  extra <- setdiff(update_keys, main_keys)
  if (length(extra) > 0) {
    stop("update_list contains '", key_field, "' values not found in ",
         "main_list: ", paste(sort(extra), collapse = ", "))
  }
  missing_from_update <- setdiff(main_keys, update_keys)
  if (length(missing_from_update) > 0) {
    warning("The following '", key_field, "' values are in main_list but not ",
            "in update_list (skipping): ",
            paste(sort(missing_from_update), collapse = ", "))
  }

  for (key in update_keys) {
    main_dict <- main_map[[key]]
    update_dict <- update_map[[key]]
    for (field in names(update_dict)) {
      if (field == key_field || field %in% ignore_fields) next
      if (field %in% names(main_dict) && !replace) {
        stop("Field '", field, "' already exists in record '", key_field, "=",
             key, "' and replace=FALSE.")
      }
      main_dict[[field]] <- update_dict[[field]]
    }
    main_map[[key]] <- main_dict
  }
  unname(main_map)
}
