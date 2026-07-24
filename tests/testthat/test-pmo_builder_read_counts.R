# Builder chunk D: read-count-by-stage tables -> read_counts_by_stage.
# Structure verified against pmotools-python.

rc_total_df <- function() {
  data.frame(library_sample_name = c("l1", "l2"),
             total_raw_count = c(1000, 2000), stringsAsFactors = FALSE)
}

rc_reads_long_df <- function() {
  data.frame(
    library_sample_name = c("l1", "l1", "l2"),
    target_name = c("t1", "t1", "t1"),
    stage = c("demux", "denoise", "demux"),
    read_count = c(500, 400, 900), stringsAsFactors = FALSE)
}

test_that("long-format read counts build the nested structure", {
  out <- pmo_read_count_by_stage_table_to_pmo(
    rc_total_df(), reads_by_stage_table = rc_reads_long_df())
  expect_length(out, 1L)
  by_sample <- out[[1]]$read_counts_by_library_sample_by_stage
  expect_equal(vapply(by_sample, function(s) s$library_sample_name,
                      character(1)), c("l1", "l2"))
  expect_equal(by_sample[[1]]$total_raw_count, 1000L)

  l1_target <- by_sample[[1]]$read_counts_for_targets[[1]]
  expect_equal(l1_target$target_name, "t1")
  expect_equal(vapply(l1_target$stages, function(s) s$stage, character(1)),
               c("demux", "denoise"))
  expect_equal(vapply(l1_target$stages, function(s) s$reads, numeric(1)),
               c(500, 400))
  expect_equal(by_sample[[2]]$read_counts_for_targets[[1]]$stages[[1]]$reads, 900L)
})

test_that("total counts only (no reads_by_stage)", {
  out <- pmo_read_count_by_stage_table_to_pmo(rc_total_df())
  by_sample <- out[[1]]$read_counts_by_library_sample_by_stage
  expect_length(by_sample, 2L)
  expect_null(by_sample[[1]]$read_counts_for_targets)
})

test_that("wide format is melted to stages", {
  wide <- data.frame(library_sample_name = "l1", target_name = "t1",
                     demux = 500, denoise = 400, stringsAsFactors = FALSE)
  total1 <- rc_total_df()[1, ]
  out <- pmo_read_count_by_stage_table_to_pmo(
    total1, reads_by_stage_table = wide, stage_col = c("demux", "denoise"))
  stages <- out[[1]]$read_counts_by_library_sample_by_stage[[1]]$
    read_counts_for_targets[[1]]$stages
  expect_equal(vapply(stages, function(s) s$stage, character(1)),
               c("demux", "denoise"))
  expect_equal(vapply(stages, function(s) s$reads, numeric(1)), c(500, 400))
})

test_that("bioinformatics_run_name as a column splits into runs", {
  total <- rc_total_df()
  total$run <- c("r1", "r2")
  out <- pmo_read_count_by_stage_table_to_pmo(
    total, bioinformatics_run_name = "run")
  expect_length(out, 2L)
  runs <- vapply(out, function(o) o$bioinformatics_run_name, character(1))
  expect_setequal(runs, c("r1", "r2"))
})

test_that("a literal run name is attached", {
  out <- pmo_read_count_by_stage_table_to_pmo(
    rc_total_df(), bioinformatics_run_name = "myrun")
  expect_equal(out[[1]]$bioinformatics_run_name, "myrun")
})

test_that("additional library + target columns carry through", {
  total <- rc_total_df()
  total$note <- c("ok", "ok")
  reads <- rc_reads_long_df()
  reads$flag <- c("a", "b", "c")
  out <- pmo_read_count_by_stage_table_to_pmo(
    total, reads_by_stage_table = reads,
    additional_library_sample_cols = "note",
    additional_target_cols = "flag")
  s1 <- out[[1]]$read_counts_by_library_sample_by_stage[[1]]
  expect_equal(s1$note, "ok")
  expect_equal(s1$read_counts_for_targets[[1]]$stages[[1]]$flag, "a")
})

test_that("duplicate library names in totals error", {
  bad <- data.frame(library_sample_name = c("l1", "l1"),
                    total_raw_count = c(1, 2), stringsAsFactors = FALSE)
  expect_error(pmo_read_count_by_stage_table_to_pmo(bad), "Duplicate")
})

test_that("missing required column errors", {
  bad <- data.frame(library_sample_name = "l1", stringsAsFactors = FALSE)
  expect_error(pmo_read_count_by_stage_table_to_pmo(bad),
               "Missing required columns")
})
