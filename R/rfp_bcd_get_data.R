#' Convenience wrapper on bcdata::bcdc_query_geodata() and bcdata::collect() to retrieve Web Feature Service data from the BC Data Catalogue.
#'
#' This function queries geospatial data from the BC Data Catalogue using a specified record ID. It conditionally
#' filters the data based on a provided column identifier and value(s),
#' selects specific columns, cleans the column names. Geometry of object returned can be dropped if desired
#' @param bcdata_record_id A character string specifying the BC Data Catalogue record ID permanent id (d0e5c8bc-7874-4c48-9c3e-431f772a250e),
#' name of the record (pscis-assessments) or `object name` (ex. WHSE_FISH.PSCIS_ASSESSMENT_SVW)
#' can be used and can be found at https://catalogue.data.gov.bc.ca/
#' @param col_extract A character vector specifying which columns to select from the data. Cannot be NULL.
#' @param drop_geom A logical value indicating whether to drop the geometry column from the `sf` object. Default is FALSE
#' @param col_filter A character string specifying the column identifier to filter data on.
#' @param col_filter_value A character or character vector specifying the values to filter `col_filter` by.
#' If NULL (default), no filtering on `col_filter` is applied.
#' @return A data frame with cleaned names and optionally an `sf` object.
#' @seealso \code{\link{rfp_meta_bcd_xref}} for a function that extracts metadata from the BC Data Catalogue.
#' @importFrom bcdata bcdc_query_geodata
#' @importFrom dplyr filter select mutate across everything
#' @importFrom janitor clean_names
#' @importFrom sf st_drop_geometry
#' @importFrom glue glue
#' @importFrom chk chk_string chk_character
#' @family source bcdata
#' @examples
#' \dontrun{
#' rfp_bcd_get_data(bcdata_record_id = "d0e5c8bc-7874-4c48-9c3e-431f772a250e",
#' col_filter = 'FUNDING_PROJECT_NUMBER',
#' col_filter_value = 'skeena_2023_Phase1',
#' col_extract = c('EXTERNAL_CROSSING_REFERENCE', 'STREAM_CROSSING_ID'),
#' drop_geom = TRUE)
#' rfp_bcd_get_data(bcdata_record_id = "bc-airports", col_extract = c('AIRPORT_NAME', 'DESCRIPTION')) # Retrieves all records without filtering on col_filter
#' }
#' @export
rfp_bcd_get_data <- function(
    bcdata_record_id,
    col_extract = NULL,
    drop_geom = FALSE,
    col_filter = NULL,
    col_filter_value = NULL
){

  # chk::chk_not_empty(bcdata_record_id)
  chk::chk_string(bcdata_record_id)

  if(!is.null(col_filter)){
    chk::chk_string(col_filter)
  }

  if (!is.null(col_filter_value)) {
    chk::chk_string(col_filter_value)
  }

  if(!is.null(col_extract)){
    chk::chk_character(col_extract)
  }

  # if col_filter given then coli_id_value should not be NULL
  if(!is.null(col_filter) && is.null(col_filter_value)) {
    cli::cli_abort(message = "col_filter_value cannot be NULL when col_filter is provided.")
  }

  # if no col_filter and col_extract given then return all columns of all records
  if(is.null(col_filter) && is.null(col_extract)) {
    x <- bcdata::bcdc_query_geodata(bcdata_record_id) |>
      bcdata::collect()
  }

  # if no col_extract given and col_filter and col_filter_value given return all columns of filtered record
  if(is.null(col_extract) && !is.null(col_filter)) {
    x <- bcdata::bcdc_query_geodata(bcdata_record_id) |>
      dplyr::filter(!!sym(col_filter) %in% col_filter_value) |>
      bcdata::collect()

    if (nrow(x) == 0) {
      cli::cli_abort(glue::glue("No records found. Please check if the `{col_filter}` with the specified value(s)
                              `{col_filter_value}` exists in the BC Data Catalogue or adjust your query."))
    }
  }

  # if col_filter and col_extract given then filter on col_filter and select col_extract
  if(!is.null(col_extract) && !is.null(col_filter)){
    x <- bcdata::bcdc_query_geodata(bcdata_record_id) |>
      dplyr::filter(!!sym(col_filter) %in% col_filter_value) |>
      bcdata::collect() |>
      dplyr::select(all_of(col_extract))


    if (nrow(x) == 0) {
      cli::cli_abort(glue::glue("No records found. Please check if the `{col_filter}` with the specified value(s)
                              `{col_filter_value}` exists in the BC Data Catalogue or adjust your query."))
    }
  }

  # if no col_filter and col_extract given then select col_extract from all records
  if(!is.null(col_extract) && is.null(col_filter)){
    x <- bcdata::bcdc_query_geodata(bcdata_record_id) |>
      # need to select column first or we get a bunch of bcdata columns
      bcdata::collect() |>
      dplyr::select(all_of(col_extract))

    if (nrow(x) == 0) {
      cli::cli_abort(glue::glue("No records found. Please check if the `{col_extract}` with the specified value(s)
                              exists in the BC Data Catalogue table or adjust your query."))
  }
}

x <- x %>%
  janitor::clean_names()

if (drop_geom){
  x <- x %>%
    sf::st_drop_geometry()
}

x
}
