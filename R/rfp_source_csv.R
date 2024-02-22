#' Download and Convert CSVs to GeoPackage Layers
#'
#' This function downloads CSV files from specified URLs and converts them into layers
#' within a GeoPackage using the `ogr2ogr` command-line tool from GDAL.
#'
#' @param path_gpkg A string specifying the path to the output GeoPackage file.
#' @param urls_csv A character vector of URLs pointing to the CSV files to be downloaded and converted.
#' @return Invisible NULL. This function is called for its side effects.
#' @examples \dontrun{
#' path_gpkg <- "background_layers.gpkg"
#' urls_csv <- c(
#'   "https://raw.githubusercontent.com/smnorris/bcfishpass/main/parameters/example_newgraph/parameters_habitat_method.csv",
#'   "https://raw.githubusercontent.com/smnorris/bcfishpass/main/parameters/example_newgraph/parameters_habitat_thresholds.csv"
#' )
#' rfp_source_csv(path_gpkg, urls_csv)
#' }
#' @export
#' @family source
rfp_source_csv <- function(path_gpkg, urls_csv) {
  if (system("which ogr2ogr", ignore.stdout = TRUE, ignore.stderr = TRUE) != 0) {
    stop("ogr2ogr is not available. Please install GDAL.")
  }
  chk::chk_string(path_gpkg)
  chk::chk_file(path_gpkg)
  chk::chk_character(urls_csv)

  for (csv_url in urls_csv) {
    layer_name <- tools::file_path_sans_ext(basename(csv_url))

    command <- "ogr2ogr"
    args <- c(
      "-f", "GPKG",
      path_gpkg,
      "-update",
      "-overwrite",
      "-nln", layer_name,
      paste0("/vsicurl/", csv_url)
    )

    system2(command, args = args, stdout = TRUE, stderr = TRUE)
  }

  invisible(NULL)
}


