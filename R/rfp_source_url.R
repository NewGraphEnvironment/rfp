#' Download and Convert Files to GeoPackage Layers with Optional Filtering
#'
#' This function downloads files from specified URLs and converts them into layers
#' within a GeoPackage using the `ogr2ogr` command-line tool from GDAL. It optionally
#' applies an SQL filter to the data during conversion if a query is specified.
#'
#' @param path_gpkg A string specifying the path to the output GeoPackage file.
#' @param urls A character vector of URLs pointing to the files to be downloaded and converted.
#' @param query An optional SQL query string to filter the data during the conversion process.
#' If NULL (default), no filter is applied.
#' @return Invisible NULL. This function is called for its side effects.
#' @examples
#' \dontrun{
#' path_gpkg <- "background_layers.gpkg"
#' urls <- c(
#'   "https://newgraph.s3.us-west-2.amazonaws.com/bcfishpass.crossings_vw.fgb",
#'   "https://raw.githubusercontent.com/smnorris/bcfishpass/main/parameters/example_newgraph/parameters_habitat_thresholds.csv"
#' )
#' query <- "watershed_group_code in ('ADMS', 'KLUM')"
#' rfp_source_url(path_gpkg, urls, query)
#' }
#' @export
#' @family source ogr2ogr gpkg
#' @importFrom chk chk_string chk_file chk_character
#' @importFrom tools file_path_sans_ext
rfp_source_url <- function(path_gpkg, urls, query = NULL) {
  if (system("which ogr2ogr", ignore.stdout = TRUE, ignore.stderr = TRUE) != 0) {
    stop("ogr2ogr is not available. Please install GDAL.")
  }

  chk::chk_string(path_gpkg)
  chk::chk_file(path_gpkg)
  chk::chk_character(urls)
  if (!is.null(query)) {
    chk::chk_string(query) # Ensure the query is a string
  }

  for (url in urls) {
    layer_name <- tools::file_path_sans_ext(basename(url))

    args <- c(
      "ogr2ogr",
      "-f", "GPKG",
      path_gpkg,
      "-update",
      "-overwrite",
      "-nln", layer_name
    )

    if (!is.null(query)) {
      args <- c(args, "-where", shQuote(query))
    }

    args <- c(args, paste0("/vsicurl/", url))

    system2(args[1], args = args[-1], stdout = TRUE, stderr = TRUE)
  }

  invisible(NULL)
}






