# Package index

## Package overview

- [`pmotoolsr`](https://plasmogenepi.github.io/pmotoolsr/reference/pmotoolsr-package.md)
  [`pmotoolsr-package`](https://plasmogenepi.github.io/pmotoolsr/reference/pmotoolsr-package.md)
  : pmotoolsr: Toolkit for working with Portable Microhaplotype Objects
  (PMOs)

## Reading & writing PMOs

Read and write Portable Microhaplotype Object files (plain or gzip /
bzip2 / xz compressed), as R6 objects or as raw nested lists.

- [`read_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo.md)
  : Read a PMO object from a file
- [`write_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo.md)
  : Write a PMO object to a file
- [`read_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/read_pmo_raw.md)
  : Read a PMO file as a raw nested list
- [`write_pmo_raw()`](https://plasmogenepi.github.io/pmotoolsr/reference/write_pmo_raw.md)
  : Write a raw PMO nested list to a file
- [`pmo_list_to_r6()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_list_to_r6.md)
  : Convert a raw PMO list into a PortableMicrohaplotypeObject

## Validation & schema

Validate a PMO against the JSON Schema and inspect schema versions and
field requirements.

- [`pmo_validate()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate.md)
  : Validate a PMO (structural and, by default, schema)
- [`pmo_validate_jsonschema()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_validate_jsonschema.md)
  : Validate a PMO against the JSON Schema
- [`pmo_check_required_base_fields()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_check_required_base_fields.md)
  : Check that a PMO has all required top-level fields
- [`pmo_required_fields_for_class()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_required_fields_for_class.md)
  : Get the required fields for a PMO schema class
- [`pmo_load_schema()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_load_schema.md)
  : Load a bundled PMO JSON schema
- [`pmo_load_schema_by_version()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_load_schema_by_version.md)
  : Load a bundled PMO JSON schema by version
- [`pmo_schema_version()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_schema_version.md)
  : Default PMO schema version targeted by this package
- [`pmo_has_section()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_has_section.md)
  : Test whether an optional PMO section is present and non-empty

## Processing & querying

Look up names and indices, count entities, and subset / filter a PMO
down to selected specimens, library samples, targets, metadata groups,
or read depth.

- [`pmo_get_specimen_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_sorted_specimen_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_library_sample_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_sorted_library_sample_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_target_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_sorted_target_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_panel_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_sorted_panel_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_bioinformatics_run_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  [`pmo_get_sorted_bioinformatics_run_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_get_names.md)
  : Get entity names from a PMO
- [`pmo_index_key_specimen_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_key.md)
  [`pmo_index_key_library_sample_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_key.md)
  [`pmo_index_key_target_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_key.md)
  [`pmo_index_key_panel_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_key.md)
  [`pmo_index_key_bioinformatics_run_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_key.md)
  : Build a name-to-index lookup for PMO entities
- [`pmo_index_key_target_in_representative_microhaplotypes()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_key_target_in_representative_microhaplotypes.md)
  : Build a target-name to representative-microhaplotype-index lookup
- [`pmo_index_of_specimen_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_of.md)
  [`pmo_index_of_library_sample_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_of.md)
  [`pmo_index_of_target_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_of.md)
  [`pmo_index_of_panel_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_of.md)
  [`pmo_index_of_bioinformatics_run_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_of.md)
  [`pmo_index_of_target_in_representative_microhaplotypes()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_index_of.md)
  : Resolve entity names to their 1-based PMO indices
- [`pmo_library_ids_for_specimen_ids()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_library_ids_for_specimen_ids.md)
  : Get library sample ids for a set of specimen ids
- [`pmo_count_library_samples_per_target()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_count_library_samples_per_target.md)
  : Count the number of library samples a target is detected in
- [`pmo_count_specimen_by_field_value()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_count_specimen_by_field_value.md)
  : Count specimens grouped by combinations of metadata field values
- [`pmo_count_specimen_per_meta_fields()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_count_specimen_per_meta_fields.md)
  : Count how many specimens carry each metadata field
- [`pmo_count_targets_per_library_sample()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_count_targets_per_library_sample.md)
  : Count the number of targets detected per library sample
- [`pmo_count_targets_per_panel()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_count_targets_per_panel.md)
  : Count the number of unique targets in each panel
- [`pmo_filter_by_library_sample_ids()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_filter_by_library_sample_ids.md)
  : Filter a PMO down to selected library samples
- [`pmo_filter_by_library_sample_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_filter_by_library_sample_names.md)
  : Filter a PMO down to selected library samples by name
- [`pmo_filter_by_specimen_ids()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_filter_by_specimen_ids.md)
  : Filter a PMO down to selected specimens
- [`pmo_filter_by_specimen_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_filter_by_specimen_names.md)
  : Filter a PMO down to selected specimens by name
- [`pmo_filter_by_target_ids()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_filter_by_target_ids.md)
  : Filter a PMO down to selected targets
- [`pmo_filter_by_target_names()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_filter_by_target_names.md)
  : Filter a PMO down to selected targets by name
- [`pmo_extract_by_read_filter()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_by_read_filter.md)
  : Filter detected microhaplotypes by a minimum read count
- [`pmo_extract_samples_by_meta_groupings()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_samples_by_meta_groupings.md)
  : Extract specimens matching metadata groupings
- [`pmo_extract_allele_counts_freq()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_allele_counts_freq.md)
  : Extract allele (microhaplotype) counts and frequencies

## Exporting tables

Flatten PMO sections into tibbles and export allele tables, BED files,
and Excel workbooks.

- [`pmo_export_bioinformatics_methods_info_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_bioinformatics_methods_info_meta_table.md)
  : Export bioinformatics methods info metadata
- [`pmo_export_bioinformatics_run_info_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_bioinformatics_run_info_meta_table.md)
  : Export bioinformatics run info metadata
- [`pmo_export_library_sample_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_library_sample_meta_table.md)
  : Export library sample metadata
- [`pmo_export_panel_info_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_panel_info_meta_table.md)
  : Export panel info metadata
- [`pmo_export_pmo_header_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_pmo_header_table.md)
  : Export PMO header metadata
- [`pmo_export_project_info_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_project_info_meta_table.md)
  : Export project info metadata
- [`pmo_export_sequencing_info_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_sequencing_info_meta_table.md)
  : Export sequencing info metadata
- [`pmo_export_specimen_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_specimen_meta_table.md)
  : Export specimen metadata
- [`pmo_export_specimen_travel_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_specimen_travel_meta_table.md)
  : Export specimen travel metadata
- [`pmo_export_target_info_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_target_info_meta_table.md)
  : Export target info metadata
- [`pmo_export_targeted_genomes_meta_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_targeted_genomes_meta_table.md)
  : Export targeted genomes metadata
- [`pmo_export_to_excel()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_export_to_excel.md)
  : Export a PMO to a multi-sheet Excel workbook
- [`pmo_extract_alleles_per_sample_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_alleles_per_sample_table.md)
  : Extract a per-sample allele table
- [`pmo_list_library_samples_per_specimen()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_list_library_samples_per_specimen.md)
  : List library sample names per specimen
- [`pmo_extract_targets_insert_bed()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_targets_insert_bed.md)
  : Extract target insert locations as BED rows
- [`pmo_extract_panels_insert_bed()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_extract_panels_insert_bed.md)
  : Extract panel insert locations as BED rows
- [`pmo_write_bed()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_write_bed.md)
  : Write BED rows to a file

## Building & combining PMOs

Assemble PMOs from tabular inputs, merge components into a single
object, update metadata, and combine multiple PMOs.

- [`pmo_library_sample_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_library_sample_info_table_to_pmo.md)
  : Convert a library-sample metadata table into PMO library_sample_info
- [`pmo_mhap_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_mhap_table_to_pmo.md)
  : Convert a microhaplotype calls table into PMO microhaplotype
  structures
- [`pmo_panel_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_panel_info_table_to_pmo.md)
  : Convert a panel/target table into PMO target_info + panel_info
- [`pmo_read_count_by_stage_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_read_count_by_stage_table_to_pmo.md)
  : Convert read-count tables into the PMO read_counts_by_stage
  structure
- [`pmo_specimen_info_table_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_specimen_info_table_to_pmo.md)
  : Convert a specimen metadata table into PMO specimen_info
- [`pmo_minimum_library_specimen_from_mhap_table()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_minimum_library_specimen_from_mhap_table.md)
  : Build minimal library/specimen info from a detected-microhaplotypes
  structure
- [`pmo_merge_panel_info_dicts()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_panel_info_dicts.md)
  : Merge multiple panel_info dictionaries
- [`pmo_merge_to_pmo()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_to_pmo.md)
  : Merge name-based PMO components into a complete PMO
- [`pmo_combine_pmos()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_combine_pmos.md)
  : Combine multiple PMOs into a single PMO
- [`pmo_update_specimen_with_traveler_info()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_update_specimen_with_traveler_info.md)
  : Add travel history to a PMO's specimens
- [`pmo_merge_dicts_by_key()`](https://plasmogenepi.github.io/pmotoolsr/reference/pmo_merge_dicts_by_key.md)
  : Merge two lists of dicts by a shared key field

## PMO classes

Auto-generated R6 classes mirroring the PMO schema. Most users interact
with these through read_pmo() / write_pmo() rather than constructing
them directly.

- [`PortableMicrohaplotypeObject`](https://plasmogenepi.github.io/pmotoolsr/reference/PortableMicrohaplotypeObject.md)
  : PortableMicrohaplotypeObject
- [`BioMethod`](https://plasmogenepi.github.io/pmotoolsr/reference/BioMethod.md)
  : BioMethod
- [`BioinformaticsMethodInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/BioinformaticsMethodInfo.md)
  : BioinformaticsMethodInfo
- [`BioinformaticsRunInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/BioinformaticsRunInfo.md)
  : BioinformaticsRunInfo
- [`DetectedMicrohaplotypes`](https://plasmogenepi.github.io/pmotoolsr/reference/DetectedMicrohaplotypes.md)
  : DetectedMicrohaplotypes
- [`DetectedMicrohaplotypesForSample`](https://plasmogenepi.github.io/pmotoolsr/reference/DetectedMicrohaplotypesForSample.md)
  : DetectedMicrohaplotypesForSample
- [`DetectedMicrohaplotypesForTarget`](https://plasmogenepi.github.io/pmotoolsr/reference/DetectedMicrohaplotypesForTarget.md)
  : DetectedMicrohaplotypesForTarget
- [`GenomeInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/GenomeInfo.md)
  : GenomeInfo
- [`GenomicLocation`](https://plasmogenepi.github.io/pmotoolsr/reference/GenomicLocation.md)
  : GenomicLocation
- [`LibrarySampleInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/LibrarySampleInfo.md)
  : LibrarySampleInfo
- [`MarkerOfInterest`](https://plasmogenepi.github.io/pmotoolsr/reference/MarkerOfInterest.md)
  : MarkerOfInterest
- [`MaskingInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/MaskingInfo.md)
  : MaskingInfo
- [`MicrohaplotypeForTarget`](https://plasmogenepi.github.io/pmotoolsr/reference/MicrohaplotypeForTarget.md)
  : MicrohaplotypeForTarget
- [`PanelInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/PanelInfo.md)
  : PanelInfo
- [`ParasiteDensity`](https://plasmogenepi.github.io/pmotoolsr/reference/ParasiteDensity.md)
  : ParasiteDensity
- [`PlateInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/PlateInfo.md)
  : PlateInfo
- [`PmoGenerationMethod`](https://plasmogenepi.github.io/pmotoolsr/reference/PmoGenerationMethod.md)
  : PmoGenerationMethod
- [`PmoHeader`](https://plasmogenepi.github.io/pmotoolsr/reference/PmoHeader.md)
  : PmoHeader
- [`PrimerInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/PrimerInfo.md)
  : PrimerInfo
- [`ProjectInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/ProjectInfo.md)
  : ProjectInfo
- [`ProteinVariant`](https://plasmogenepi.github.io/pmotoolsr/reference/ProteinVariant.md)
  : ProteinVariant
- [`Pseudocigar`](https://plasmogenepi.github.io/pmotoolsr/reference/Pseudocigar.md)
  : Pseudocigar
- [`ReactionInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/ReactionInfo.md)
  : ReactionInfo
- [`ReadCountsByStage`](https://plasmogenepi.github.io/pmotoolsr/reference/ReadCountsByStage.md)
  : ReadCountsByStage
- [`ReadCountsByStageForLibrarySample`](https://plasmogenepi.github.io/pmotoolsr/reference/ReadCountsByStageForLibrarySample.md)
  : ReadCountsByStageForLibrarySample
- [`ReadCountsByStageForTarget`](https://plasmogenepi.github.io/pmotoolsr/reference/ReadCountsByStageForTarget.md)
  : ReadCountsByStageForTarget
- [`RepresentativeMicrohaplotype`](https://plasmogenepi.github.io/pmotoolsr/reference/RepresentativeMicrohaplotype.md)
  : RepresentativeMicrohaplotype
- [`RepresentativeMicrohaplotypes`](https://plasmogenepi.github.io/pmotoolsr/reference/RepresentativeMicrohaplotypes.md)
  : RepresentativeMicrohaplotypes
- [`RepresentativeMicrohaplotypesForTarget`](https://plasmogenepi.github.io/pmotoolsr/reference/RepresentativeMicrohaplotypesForTarget.md)
  : RepresentativeMicrohaplotypesForTarget
- [`SequencingInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/SequencingInfo.md)
  : SequencingInfo
- [`SpecimenInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/SpecimenInfo.md)
  : SpecimenInfo
- [`StageReadCounts`](https://plasmogenepi.github.io/pmotoolsr/reference/StageReadCounts.md)
  : StageReadCounts
- [`TargetInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/TargetInfo.md)
  : TargetInfo
- [`TravelInfo`](https://plasmogenepi.github.io/pmotoolsr/reference/TravelInfo.md)
  : TravelInfo
