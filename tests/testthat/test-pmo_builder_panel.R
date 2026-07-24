# Builder chunk B: panel/target table -> target_info + panel_info.
# Reference verified against pmotools-python (1-based indices; the R port fixes
# the Python forward-primer start/end swap).

panel_fixture_df <- function() {
  data.frame(
    target_name = c("t1", "t2", "t3"),
    fwd_primer = c("AAA", "CCC", "GGG"),
    rev_primer = c("TTT", "GGG", "CCC"),
    reaction = c("pool1", "pool1,pool2", "pool2"),
    chrom = c("chr1", "chr1", "chr2"),
    fwd_start = c(10, 200, 5), fwd_end = c(20, 210, 15),
    rev_start = c(80, 280, 95), rev_end = c(90, 290, 105),
    ins_start = c(20, 210, 15), ins_end = c(80, 280, 95),
    stringsAsFactors = FALSE
  )
}

panel_fixture_genome <- function() {
  list(name = "Pf3D7", genome_version = "v3", taxon_id = 5833L,
       url = "http://x")
}

build_panel_fixture <- function() {
  pmo_panel_info_table_to_pmo(
    panel_fixture_df(), "panelA", genome_info = panel_fixture_genome(),
    reaction_name_col = "reaction",
    forward_primers_start_col = "fwd_start", forward_primers_end_col = "fwd_end",
    reverse_primers_start_col = "rev_start", reverse_primers_end_col = "rev_end",
    insert_start_col = "ins_start", insert_end_col = "ins_end",
    chrom_col = "chrom")
}

test_that("reactions map targets to 1-based indices", {
  out <- build_panel_fixture()
  reactions <- out$panel_info[[1]]$reactions
  named <- stats::setNames(lapply(reactions, function(r) unlist(r$panel_targets)),
                           vapply(reactions, function(r) r$reaction_name,
                                  character(1)))
  expect_equal(named[["pool1"]], c(1L, 2L))
  expect_equal(named[["pool2"]], c(2L, 3L))
})

test_that("insert + primer locations use 1-based genome_id and correct order", {
  out <- build_panel_fixture()
  t1 <- out$target_info[[1]]
  expect_equal(t1$insert_location,
               list(genome_id = 1L, chrom = "chr1", start = 20L, end = 80L))
  # forward primer start/end are correct (not swapped like the Python original)
  expect_equal(t1$forward_primer$location,
               list(genome_id = 1L, chrom = "chr1", start = 10L, end = 20L))
  expect_equal(t1$reverse_primer$location,
               list(genome_id = 1L, chrom = "chr1", start = 80L, end = 90L))
})

test_that("targeted_genomes carried through (single genome wrapped to list)", {
  out <- build_panel_fixture()
  expect_length(out$targeted_genomes, 1L)
  expect_equal(out$targeted_genomes[[1]]$name, "Pf3D7")
})

test_that("no reaction column -> single 'full' reaction with all targets", {
  df <- panel_fixture_df()
  df$reaction <- NULL
  out <- pmo_panel_info_table_to_pmo(df, "panelA")
  expect_length(out$panel_info[[1]]$reactions, 1L)
  expect_equal(out$panel_info[[1]]$reactions[[1]]$reaction_name, "full")
  expect_equal(unlist(out$panel_info[[1]]$reactions[[1]]$panel_targets),
               c(1L, 2L, 3L))
  expect_null(out$targeted_genomes)
})

test_that("gene_name and target_attributes are parsed", {
  df <- panel_fixture_df()
  df$reaction <- NULL
  df$gene <- c("dhfr", "dhps", "k13")
  df$attrs <- c("drug_resistance,core", "drug_resistance", "core")
  out <- pmo_panel_info_table_to_pmo(df, "panelA", gene_name_col = "gene",
                                     target_attributes_col = "attrs")
  expect_equal(out$target_info[[1]]$gene_name, "dhfr")
  expect_equal(out$target_info[[1]]$target_attributes,
               c("drug_resistance", "core"))
})

test_that("location columns without genome_info errors", {
  df <- panel_fixture_df()
  df$reaction <- NULL
  expect_error(
    pmo_panel_info_table_to_pmo(
      df, "panelA", insert_start_col = "ins_start", insert_end_col = "ins_end",
      chrom_col = "chrom"),
    "no targeted_genomes"
  )
})

test_that("duplicate target names error", {
  df <- panel_fixture_df()
  df$target_name <- c("t1", "t1", "t3")
  df$reaction <- NULL
  expect_error(pmo_panel_info_table_to_pmo(df, "panelA"), "duplicated")
})

test_that("inconsistent location columns error", {
  df <- panel_fixture_df()
  df$reaction <- NULL
  expect_error(
    pmo_panel_info_table_to_pmo(
      df, "panelA", genome_info = panel_fixture_genome(),
      insert_start_col = "ins_start", chrom_col = "chrom"),
    "both must be"
  )
})

test_that("genome_info missing required keys errors", {
  df <- panel_fixture_df()
  df$reaction <- NULL
  bad_genome <- list(name = "x", genome_version = "v1")
  expect_error(
    pmo_panel_info_table_to_pmo(
      df, "panelA", genome_info = bad_genome,
      insert_start_col = "ins_start", insert_end_col = "ins_end",
      chrom_col = "chrom"),
    "missing required keys"
  )
})

# --- merge_panel_info_dicts ------------------------------------------------

test_that("merge dedups targets/genomes and remaps indices", {
  # panel 1: t1, t2 ; panel 2: t2 (dup), t3 ; same genome -> deduped
  df1 <- panel_fixture_df()[1:2, ]
  df1$reaction <- NULL
  df2 <- panel_fixture_df()[2:3, ]
  df2$reaction <- NULL
  g <- panel_fixture_genome()
  p1 <- pmo_panel_info_table_to_pmo(
    df1, "panel1", genome_info = g, insert_start_col = "ins_start",
    insert_end_col = "ins_end", chrom_col = "chrom")
  p2 <- pmo_panel_info_table_to_pmo(
    df2, "panel2", genome_info = g, insert_start_col = "ins_start",
    insert_end_col = "ins_end", chrom_col = "chrom")

  merged <- pmo_merge_panel_info_dicts(list(p1, p2))
  # t1, t2, t3 -> 3 unique targets
  expect_length(merged$target_info, 3L)
  expect_equal(vapply(merged$target_info, function(t) t$target_name,
                      character(1)), c("t1", "t2", "t3"))
  # one shared genome
  expect_length(merged$targeted_genomes, 1L)
  # panel2's first reaction target (t2) remaps to merged index 2
  expect_length(merged$panel_info, 2L)
  expect_equal(unlist(merged$panel_info[[2]]$reactions[[1]]$panel_targets),
               c(2L, 3L))
  # genome ids still valid (1-based, within range)
  gids <- vapply(merged$target_info,
                 function(t) t$insert_location$genome_id, numeric(1))
  expect_true(all(gids == 1L))
})

test_that("merge errors on empty input", {
  expect_error(pmo_merge_panel_info_dicts(list()), "at least one")
})
