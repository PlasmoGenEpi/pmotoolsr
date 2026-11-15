# PMO builder: specimen / library-sample metadata tables -> PMO structures
#
# Ported from pmotools-python pmo_builder/metatable_to_pmo.py. Produces
# NAME-based intermediates (specimen_name / panel_name / sequencing_info_name
# instead of ids); pmo_merge_to_pmo() replaces the names with indices.
#
# Plate and density values are read from the same row of the table as the
# record they are added to. Library qPCR density is written under the schema
# field "qpcr_parasite_density_info".

#' @keywords internal
.meta_check_unique_columns <- function(columns) {
  cols <- unlist(columns[!vapply(columns, is.null, logical(1))])
  if (length(cols) != length(unique(cols))) {
    stop("Selected columns must be unique.")
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
      if (field %in% required_fields || .has_value(v)) rec[[field]] <- v
    }
    recs[[i]] <- rec
  }
  recs
}

#' @keywords internal
# Split plate positions such as "A01" into a row letter and a column number.
# A blank cell gives NA for both, so that record gets no plate position;
# spaces around a value are ignored (both as in pmotools-python).
.meta_parse_plate_position <- function(pos) {
  pos <- trimws(as.character(pos))
  blank <- .is_blank(pos)
  rows <- rep(NA_character_, length(pos))
  cols <- rep(NA_integer_, length(pos))
  m <- regmatches(pos, regexec("^([A-Ha-h])0*([1-9]|1[0-2])$", pos))
  ok <- !blank & lengths(m) == 3
  if (any(!blank & !ok)) {
    stop("Values in the plate position column must be a single letter A-H/a-h ",
         "followed by a number 1-12. Got: ",
         paste(unique(pos[!blank & !ok]), collapse = ", "), call. = FALSE)
  }
  rows[ok] <- toupper(vapply(m[ok], function(g) g[2], character(1)))
  cols[ok] <- as.integer(vapply(m[ok], function(g) g[3], character(1)))
  list(row = rows, col = cols)
}

