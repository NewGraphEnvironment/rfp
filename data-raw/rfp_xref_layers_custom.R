
#' This is a table that cross references the names of the layers in GIS projects with metadata about where they come
#' from and what they represent. Layers include `rfp_tracking`, [bcfishpass](https://github.com/smnorris/bcfishpass) (bcfishpass schema and modelling input parameters)
#' and [bcfishobs](https://github.com/smnorris/bcfishobs) output layers.
#' @name rfp_xref_layers_custom
#' @docType data
#' @author Al Irvine \email{al@newgraphenvironment.com}
#' @keywords data
rfp_xref_layers_custom <- readr::read_csv("inst/extdata/rfp_xref_layers_custom.csv")


usethis::use_data(rfp_xref_layers_custom, overwrite = TRUE)
