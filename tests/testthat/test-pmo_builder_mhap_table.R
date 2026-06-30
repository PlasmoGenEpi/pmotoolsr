# Builder chunk A: microhaplotype table -> PMO structures.
# Structure verified against pmotools-python (indices are 1-based here).

mhap_fixture_df <- function() {
  data.frame(
    library_sample_name = c("S1", "S1", "S1", "S2", "S2"),
    target_name = c("t1", "t1", "t2", "t1", "t2"),
    seq = c("AAA", "AAC", "GGG", "AAA", "GGT"),
    reads = c(10, 5, 20, 8, 15),
    stringsAsFactors = FALSE
  )
}

test_that("representative microhaplotypes are built (targets sorted, seqs ordered)", {
  out <- pmo_mhap_table_to_pmo(mhap_fixture_df())
  reps <- out$representative_microhaplotypes$targets
  expect_length(reps, 2L)
  expect_equal(vapply(reps, function(t) t$target_name, character(1)),
               c("t1", "t2"))
  expect_equal(vapply(reps[[1]]$microhaplotypes, function(m) m$seq, character(1)),
               c("AAA", "AAC"))
  expect_equal(vapply(reps[[2]]$microhaplotypes, function(m) m$seq, character(1)),
               c("GGG", "GGT"))
})

test_that("detected microhaplotypes use 1-based mhaps_target_id / mhap_id", {
  out <- pmo_mhap_table_to_pmo(mhap_fixture_df())
  expect_length(out$detected_microhaplotypes, 1L)
  samples <- out$detected_microhaplotypes[[1]]$library_samples
  expect_equal(vapply(samples, function(s) s$library_sample_name, character(1)),
               c("S1", "S2"))

  s1 <- samples[[1]]
  expect_equal(s1$target_results[[1]]$mhaps_target_id, 1L)
  expect_equal(
    vapply(s1$target_results[[1]]$mhaps, function(m) m$mhap_id, numeric(1)),
    c(1, 2))
  expect_equal(
    vapply(s1$target_results[[1]]$mhaps, function(m) m$reads, numeric(1)),
    c(10, 5))
  expect_equal(s1$target_results[[2]]$mhaps_target_id, 2L)
  expect_equal(s1$target_results[[2]]$mhaps[[1]]$mhap_id, 1L)

  s2 <- samples[[2]]
  # S2's t2 allele GGT is the 2nd microhaplotype -> mhap_id 2
  expect_equal(s2$target_results[[2]]$mhaps[[1]]$mhap_id, 2L)
  expect_equal(s2$target_results[[2]]$mhaps[[1]]$reads, 15)
})

test_that("bioinformatics_run_name as a column splits into multiple sets", {
  df <- mhap_fixture_df()
  df$run <- c("r1", "r1", "r1", "r2", "r2")
  out <- pmo_mhap_table_to_pmo(df, bioinformatics_run_name = "run")
  expect_length(out$detected_microhaplotypes, 2L)
  runs <- vapply(out$detected_microhaplotypes,
                 function(d) d$bioinformatics_run_name, character(1))
  expect_setequal(runs, c("r1", "r2"))
})

test_that("a literal run name is attached to the single detected set", {
  out <- pmo_mhap_table_to_pmo(mhap_fixture_df(),
                               bioinformatics_run_name = "myrun")
  expect_equal(out$detected_microhaplotypes[[1]]$bioinformatics_run_name,
               "myrun")
})

test_that("umis and additional detected columns are carried through", {
  df <- mhap_fixture_df()
  df$umis <- c(3, 2, 7, 4, 6)
  out <- pmo_mhap_table_to_pmo(df, umis_col = "umis")
  m <- out$detected_microhaplotypes[[1]]$library_samples[[1]]$
    target_results[[1]]$mhaps[[1]]
  expect_equal(m$umis, 3)
})

test_that("mhap location is attached when location columns are given", {
  df <- mhap_fixture_df()
  df$chrom <- "chr1"
  df$start <- c(100, 100, 200, 100, 200)
  df$end <- c(150, 150, 260, 150, 260)
  out <- pmo_mhap_table_to_pmo(df, chrom_col = "chrom", start_col = "start",
                               end_col = "end", genome_id = 1)
  loc <- out$representative_microhaplotypes$targets[[1]]$mhap_location
  expect_equal(loc$genome_id, 1)
  expect_equal(loc$chrom, "chr1")
  expect_equal(loc$start, 100)
})