# Add a plate-location object to each record. `meta[[k]]` was built from row k
# of `contents`, so values are read from that row of the original table.
#' @keywords internal
.meta_add_plate_info <- function(meta, contents, plate_name_col, plate_row_col,
                                 plate_col_col, plate_position_col, entry_name) {
  if (is.null(plate_name_col) && is.null(plate_row_col) &&
      is.null(plate_col_col) && is.null(plate_position_col)) {
    return(meta)
  }
  if (xor(is.null(plate_row_col), is.null(plate_col_col))) {
    stop("If either plate row or column is set, then both must be.")
  }
  if (!is.null(plate_position_col) && !is.null(plate_col_col)) {
    stop("Plate position can be specified using either row and col, or ",
         "position, but not both.")
  }
  names_v <- if (!is.null(plate_name_col)) contents[[plate_name_col]]
  rows_v <- if (!is.null(plate_row_col)) contents[[plate_row_col]]
  cols_v <- if (!is.null(plate_col_col)) contents[[plate_col_col]]
  if (!is.null(plate_position_col)) {
    parsed <- .meta_parse_plate_position(contents[[plate_position_col]])
    rows_v <- parsed$row
    cols_v <- parsed$col
  }
  for (k in seq_along(meta)) {
    plate_info <- list()
    if (!is.null(names_v) && .has_value(names_v[k])) {
      plate_info$plate_name <- names_v[k]
    }
    if (!is.null(rows_v) && .has_value(rows_v[k])) {
      plate_info$plate_row <- toupper(as.character(rows_v[k]))
    }
    if (!is.null(cols_v) && .has_value(cols_v[k])) {
      plate_info$plate_col <- as.integer(cols_v[k])
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

# Add parasite densities to each record; values come from row k of `contents`.
#' @keywords internal
.meta_add_parasite_density_info <- function(meta, contents, density_col,
                                            method_col, entry_name) {
  pairs <- .meta_density_pairs(density_col, method_col)
  if (length(pairs) == 0) return(meta)
  for (k in seq_along(meta)) {
    infos <- list()
    for (p in pairs) {
      dv <- contents[[p$density]][k]
      if (.has_value(dv)) {
        info <- list(parasite_density = dv)
        if (!is.null(p$method) && .has_value(contents[[p$method]][k])) {
          info$parasite_density_method <- contents[[p$method]][k]
        }
        infos[[length(infos) + 1L]] <- info
      }
    }
    if (length(infos) > 0) meta[[k]][[entry_name]] <- infos
  }
  meta
}

# The columns a metadata builder reads, as a named character vector of table
# column -> PMO field. `field_cols` is a named list of PMO field -> column (NULL
# entries are skipped); each additional column keeps its own name. An
# additional column that is already mapped to the field of its own name changes
# nothing. Two columns may not give the same field: pmotools-python keeps both
# (PlasmoGenEpi/pmotools-python#110), and the record would take whichever comes
# first in the table.
#' @keywords internal
.meta_build_mapping <- function(field_cols, additional, additional_arg) {
  field_cols <- field_cols[!vapply(field_cols, is.null, logical(1))]
  mapping <- stats::setNames(names(field_cols),
                             unlist(field_cols, use.names = FALSE))
  additional <- additional[!(additional %in% names(mapping) &
                               mapping[additional] == additional)]
  already <- intersect(additional, names(mapping))
  if (length(already) > 0) {
    stop(additional_arg, " lists column(s) that are already mapped to a PMO ",
         "field: ", paste(already, collapse = ", "), call. = FALSE)
  }
  mapping <- c(mapping, stats::setNames(additional, additional))
  repeated <- unique(mapping[duplicated(mapping)])
  if (length(repeated) > 0) {
    field <- repeated[1]
    stop("Columns ", paste0("\"", names(mapping)[mapping == field], "\"",
                            collapse = " and "),
         " would both become the PMO field \"", field, "\"", call. = FALSE)
  }
  mapping
}

# Check a metadata table and give it its PMO field names. Every cell of the
# `required` columns (a named list of argument -> column) must hold a value.
# The columns of the `recommended` PMO fields may not hold NA; an empty cell in
# any other mapped column just leaves that field out of the record.
#' @keywords internal
.meta_prepare_table <- function(contents, mapping, required, recommended) {
  .check_required_values(contents, required, "contents")
  .meta_check_null_values(contents, names(mapping)[mapping %in% recommended])
  .meta_names_as_text(.meta_rename_columns(contents, mapping))
}

# Rename the mapped columns to their PMO field names. An unmapped column that
# already has one of those names is dropped first; otherwise the table would
# have two columns with that name.
#' @keywords internal
.meta_rename_columns <- function(contents, mapping) {
  fields <- unname(mapping)
  clash <- setdiff(intersect(names(contents), fields), names(mapping))
  wdf <- contents[, !(names(contents) %in% clash), drop = FALSE]
  names(wdf)[match(names(mapping), names(wdf))] <- fields
  wdf
}

# Name fields are text in a PMO, whatever type the column was read as.
#' @keywords internal
.meta_names_as_text <- function(wdf) {
  for (field in intersect(c("specimen_name", "library_sample_name", "panel_name",
                            "sequencing_info_name", "project_name"), names(wdf))) {
    wdf[[field]] <- .as_text(wdf[[field]])
  }
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

  .meta_check_unique_columns(list(
    library_sample_name_col, sequencing_info_name_col, specimen_name_col,
    panel_name_col, alternate_identifiers_col, experiment_accession_col,
    fastqs_loc_col))
  .check_columns_exist(
    contents, .column_arguments(also = "additional_library_sample_info_cols"),
    "contents")
  mapping <- .meta_build_mapping(
    list(library_sample_name = library_sample_name_col,
         specimen_name = specimen_name_col, panel_name = panel_name_col,
         sequencing_info_name = sequencing_info_name_col,
         alternate_identifiers = alternate_identifiers_col,
         experiment_accession = experiment_accession_col,
         fastqs_loc = fastqs_loc_col, run_accession = run_accession_col),
    additional_library_sample_info_cols, "additional_library_sample_info_cols")
  wdf <- .meta_prepare_table(
    contents, mapping,
    required = list(library_sample_name_col = library_sample_name_col),
    recommended = c("specimen_name", "panel_name", "sequencing_info_name"))

  meta <- .meta_build_records(wdf, unname(mapping), "library_sample_name")
  meta <- .meta_add_plate_info(
    meta, contents,
    plate_name_col = library_prep_plate_name_col,
    plate_row_col = library_prep_plate_row_col,
    plate_col_col = library_prep_plate_col_col,
    plate_position_col = library_prep_plate_position_col,
    entry_name = "library_prep_plate_info")
  meta <- .meta_add_parasite_density_info(
    meta, contents,
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

  field_cols <- list(
    specimen_name = specimen_name_col,
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
  # the host subject argument has no `_col` suffix
  .check_columns_exist(
    contents,
    .column_arguments(also = c("host_subject_id", "additional_specimen_cols")),
    "contents")
  mapping <- .meta_build_mapping(field_cols, additional_specimen_cols,
                                 "additional_specimen_cols")
  wdf <- .meta_prepare_table(
    contents, mapping, required = list(specimen_name_col = specimen_name_col),
    recommended = c("specimen_taxon_id", "host_taxon_id", "collection_date",
                    "collection_country", "project_name"))

  meta <- .meta_build_records(wdf, unname(mapping), "specimen_name")
  meta <- .meta_add_parasite_density_info(
    meta, contents, density_col = parasite_density_col,
    method_col = parasite_density_method_col, entry_name = "parasite_density_info")
  meta <- .meta_add_plate_info(
    meta, contents,
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
