# pmo_exporter: flat meta tables, BED extraction, allele table, Excel export.
# Reference shapes verified against pmotools-python on the same fixture.

test_that("specimen meta table resolves project_id -> project_name", {
  sm <- pmo_export_specimen_meta_table(full_pmo())
  expect_s3_class(sm, "tbl_df")
  expect_equal(nrow(sm), 2L)
  expect_true("project_name" %in% names(sm))
  expect_equal(sm$project_name, c("MOZ2018", "MOZ2018"))
  expect_false("project_id" %in% names(sm))
})

test_that("library sample meta resolves ids to names", {
  lm <- pmo_export_library_sample_meta_table(full_pmo())
  expect_equal(nrow(lm), 2L)
  expect_true(all(c("specimen_name", "panel_name") %in% names(lm)))
  expect_false(any(c("specimen_id", "panel_id") %in% names(lm)))
})

test_that("target info table flattens primers/insert with priority columns", {
  ti <- pmo_export_target_info_meta_table(full_pmo())
  expect_equal(nrow(ti), 100L)
  expect_equal(names(ti)[1:3],
               c("target_name", "forward_primer_seq", "reverse_primer_seq"))
  expect_true(any(grepl("^insert_", names(ti))))
  expect_true(any(grepl("^forward_primer_", names(ti))))
})

test_that("panel info table is one row per (panel, target)", {
  pi <- pmo_export_panel_info_meta_table(full_pmo())
  expect_equal(nrow(pi), 100L)
  expect_equal(names(pi), c("panel_name", "target_name", "reaction_name"))
})

test_that("pmo header and genomes tables", {
  ph <- pmo_export_pmo_header_table(full_pmo())
  expect_equal(nrow(ph), 1L)
  expect_equal(names(ph)[1], "pmo_version")
  expect_true("generation_method.program_name" %in% names(ph))

  tg <- pmo_export_targeted_genomes_meta_table(full_pmo())
  expect_equal(nrow(tg), 1L)
  expect_true("genome_id" %in% names(tg))
})

test_that("bioinformatics / sequencing exporters", {
  pmo <- full_pmo()
  expect_equal(nrow(pmo_export_bioinformatics_run_info_meta_table(pmo)), 1L)
  bm <- pmo_export_bioinformatics_methods_info_meta_table(pmo)
  expect_equal(nrow(bm), 3L) # one row per method step
  expect_true(all(c("bioinformatics_methods_id", "method_id") %in% names(bm)))
  expect_equal(nrow(pmo_export_sequencing_info_meta_table(pmo)), 1L)
})

test_that("allele table matches reference shape and columns", {
  al <- pmo_extract_alleles_per_sample_table(full_pmo(),
                                             additional_microhap_fields = "reads")
  expect_equal(nrow(al), 251L)
  expect_equal(names(al),
               c("library_sample_name", "target_name", "seq",
                 "bioinformatics_run_name", "reads"))
  expect_true(all(al$reads >= 1))
})

test_that("allele table errors on a field that exists nowhere", {
  expect_error(
    pmo_extract_alleles_per_sample_table(full_pmo(),
                                         additional_specimen_info_fields = "nope"),
    "No specimen_info have data"
  )
})

test_that("allele table can add specimen + library metadata columns", {
  al <- pmo_extract_alleles_per_sample_table(
    full_pmo(),
    additional_specimen_info_fields = "collection_country",
    additional_library_sample_info_fields = "library_sample_name"
  )
  expect_true("collection_country" %in% names(al))
  expect_true(all(al$collection_country == "Mozambique"))
})

test_that("list library samples per specimen", {
  lp <- pmo_list_library_samples_per_specimen(full_pmo())
  expect_equal(nrow(lp), 2L)
  expect_equal(names(lp),
               c("specimen_name", "library_sample_name", "library_sample_count"))
  expect_error(
    pmo_list_library_samples_per_specimen(full_pmo(), select_specimen_ids = 1,
                                          select_specimen_names = "x"),
    "Cannot specify both"
  )
})

test_that("BED extraction + write", {
  pmo <- full_pmo()
  bt <- pmo_extract_targets_insert_bed(pmo)
  expect_equal(nrow(bt), 100L)
  expect_equal(names(bt),
               c("chrom", "start", "end", "name", "score", "strand",
                 "ref_seq", "extra_info"))
  # sorted by chrom, start
  expect_false(is.unsorted(bt$start[bt$chrom == bt$chrom[1]]))

  tmp <- tempfile(fileext = ".bed")
  on.exit(unlink(tmp), add = TRUE)
  pmo_write_bed(bt, tmp, add_header = TRUE)
  lines <- readLines(tmp)
  expect_true(startsWith(lines[1], "#chrom"))
  expect_equal(length(lines), 101L) # header + 100 rows
})

test_that("panel BED extraction includes panel/reaction columns", {
  pb <- pmo_extract_panels_insert_bed(full_pmo())
  expect_true(all(c("panel_name", "reaction_name", "chrom") %in% names(pb)))
  expect_true(nrow(pb) >= 100L)
})

test_that("Excel export writes all expected sheets", {
  tmp <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp), add = TRUE)
  pmo_export_to_excel(full_pmo(), tmp)
  expect_true(file.exists(tmp))
  sheets <- openxlsx::getSheetNames(tmp)
  expect_true(all(c("PMO Header", "Required Panel Targets",
                    "Required Microhaplotype") %in% sheets))
})

# --- Minimum required-fields PMO ------------------------------------------

test_that("core exporters work on the minimum PMO", {
  pmo <- minimum_pmo()
  sm <- pmo_export_specimen_meta_table(pmo)
  expect_equal(nrow(sm), 129L)
  expect_equal(names(sm), "specimen_name") # only required field present

  expect_equal(nrow(pmo_export_library_sample_meta_table(pmo)), 129L)
  expect_equal(nrow(pmo_export_target_info_meta_table(pmo)), 27L)
  al <- pmo_extract_alleles_per_sample_table(pmo)
  expect_true(nrow(al) > 0)
  expect_true(all(startsWith(al$bioinformatics_run_name,
                             "detected_microhaplotypes_count_idx_")))
})

test_that("optional-section exporters error on the minimum PMO", {
  pmo <- minimum_pmo()
  expect_error(pmo_export_sequencing_info_meta_table(pmo), "sequencing_info")
  expect_error(pmo_export_project_info_meta_table(pmo), "project_info")
  expect_error(pmo_export_targeted_genomes_meta_table(pmo), "targeted_genomes")
  expect_error(pmo_export_bioinformatics_run_info_meta_table(pmo),
               "bioinformatics_run_info")
  # BED extraction needs targeted_genomes
  expect_error(pmo_extract_targets_insert_bed(pmo), "targeted_genomes")
})

test_that("Excel export works on the minimum PMO (only present sheets)", {
  tmp <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp), add = TRUE)
  pmo_export_to_excel(minimum_pmo(), tmp)
  sheets <- openxlsx::getSheetNames(tmp)
  expect_true("PMO Header" %in% sheets)
  expect_false("Optional GenomeInfo" %in% sheets)
  expect_false("Optional SequencingInfo" %in% sheets)
})
