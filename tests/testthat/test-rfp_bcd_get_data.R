
test_that("Incorrect record match produces error still", {
  expect_error(
    rfp_bcd_get_data(bcdata_record_id = "no-record-match")
  )
})

test_that("returns result when col_filter and col_filter_value provided", {
  expect_s3_class(
    rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_filter = 'AIRPORT_NAME',
                    col_filter_value = "Duncan Airport"),
    "data.frame")
})


test_that("can provide lower case schema.table", {
  expect_s3_class(
    rfp_bcd_get_data(bcdata_record_id = "whse_imagery_and_base_maps.gsr_airports_svw", col_filter = 'AIRPORT_NAME',
                     col_filter_value = "Duncan Airport"),
    "data.frame")
})

test_that("can provide upper case schema.table", {
  expect_s3_class(
    rfp_bcd_get_data(bcdata_record_id = "WHSE_IMAGERY_AND_BASE_MAPS.GSR_AIRPORTS_SVW", col_filter = 'AIRPORT_NAME',
                     col_filter_value = "Duncan Airport"),
    "data.frame")
})


test_that("returns error when col_filter_value provided not present", {
  expect_error(
    rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_filter = 'AIRPORT_NAME',
                    col_filter_value = "wrong value"))
})


test_that("col_filter given but no col_filter_value fails", {
  expect_error(
    rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_filter = "AIRPORT_NAME")
  )
})

test_that("we get the right number of columns", {
  expect_equal(
    ncol(rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_extract = c('AIRPORT_NAME', 'DESCRIPTION'))),
         3)
})

test_that("we get the right number of columns when geoom dropped", {
  expect_equal(
    ncol(rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_extract = c('AIRPORT_NAME', 'DESCRIPTION'), drop_geom = TRUE)),
    2)
})

# this one is maybe not necessary becasue it is caught by dplyr::all_of?
test_that("fails if col_extract value does not match", {
  expect_error(
    rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_extract = c('wrong value'))
  )
})

