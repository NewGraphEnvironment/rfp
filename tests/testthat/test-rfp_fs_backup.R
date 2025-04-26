test_that("rfp_fs_backup works with default stamp and correct format", {
  path_dir_in <- system.file("extdata", package = "rfp")
  path_in_file <- "rfp_xref_layers_custom.csv"
  path_dir_out <- tempfile()

  result_path <- rfp_fs_backup(path_dir_in, path_in_file, path_dir_out)

  expect_true(fs::file_exists(result_path))
  expect_true(grepl("^rfp_xref_layers_custom_\\d{12}\\.csv$", fs::path_file(result_path)))
})

test_that("rfp_fs_backup works with NULL stamp and correct format", {
  path_dir_in <- system.file("extdata", package = "rfp")
  path_in_file <- "rfp_xref_layers_custom.csv"
  path_dir_out <- tempfile()

  result_path <- rfp_fs_backup(path_dir_in, path_in_file, path_dir_out, stamp = NULL)

  expect_true(fs::file_exists(result_path))
  expect_identical(fs::path_file(result_path), "rfp_xref_layers_custom.csv")
})

