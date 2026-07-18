# PMO builder: specimen / library-sample metadata tables -> PMO structures
#
# Ported from pmotools-python pmo_builder/metatable_to_pmo.py. Produces
# NAME-based intermediates (specimen_name / panel_name / sequencing_info_name
# instead of ids); pmo_merge_to_pmo() replaces the names with indices.
#
# Library plate info is matched to rows by library_sample_name, and library qPCR
# density is written under the schema field "qpcr_parasite_density_info".

#' @keywords internal
.meta_present <- function(v) {
  length(v) == 1 && !is.null(v) && !is.na(v) && !(is.character(v) && v == "")
}

#' @keywords internal
.meta_check_unique_columns <- function(columns) {
  cols <- unlist(columns[!vapply(columns, is.null, logical(1))])
  if (length(cols) != length(unique(cols))) {
    stop("Selected columns must be unique.")
  }
}

#' @keywords internal
.meta_check_columns_exist <- function(df, columns) {
  missing <- setdiff(unlist(columns), names(df))
  if (length(missing) > 0) {
    stop("The following columns are not in the data.frame: ",
         paste(missing, collapse = ", "))
  }
}

#' @keywords internal
.meta_check_null_values <- function(df, columns) {
  bad <- columns[vapply(columns, function(c) any(is.na(df[[c]])), logical(1))]
  if (length(bad) > 0) {
    stop("The following columns contain null values: ",
         paste(bad, collapse = ", "))
  }
}

#' @keywords internal
.meta_listify <- function(v, delim) {
  if (is.null(v)) return(v)
  if (length(v) > 1) return(v)
  if (is.character(v)) return(strsplit(v, delim, fixed = TRUE)[[1]])
  v
}

#' Build name->field records from a metadata table
#' @keywords internal
.meta_build_records <- function(wdf, fields, required_fields) {
  recs <- list()
  for (i in seq_len(nrow(wdf))) {
    rec <- list()
    for (field in fields) {
      v <- wdf[[field]][i]
      if (field %in% required_fields || .meta_present(v)) rec[[field]] <- v
    }
    recs[[i]] <- rec
  }
  recs
}

#' @keywords internal
.meta_parse_plate_position <- function(pos) {
  pos <- as.character(pos)
  m <- regmatches(pos, regexec("^([A-Ha-h])0*([1-9]|1[0-2])$", pos))
  rows <- character(length(pos))
  cols <- integer(length(pos))
  for (i in seq_along(pos)) {
    g <- m[[i]]
    if (length(g) != 3) {
      stop("Values in the plate position column must start with a single ",
           "letter A-H/a-h followed by a number 1-12.")
    }
    rows[i] <- toupper(g[2])
    cols[i] <- as.integer(g[3])
  }
  list(row = rows, col = cols)
}

#' @keywords internal
.meta_add_plate_info <- function(meta, wdf, match_col, plate_name_col,
                                 plate_row_col, plate_col_col,
                                 plate_position_col, entry_name) {
  if (is.null(plate_name_col) && is.null(plate_row_col) &&
      is.null(plate_col_col) && is.null(plate_position_col)) {
    return(meta)
  }
  if (xor(is.null(plate_row_col), is.null(plate_col_col))) {
    stop("If either plate row or column is set, then both must be.")
  }
  if (!is.null(plate_position_col)) {
    if (!is.null(plate_col_col)) {
      stop("Plate position can be specified using either row and col, or ",
           "position, but not both.")
    }
    parsed <- .meta_parse_plate_position(wdf[[plate_position_col]])
    wdf[["plate_row"]] <- parsed$row
    wdf[["plate_col"]] <- parsed$col
    plate_row_col <- "plate_row"
    plate_col_col <- "plate_col"
  }
  for (k in seq_along(meta)) {
    idx <- which(as.character(wdf[[match_col]]) ==
                   as.character(meta[[k]][[match_col]]))[1]
    plate_info <- list()
    if (!is.null(plate_name_col) && .meta_present(wdf[[plate_name_col]][idx])) {
      plate_info$plate_name <- wdf[[plate_name_col]][idx]
    }
    if (!is.null(plate_row_col) && .meta_present(wdf[[plate_row_col]][idx])) {
      plate_info$plate_row <- toupper(as.character(wdf[[plate_row_col]][idx]))
    }
    if (!is.null(plate_col_col) && .meta_present(wdf[[plate_col_col]][idx])) {
      plate_info$plate_col <- as.integer(wdf[[plate_col_col]][idx])
    }
    if (length(plate_info) > 0) meta[[k]][[entry_name]] <- plate_info
  }
  meta
}

