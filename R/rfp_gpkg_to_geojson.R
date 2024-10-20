
#' Convert all layers in a GeoPackage to GeoJSON files
#'
#' This function reads layers from a GeoPackage file and writes them as GeoJSON files.
#' We use geojsons to make the mapping convenient as they update automagically in QGIS without a restart and b/c
#' when in wsg84 they display by default on github and other web platforms
#'
#' @param dir_in A character string representing the directory where the GeoPackage is located. Default is "~/test".
#' @param dir_out A character string representing the directory where the GeoJSON files will be saved. Default is "~/test".
#' @param file_name_in A character string for the name of the GeoPackage file (without extension). Default is "gps_2024".
#' @importFrom sf st_read st_layers st_write
#' @importFrom dplyr mutate
#' @importFrom purrr map set_names
#' @importFrom fs path
#' @export
rfp_gpkg_to_geojson <- function(dir_in = "~/test",
                                dir_out = "~/test",
                                file_name_in = "gps_2024") {

  # Validate inputs
  chk::chk_string(dir_in)
  chk::check_dirs(dir_in)
  chk::chk_string(dir_out)
  chk::chk_string(file_name_in)

  # create output directory
  fs::dir_create(dir_out)

  # Construct full paths using fs::path
  gpkg_path <- fs::path(dir_in, paste0(file_name_in, ".gpkg"))

  # Read layer names from the GeoPackage
  layer_names <- sf::st_layers(gpkg_path) |>
    purrr::pluck("name")

  # Function to read a layer from the GeoPackage
  read_gpkg <- function(layer) {
    sf::st_read(dsn = gpkg_path, layer = layer)
      # dplyr::mutate(name = layer)
  }

  # Grab the layers and give them a name
  layers_to_burn <- layer_names |>
    purrr::map(read_gpkg) |>
    purrr::set_names(nm = layer_names)

  # Function to write GeoJSON files
  write_geojson <- function(layer, layer_name) {
    # Construct the file name using fs::path
    file_name <- fs::path(dir_out, paste0(layer_name, ".geojson"))

    # Write the GeoJSON file
    sf::st_write(layer, dsn = file_name, delete_dsn = TRUE)
  }

  # Write all layers to GeoJSON
  layers_to_burn |>
    purrr::walk2(layer_names, write_geojson)
}

