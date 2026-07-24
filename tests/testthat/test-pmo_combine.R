# combine multiple PMOs. Verified against pmotools-python (1-based ids).

build_simple_pmo <- function(libs, targets, seqs, reads, panel_name,
                             panel_targets) {
  mhap <- data.frame(library_sample_name = libs, target_name = targets,
                     seq = seqs, reads = reads, stringsAsFactors = FALSE)
  mhap_info <- pmo_mhap_table_to_pmo(mhap)
  panel <- data.frame(
    target_name = panel_targets,
    fwd_primer = vapply(seq_along(panel_targets),
                        function(i) strrep("A", i + 3), character(1)),
    rev_primer = vapply(seq_along(panel_targets),
                        function(i) strrep("C", i + 3), character(1)),
    stringsAsFactors = FALSE)
  panel_info <- pmo_panel_info_table_to_pmo(panel, panel_name)
  pmo_merge_to_pmo(mhap_info = mhap_info, panel_target_info = panel_info)
}

test_that("combine requires more than one PMO", {
  expect_error(pmo_combine_pmos(list(build_simple_pmo(
    "S1", "t1", "AAA", 10, "panelA", c("t1", "t2")))),
    "multiple PMO objects were expected")
})

test_that("combine dedups shared targets/panels and concatenates samples", {
  pmoA <- build_simple_pmo(c("S1", "S2"), c("t1", "t2"), c("AAA", "GGG"),
                           c(10, 20), "panelA", c("t1", "t2"))
  pmoB <- build_simple_pmo(c("S3", "S4"), c("t1", "t2"), c("AAA", "TTT"),
                           c(5, 8), "panelA", c("t1", "t2"))
  combined <- pmo_combine_pmos(list(pmoA, pmoB))

  expect_equal(vapply(combined$target_info, function(t) t$target_name,
                      character(1)), c("t1", "t2"))
  expect_length(combined$panel_info, 1L)
  expect_equal(vapply(combined$specimen_info, function(s) s$specimen_name,
                      character(1)), c("S1", "S2", "S3", "S4"))
  expect_equal(vapply(combined$library_sample_info,
                      function(l) l$specimen_id, numeric(1)), c(1, 2, 3, 4))
  expect_length(combined$detected_microhaplotypes, 2L)
  expect_length(combined$representative_microhaplotypes$targets, 2L)

  # t1 is shared (AAA in both -> deduped); t2 differs (GGG, TTT -> merged)
  t1_seqs <- vapply(combined$representative_microhaplotypes$targets[[1]]$
                      microhaplotypes, function(m) m$seq, character(1))
  t2_seqs <- vapply(combined$representative_microhaplotypes$targets[[2]]$
                      microhaplotypes, function(m) m$seq, character(1))
  expect_equal(t1_seqs, "AAA")
  expect_setequal(t2_seqs, c("GGG", "TTT"))
})

test_that("combined PMO validates against the schema and round-trips", {
  pmoA <- build_simple_pmo(c("S1", "S2"), c("t1", "t2"), c("AAA", "GGG"),
                           c(10, 20), "panelA", c("t1", "t2"))
  pmoB <- build_simple_pmo(c("S3", "S4"), c("t1", "t2"), c("AAA", "TTT"),
                           c(5, 8), "panelA", c("t1", "t2"))
  combined <- pmo_combine_pmos(list(pmoA, pmoB))
  expect_true(pmo_validate(combined))

  tmp <- tempfile(fileext = ".json")
  on.exit(unlink(tmp), add = TRUE)
  write_pmo_raw(combined, tmp)
  reread <- read_pmo(tmp, validate = TRUE)
  expect_length(reread$specimen_info, 4L)
})

test_that("new target/panel from a later PMO are remapped correctly", {
  pmoA <- build_simple_pmo(c("S1", "S2"), c("t1", "t2"), c("AAA", "GGG"),
                           c(10, 20), "panelA", c("t1", "t2"))
  # pmoB introduces a brand-new target t3 (and its own panel)
  pmoB <- build_simple_pmo(c("S3", "S4"), c("t1", "t3"), c("AAA", "CCC"),
                           c(5, 8), "panelB", c("t1", "t3"))
  combined <- pmo_combine_pmos(list(pmoA, pmoB))

  expect_equal(vapply(combined$target_info, function(t) t$target_name,
                      character(1)), c("t1", "t2", "t3"))
  expect_length(combined$panel_info, 2L)

  # the new rep target's target_id points to the combined target_info entry
  # for t3 (this is the bug fixed vs the Python original)
  reps <- combined$representative_microhaplotypes$targets
  t3_rep <- Filter(function(r)
    combined$target_info[[r$target_id]]$target_name == "t3", reps)
  expect_length(t3_rep, 1L)
  expect_equal(combined$target_info[[t3_rep[[1]]$target_id]]$target_name, "t3")

  # panelB's panel_targets remap to the combined target indices (t1=1, t3=3)
  panelB <- Filter(function(p) p$panel_name == "panelB",
                   combined$panel_info)[[1]]
  expect_setequal(unlist(panelB$reactions[[1]]$panel_targets), c(1L, 3L))

  expect_true(pmo_validate(combined))
})

test_that("duplicate library sample names across PMOs error", {
  pmoA <- build_simple_pmo(c("S1", "S2"), c("t1", "t2"), c("AAA", "GGG"),
                           c(10, 20), "panelA", c("t1", "t2"))
  pmoB <- build_simple_pmo(c("S1", "S3"), c("t1", "t2"), c("AAA", "TTT"),
                           c(5, 8), "panelA", c("t1", "t2"))
  expect_error(pmo_combine_pmos(list(pmoA, pmoB)),
               "Duplicate library sample names")
})
