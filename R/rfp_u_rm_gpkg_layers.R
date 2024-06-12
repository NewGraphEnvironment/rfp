#' Remove Specified Layers from a GeoPackage
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' `rfp_u_rm_gpkg_layers()` has been superseded in favour of [gdalraster::ogr_layer_delete()](https://github.com/USDAForestService/gdalraster)
#'
#' This function removes specified layers from a GeoPackage by listing all layers
#' using `sf::st_layers`, then recreating the GeoPackage without the specified layers
#' using `ogr2ogr` commands executed via `system2`.
#'
#' @param path_gpkg A string specifying the path to the GeoPackage file.
#' @param layers_remove A character vector naming the layers to be removed from the GeoPackage.
#'
#' @return Invisible NULL, indicating the function is used for its side effects.
#' @examples
#' \dontrun{
#'   path_gpkg <- "path/to/your.gpkg"
#'   layers_remove <- c("layer_to_remove1", "layer_to_remove2")
#'   rfp_u_rm_gpkg_layers(path_gpkg, layers_remove)
#' }
#' @importFrom sf st_layers
#' @importFrom chk chk_string chk_file chk_character
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @family utils
rfp_u_rm_gpkg_layers <- function(path_gpkg, layers_remove) {
  # ensure that gdal is installed
  if (system2("which", args = "ogr2ogr", stdout = FALSE, stderr = FALSE) != 0) {
    cli::cli_abort("The `ogr2ogr` function requires GDAL. Please install GDAL first.\nYou can install GDAL on a Mac using Homebrew")
  }

  chk::chk_string(path_gpkg)
  chk::chk_file(path_gpkg)
  chk::chk_character(layers_remove)

  # List all layers in the GeoPackage
  all_layers <- sf::st_layers(path_gpkg)$name

  # Check if each layer to be removed exists in the GeoPackage
  for (layer in layers_remove) {
    if (!layer %in% all_layers) {
      # Construct and display the abort message using 'glue' and 'cli::abort'
      message <- glue::glue("The layer '{layer}' does not exist in the GeoPackage '{path_gpkg}'.")
      cli::cli_abort(message)
    }
  }

  # Determine the layers to keep (i.e., all layers not in layers_remove)
  layers_keep <- setdiff(all_layers, layers_remove)

  if (length(layers_keep) == 0) {
    stop("No layers left to keep in the GeoPackage.")
  }

  # Temporary GeoPackage path
  temp_gpkg <- tempfile(fileext = ".gpkg")

  # Use ogr2ogr to copy each layer to be kept to the temporary GeoPackage
  for (layer in layers_keep) {
    command <- "ogr2ogr"
    args <- c("-f", "GPKG", temp_gpkg, path_gpkg, layer, "-nln", layer, "-update", "-append")
    system2(command, args = args, stdout = TRUE, stderr = TRUE)
  }

  # Overwrite the original GeoPackage with the temporary one
  file.copy(temp_gpkg, path_gpkg, overwrite = TRUE)

  # Clean up the temporary file
  unlink(temp_gpkg)

  invisible(NULL)
}

