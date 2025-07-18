#' Download and Save BC Data to GPKG
#'
#' Downloads a layer from the BC Data Catalogue, optionally intersects with a mask, and writes it to a GeoPackage.
#'
#' @param bcdata_record_id [character] A character string specifying the BC Data Catalogue record ID permanent id (7ecfafa6-5e18-48cd-8d9b-eae5b5ea2881),
#' name of the record (pscis-assessments) or `object name` (ex. WHSE_FISH.PSCIS_ASSESSMENT_SVW).  The name of the record
#' can be found at https://catalogue.data.gov.bc.ca/.  This does not need to be in capitals as we will convert to capitals
#' within the function.
#' @param path_gpkg [character] Path to the output GeoPackage file.
#' @param mask [sf] Optional masking polygon to clip spatial extent. Can massively increase download speed as first queries only bbox from api.
#' @param layer_name [character] Optional layer name for writing to the GPKG. If NULL - the name of the layer defaults to `bcdata_record_id` as all lower case.
#' Designed to work best with object name fed to `bcdata_record_id`.
#'
#' @importFrom bcdata bcdc_query_geodata collect filter INTERSECTS
#' @importFrom sf st_transform st_intersection st_write
#' @importFrom stringr str_to_lower
#' @importFrom chk chk_string chk_file
#' @export
#' @examples
#' \dontrun{
#' path_gpkg <- "~/Projects/gis/restoration_wedzin_kwa/background_layers.gpkg"
#' mask <- sf::st_read(
#'   path_gpkg,
#'   layer = "whse_basemapping.fwa_watershed_groups_poly"
#' )
#' get_this <- c("whse_basemapping.bcgs_5k_grid", "WHSE_BASEMAPPING.BCGS_2500_GRID")
#' name_this <- c("test", "test2")
#' purrr::walk2(
#'   .x = get_this,
#'   .y = name_this,
#'   .f = ~rfp_source_bcdata(
#'     bcdata_record_id = .x,
#'     path_gpkg = path_gpkg,
#'     layer_name = .y,
#'     mask = mask
#'   )
#' )
#' }
rfp_source_bcdata <- function(
    bcdata_record_id = NULL,
    path_gpkg = NULL,
    mask = NULL,
    layer_name = NULL
){
  chk::chk_string(bcdata_record_id)
  chk::chk_file(path_gpkg)
  if (!is.null(layer_name)) {
    chk::chk_string(layer_name)
  }
  bcdata_record_id <- stringr::str_to_upper(bcdata_record_id)

  if (!is.null(mask)) {
    mask <- mask |>
      sf::st_geometry() |>
      sf::st_transform(crs = 3005)
    l <- bcdata::bcdc_query_geodata(bcdata_record_id) |>
      bcdata::filter(bcdata::INTERSECTS(mask)) |>
      bcdata::collect() |>
      sf::st_intersection(mask)
  } else {
    l <- bcdata::bcdc_query_geodata(bcdata_record_id) |>
      bcdata::collect()
  }

  if (is.null(layer_name)) {
    layer_name <- bcdata_record_id
  }

  l |>
    sf::st_write(
      dsn = path_gpkg,
      layer = stringr::str_to_lower(layer_name),
      delete_layer = TRUE
    )
}