#' @keywords internal
.meta_density_pairs <- function(density_col, method_col) {
  if (is.null(density_col) && is.null(method_col)) return(list())
  if (!is.null(density_col) && length(density_col) > 1) {
    if (is.null(method_col)) {
      return(lapply(density_col, function(d) list(density = d, method = NULL)))
    }
    if (length(method_col) > 1) {
      if (length(density_col) != length(method_col)) {
        stop("If both parasite_density_col and parasite_density_method_col are ",
             "lists, they must be the same length.")
      }
      return(Map(function(d, m) list(density = d, method = m),
                 density_col, method_col))
    }
    stop("If parasite_density_col is a list, parasite_density_method_col must ",
         "be a list or NULL.")
  }
  if (!is.null(density_col) && length(density_col) == 1) {
    if (is.null(method_col)) return(list(list(density = density_col, method = NULL)))
    if (length(method_col) == 1) {
      return(list(list(density = density_col, method = method_col)))
    }
    stop("If parasite_density_col is a string, parasite_density_method_col ",
         "must be a string or NULL.")
  }
  # density_col NULL but method_col set
  stop("parasite_density_method_col is set but parasite_density_col is NULL.")
}

#' @keywords internal
.meta_add_parasite_density_info <- function(meta, wdf, match_col, density_col,
                                            method_col, entry_name) {
  pairs <- .meta_density_pairs(density_col, method_col)
  if (length(pairs) == 0) return(meta)
  for (k in seq_along(meta)) {
    idx <- which(as.character(wdf[[match_col]]) ==
                   as.character(meta[[k]][[match_col]]))[1]
    infos <- list()
    for (p in pairs) {
      dv <- wdf[[p$density]][idx]
      if (.meta_present(dv)) {
        info <- list(parasite_density = dv)
        if (!is.null(p$method) && .meta_present(wdf[[p$method]][idx])) {
          info$parasite_density_method <- wdf[[p$method]][idx]
        }
        infos[[length(infos) + 1L]] <- info
      }
    }
    if (length(infos) > 0) meta[[k]][[entry_name]] <- infos
  }
  meta
}

#' @keywords internal
.meta_rename <- function(contents, mapping) {
  wdf <- contents
  hit <- match(names(mapping), names(wdf))
  names(wdf)[hit] <- unname(unlist(mapping))
  wdf
}