test_that("pseudocigar is built as a Pseudocigar object with a ref_loc", {
  df <- mhap_fixture_df()
  df$chrom <- "chr1"
  df$start <- c(100, 100, 200, 100, 200)
  df$end <- c(150, 150, 260, 150, 260)
  df$pc <- c("5=A", "5=C", "10=G", "5=A", "10=T")
  out <- pmo_mhap_table_to_pmo(
    df, chrom_col = "chrom", start_col = "start", end_col = "end",
    pseudocigar_col = "pc",
    pseudocigar_start_col = "start", pseudocigar_end_col = "end",
    genome_id = 1)
  mh <- out$representative_microhaplotypes$targets[[1]]$microhaplotypes[[1]]
  expect_type(mh$pseudocigar, "list")
  expect_equal(mh$pseudocigar$pseudocigar_seq, "5=A")
  # ref_loc is a GenomicLocation: chrom reused from chrom_col, genome_id default
  expect_equal(mh$pseudocigar$ref_loc$chrom, "chr1")
  expect_equal(mh$pseudocigar$ref_loc$genome_id, 1)
  expect_equal(mh$pseudocigar$ref_loc$start, 100)
  expect_equal(mh$pseudocigar$ref_loc$end, 150)
})

test_that("pseudocigar with separate location columns and genome id", {
  df <- mhap_fixture_df()
  df$chrom <- "chr1"
  df$pc <- c("5=A", "5=C", "10=G", "5=A", "10=T")
  df$pc_start <- c(1, 1, 2, 1, 2)
  df$pc_end <- c(6, 6, 12, 6, 12)
  out <- pmo_mhap_table_to_pmo(
    df, pseudocigar_col = "pc", pseudocigar_chrom_col = "chrom",
    pseudocigar_start_col = "pc_start", pseudocigar_end_col = "pc_end",
    pseudocigar_genome_id = 2)
  rl <- out$representative_microhaplotypes$targets[[1]]$
    microhaplotypes[[1]]$pseudocigar$ref_loc
  expect_equal(rl$genome_id, 2)
  expect_equal(rl$start, 1)
  expect_equal(rl$end, 6)
})

test_that("pseudocigar_col without ref_loc columns errors", {
  df <- mhap_fixture_df()
  df$pc <- c("5=A", "5=C", "10=G", "5=A", "10=T")
  expect_error(
    pmo_mhap_table_to_pmo(df, pseudocigar_col = "pc"),
    "ref_loc must be"
  )
})

test_that("missing seq in representative table errors in detected build", {
  df <- mhap_fixture_df()
  # build rep dict from a table missing one seq, then detect against fuller table
  rep_only <- df[df$seq != "GGT", ]
  expect_error(
    {
      rep_dict <- pmotoolsr:::.create_representative_microhaplotype_dict(rep_only)
      pmotoolsr:::.create_detected_microhaplotype_dict(df, rep_dict)
    },
    "not found in representative"
  )
})

test_that("minimum library/specimen info derives from detected set", {
  out <- pmo_mhap_table_to_pmo(mhap_fixture_df())
  ls <- pmo_minimum_library_specimen_from_mhap_table(
    out$detected_microhaplotypes, panel_name = "panelA")
  expect_length(ls$library_sample_info, 2L)
  expect_equal(ls$library_sample_info[[1]]$panel_name, "panelA")
  expect_equal(ls$library_sample_info[[1]]$specimen_name, "S1")
  expect_length(ls$specimen_info, 2L)
})

test_that("library/specimen key maps library names to specimens", {
  out <- pmo_mhap_table_to_pmo(mhap_fixture_df())
  key <- c(S1 = "spec1", S2 = "spec1")
  ls <- pmo_minimum_library_specimen_from_mhap_table(
    out$detected_microhaplotypes, panel_name = "panelA",
    library_sample_specimen_key = key)
  expect_equal(ls$library_sample_info[[1]]$specimen_name, "spec1")
  expect_length(ls$specimen_info, 1L) # both libs -> one specimen
})
