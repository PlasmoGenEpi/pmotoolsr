# Internal helpers shared by the hand-written parts of the package.
#
# R/pmo_r6.R is generated from the schema, so new hand-written code belongs here
# or in the module that uses it.

# Encode a JSON-ready list as JSON text. `digits = NA` writes up to 15
# significant digits (jsonlite's default of 4 decimal places changes the data);
# a `digits` or `na` passed by the caller wins.
.pmo_json_encode <- function(x, pretty = FALSE, auto_unbox = TRUE, ...) {
  args <- list(...)
  if (!("digits" %in% names(args))) args$digits <- NA
  if (!("na" %in% names(args))) args$na <- "string"
  do.call(jsonlite::toJSON,
          c(list(x, pretty = pretty, auto_unbox = auto_unbox), args))
}

# How an argument and its column are named in error messages.
.arg_label <- function(arg, col) {
  sprintf("%s = \"%s\"", arg, paste(col, collapse = "\", \""))
}

# The column arguments of the function that calls this, as a named list of
# argument name -> value: every argument whose name ends in `_col`, plus those
# named in `also`. A builder passes the result to .check_columns_exist() so it
# checks all of its column arguments without listing them again.
.column_arguments <- function(also = character(0)) {
  arg_names <- names(formals(sys.function(sys.parent())))
  unknown <- setdiff(also, arg_names)
  if (length(unknown) > 0) {
    stop("internal error: no argument named ", paste(unknown, collapse = ", "))
  }
  wanted <- c(grep("_col$", arg_names, value = TRUE), also)
  mget(wanted, envir = parent.frame())
}

# Stop if a column argument names a column the table does not have. `cols` is a
# named list of argument name -> column name(s); NULL entries are skipped.
# pmotools-python raises KeyError here, or for some arguments carries on
# without the data.
.check_columns_exist <- function(df, cols, table_name, hint = NULL) {
  bad <- character(0)
  for (arg in names(cols)) {
    absent <- setdiff(as.character(cols[[arg]]), names(df))
    if (length(absent) > 0) bad <- c(bad, .arg_label(arg, absent))
  }
  if (length(bad) > 0) {
    stop("Column(s) not found in ", table_name, ": ",
         paste(bad, collapse = "; "), if (!is.null(hint)) paste0(". ", hint),
         call. = FALSE)
  }
  invisible(TRUE)
}

# TRUE where a cell holds no value: NA, or text that is empty or only spaces
# (how an empty cell arrives from read.csv() in a text column).
.is_blank <- function(x) {
  if (is.factor(x)) x <- as.character(x)
  is.na(x) | (is.character(x) & !nzchar(trimws(x)))
}

# TRUE if `x` is a single cell that holds a value. Optional fields are written
# only when this is TRUE.
.has_value <- function(x) {
  length(x) == 1 && !.is_blank(x)
}

# Stop if a required column has a blank cell. `cols` is a named list of
# argument name -> column name. pmotools-python writes NaN for these
# (PlasmoGenEpi/pmotools-python#103); here a required value must be present.
.check_required_values <- function(df, cols, table_name) {
  bad <- character(0)
  for (arg in names(cols)) {
    for (col in cols[[arg]]) {
      if (any(.is_blank(df[[col]]))) bad <- c(bad, .arg_label(arg, col))
    }
  }
  if (length(bad) > 0) {
    stop("Missing values in required column(s) of ", table_name, ": ",
         paste(unique(bad), collapse = "; "), call. = FALSE)
  }
  invisible(TRUE)
}

# Parse one value as a whole number that fits an integer, or stop. `label`
# names the argument and column, as from .arg_label().
.as_whole_number <- function(x, label) {
  n <- suppressWarnings(as.numeric(x))
  if (is.na(n) || !is.finite(n) || n != floor(n) ||
      abs(n) > .Machine$integer.max) {
    stop(label, " must hold whole numbers, got '", x, "'", call. = FALSE)
  }
  as.integer(n)
}

# Parse a column of read counts: whole numbers of 0 or more, given as numbers
# or as text. Missing values stay NA (required columns are checked first).
# Returns integers, or doubles when a count is too large for an integer.
.as_counts <- function(x, label) {
  if (is.factor(x)) x <- as.character(x)
  n <- suppressWarnings(as.numeric(x))
  bad <- !is.na(x) & (is.na(n) | !is.finite(n) | n != floor(n) | n < 0)
  if (any(bad)) {
    stop(label, " must hold whole numbers of 0 or more, got: ",
         paste(utils::head(unique(as.character(x[bad])), 5), collapse = ", "),
         call. = FALSE)
  }
  if (all(n <= .Machine$integer.max, na.rm = TRUE)) as.integer(n) else n
}

# Sort in the C locale, so the order (and every index that follows from it) is
# the same on every machine and matches pmotools-python, which sorts by code
# point.
.sort_c <- function(x) sort(x, method = "radix")

# Convert a name column to text. Names are text in a PMO whatever type the
# column was read as (PlasmoGenEpi/pmotools-python#105). as.character() would
# write the number 100000 as "1e+05", and differently for integer and double
# columns, so whole numbers are written out in full.
.as_text <- function(x) {
  if (is.double(x)) {
    out <- format(x, scientific = FALSE, trim = TRUE, drop0trailing = TRUE,
                  digits = 15)
    out[is.na(x)] <- NA_character_
    return(out)
  }
  as.character(x)
}

# The label of a detected-microhaplotypes (or read-counts) set that has no
# bioinformatics_run_id: its run name, or else its 0-based position.
.run_label_without_id <- function(set, position) {
  set$bioinformatics_run_name %||%
    paste0("detected_microhaplotypes_count_idx_", position)
}

# A copy of a PMO object with one list field emptied, to be refilled. The
# filters use it so that every other field of the object is kept.
.copy_with_empty_field <- function(x, field) {
  x[[field]] <- list()
  x
}