#' Convert a library-sample metadata table into PMO library_sample_info
#'
#' @param contents A data.frame, one row per library sample.
#' @param library_sample_name_col,specimen_name_col,panel_name_col Column names
#'   for the key fields.
#' @param sequencing_info_name_col,alternate_identifiers_col,experiment_accession_col,fastqs_loc_col,run_accession_col
#'   Optional column names.
#' @param library_prep_plate_name_col,library_prep_plate_col_col,library_prep_plate_row_col,library_prep_plate_position_col
#'   Optional plate-location columns.
#' @param parasite_density_col,parasite_density_method_col Optional qPCR density
#'   column(s).
#' @param additional_library_sample_info_cols Extra columns to copy through.
#' @param list_values_library_values,list_values_library_values_delimiter
#'   Fields that may hold delimited lists, and the delimiter.
#' @return A list of library-sample records (name-based).
#' @examples
#' df <- data.frame(library_sample_name = c("l1", "l2"),
#'                  specimen_name = c("sp1", "sp2"),
#'                  panel_name = c("demo_panel", "demo_panel"))
#' pmo_library_sample_info_table_to_pmo(df)
#' @export
pmo_library_sample_info_table_to_pmo <- function(
    contents, library_sample_name_col = "library_sample_name",
    specimen_name_col = "specimen_name", panel_name_col = "panel_name",
    sequencing_info_name_col = NULL, alternate_identifiers_col = NULL,
    experiment_accession_col = NULL, fastqs_loc_col = NULL,
    library_prep_plate_name_col = NULL, library_prep_plate_col_col = NULL,
    library_prep_plate_row_col = NULL, library_prep_plate_position_col = NULL,
    parasite_density_col = NULL, parasite_density_method_col = NULL,
    run_accession_col = NULL, additional_library_sample_info_cols = NULL,
    list_values_library_values = c("alternate_identifiers"),
    list_values_library_values_delimiter = ",") {

  if (!is.data.frame(contents)) stop("contents must be a data.frame")

  mapping <- stats::setNames("library_sample_name", library_sample_name_col)
  opt <- list(specimen_name = specimen_name_col, panel_name = panel_name_col,
              sequencing_info_name = sequencing_info_name_col,
              alternate_identifiers = alternate_identifiers_col,
              experiment_accession = experiment_accession_col,
              fastqs_loc = fastqs_loc_col, run_accession = run_accession_col)
  for (field in names(opt)) {
    if (!is.null(opt[[field]])) mapping[opt[[field]]] <- field
  }
  for (col in additional_library_sample_info_cols) mapping[col] <- col

  .meta_check_unique_columns(list(
    library_sample_name_col, sequencing_info_name_col, specimen_name_col,
    panel_name_col, alternate_identifiers_col, experiment_accession_col,
    fastqs_loc_col))
  .meta_check_columns_exist(contents, names(mapping))

  required <- "library_sample_name"
  recommended <- intersect(c("specimen_name", "panel_name",
                             "sequencing_info_name"), unname(mapping))
  wdf <- .meta_rename(contents, mapping)
  .meta_check_null_values(wdf, c(required, recommended))

  meta <- .meta_build_records(wdf, unname(mapping), required)
  meta <- .meta_add_plate_info(
    meta, wdf, match_col = "library_sample_name",
    plate_name_col = library_prep_plate_name_col,
    plate_row_col = library_prep_plate_row_col,
    plate_col_col = library_prep_plate_col_col,
    plate_position_col = library_prep_plate_position_col,
    entry_name = "library_prep_plate_info")
  meta <- .meta_add_parasite_density_info(
    meta, wdf, match_col = "library_sample_name",
    density_col = parasite_density_col, method_col = parasite_density_method_col,
    entry_name = "qpcr_parasite_density_info")

  for (k in seq_along(meta)) {
    for (col in list_values_library_values) {
      if (!is.null(meta[[k]][[col]])) {
        meta[[k]][[col]] <- .meta_listify(meta[[k]][[col]],
                                          list_values_library_values_delimiter)
      }
    }
  }
  meta
}

