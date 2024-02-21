#' Load bcdata layers to a geopackage.
#'
#' This function loads bcdata layers to a `background_layers.gpkg` with the specified watershed groups. The update
#' option can be set to update an existing geopackage if it exists.
#'
#' @param watershed_groups A character vector of watershed group codes. Double quoted list of single quoted values. Default is NULL.
#' @param update A logical indicating whether to update the GeoPackage file. Default is FALSE.
#'
#' @return Invisible NULL. The function is called for its side effects.
#' @importFrom reticulate use_condaenv
#' @export
#'
#' @examples
#' \dontrun{
#' rfp_source_bcdata(watershed_groups = c("ADMS", "BULK"))
#' }
rfp_source_bcdata <- function(watershed_groups = NULL, update = FALSE) {
  # Construct the path to the script within the installed package
  scriptPath <- system.file("extdata", "rfp_source_bcdata.sh", package = "rfp")

  # Check if the script exists to avoid errors
  if(!file.exists(scriptPath)) {
    stop("Script 'rfp_source_bcdata.sh' not found in the package.")
  }

  if(update){
    update <-  "update"
  }else{
    update <- ""
  }

  # Convert watershed_groups to a single, comma-separated string
  watershed_groups <- paste(shQuote(watershed_groups, type = "sh"), collapse = " ")

  # Prepare the arguments for the script
  args <- c(watershed_groups, update)

  # Call the bash script with arguments
  system2("bash", args = c(scriptPath, watershed_groups, update))

  invisible(NULL)
}



