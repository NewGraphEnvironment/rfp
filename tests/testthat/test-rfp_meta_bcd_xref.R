test_that("Default function runs", {
  # we get warnings because there are NAs in our object names because not all wms available packges have object names
  result <- suppressWarnings(rfp_meta_bcd_xref())
  expect_false(is.null(result))
})