#' Convert a specimen metadata table into PMO specimen_info
#'
#' @param contents A data.frame, one row per specimen.
#' @param specimen_name_col Column name for specimen names.
#' @param specimen_taxon_id_col,host_taxon_id_col,collection_date_col,collection_country_col,project_name_col,alternate_identifiers_col,blood_meal_col,drug_usage_col,env_broad_scale_col,env_local_scale_col,env_medium_col,geo_admin1_col,geo_admin2_col,geo_admin3_col,gravid_col,gravidity_col,has_travel_out_six_month_col,host_age_col,host_sex_col,host_subject_id,lat_lon_col,specimen_accession_col,specimen_collect_device_col,specimen_comments_col,specimen_store_loc_col,specimen_type_col,treatment_status_col
#'   Optional column names mapped to the corresponding PMO fields.
#' @param parasite_density_col,parasite_density_method_col Optional density
#'   column(s).
#' @param storage_plate_name_col,storage_plate_col_col,storage_plate_row_col,storage_plate_position_col
#'   Optional plate-location columns.
#' @param additional_specimen_cols Extra columns to copy through.
#' @param list_values_specimen_values,list_values_specimen_values_delimiter
#'   Fields that may hold delimited lists, and the delimiter.
#' @return A list of specimen records (name-based).
#' @examples
#' df <- data.frame(specimen_name = c("sp1", "sp2"),
#'                  collection_country = c("Mozambique", "Mozambique"))
#' pmo_specimen_info_table_to_pmo(df, collection_country_col = "collection_country")
#' @export
pmo_specimen_info_table_to_pmo <- function(
    contents, specimen_name_col = "specimen_name", specimen_taxon_id_col = NULL,
    host_taxon_id_col = NULL, collection_date_col = NULL,
    collection_country_col = NULL, project_name_col = NULL,
    alternate_identifiers_col = NULL, blood_meal_col = NULL,
    drug_usage_col = NULL, env_broad_scale_col = NULL, env_local_scale_col = NULL,
    env_medium_col = NULL, geo_admin1_col = NULL, geo_admin2_col = NULL,
    geo_admin3_col = NULL, gravid_col = NULL, gravidity_col = NULL,
    has_travel_out_six_month_col = NULL, host_age_col = NULL, host_sex_col = NULL,
    host_subject_id = NULL, lat_lon_col = NULL, parasite_density_col = NULL,
    parasite_density_method_col = NULL, specimen_accession_col = NULL,
    storage_plate_col_col = NULL, storage_plate_name_col = NULL,
    storage_plate_row_col = NULL, storage_plate_position_col = NULL,
    specimen_collect_device_col = NULL, specimen_comments_col = NULL,
    specimen_store_loc_col = NULL, specimen_type_col = NULL,
    treatment_status_col = NULL, additional_specimen_cols = NULL,
    list_values_specimen_values = c("alternate_identifiers", "drug_usage",
                                    "specimen_comments", "treatment_status",
                                    "specimen_taxon_id"),
    list_values_specimen_values_delimiter = ",") {

  if (!is.data.frame(contents)) stop("contents must be a data.frame")

  mapping <- stats::setNames("specimen_name", specimen_name_col)
  opt <- list(
    specimen_taxon_id = specimen_taxon_id_col, host_taxon_id = host_taxon_id_col,
    collection_date = collection_date_col,
    collection_country = collection_country_col, project_name = project_name_col,
    alternate_identifiers = alternate_identifiers_col, drug_usage = drug_usage_col,
    blood_meal = blood_meal_col, gravid = gravid_col, gravidity = gravidity_col,
    has_travel_out_six_month = has_travel_out_six_month_col,
    env_broad_scale = env_broad_scale_col, env_local_scale = env_local_scale_col,
    env_medium = env_medium_col, geo_admin1 = geo_admin1_col,
    geo_admin2 = geo_admin2_col, geo_admin3 = geo_admin3_col,
    host_age = host_age_col, host_sex = host_sex_col,
    host_subject_id = host_subject_id, lat_lon = lat_lon_col,
    specimen_accession = specimen_accession_col, specimen_type = specimen_type_col,
    treatment_status = treatment_status_col,
    specimen_collect_device = specimen_collect_device_col,
    specimen_comments = specimen_comments_col,
    specimen_store_loc = specimen_store_loc_col)
  for (field in names(opt)) {
    if (!is.null(opt[[field]])) mapping[opt[[field]]] <- field
  }
  for (col in additional_specimen_cols) mapping[col] <- col

  .meta_check_unique_columns(list(
    specimen_name_col, specimen_taxon_id_col, host_taxon_id_col,
    collection_date_col, collection_country_col, project_name_col,
    alternate_identifiers_col, drug_usage_col, env_broad_scale_col,
    env_local_scale_col, env_medium_col, geo_admin1_col, geo_admin2_col,
    geo_admin3_col, host_age_col, host_sex_col, host_subject_id, lat_lon_col,
    specimen_accession_col, specimen_type_col, treatment_status_col,
    storage_plate_col_col, storage_plate_name_col, storage_plate_row_col,
    storage_plate_position_col, specimen_collect_device_col,
    specimen_comments_col, specimen_store_loc_col, blood_meal_col, gravid_col,
    gravidity_col, has_travel_out_six_month_col))
  .meta_check_columns_exist(contents, names(mapping))

  required <- "specimen_name"
  recommended <- intersect(c("specimen_taxon_id", "host_taxon_id",
                             "collection_date", "collection_country",
                             "project_name"), unname(mapping))
  wdf <- .meta_rename(contents, mapping)
  .meta_check_null_values(wdf, c(required, recommended))

  meta <- .meta_build_records(wdf, unname(mapping), required)
  meta <- .meta_add_parasite_density_info(
    meta, wdf, match_col = "specimen_name", density_col = parasite_density_col,
    method_col = parasite_density_method_col, entry_name = "parasite_density_info")
  meta <- .meta_add_plate_info(
    meta, wdf, match_col = "specimen_name",
    plate_name_col = storage_plate_name_col, plate_row_col = storage_plate_row_col,
    plate_col_col = storage_plate_col_col,
    plate_position_col = storage_plate_position_col,
    entry_name = "storage_plate_info")

  for (k in seq_along(meta)) {
    for (col in list_values_specimen_values) {
      if (!is.null(meta[[k]][[col]])) {
        meta[[k]][[col]] <- .meta_listify(meta[[k]][[col]],
                                          list_values_specimen_values_delimiter)
      }
    }
  }
  meta
}
