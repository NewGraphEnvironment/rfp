#' Create a table that cross references the package name with the object_name.
#'
#'
#' Helper function used in /link{rfp_meta_bcd_xref} to drill down through each package to get the object_name from the
#' resource_df using a row index gathered by rfp_meta_bcd_xref. This is used to apply the row index of the row that
#' contains the wms resource within the package as there are other datasets within the same package and we want the
#' schema.table for a dataset downloaded from the wms service.
#'
#' @param pkg_name A character string specifying the package name.
#' @param pkg_list A list of complete metadata by package.
#' @param row_idx A numeric value specifying the row index.
#'
#' @return A tibble with columns object_name and package_name.
#' @importFrom purrr pluck
#' @importFrom tibble tibble
#' @family meta bcdata
rfp_meta_bcd_xref_pkg_schtab <- function(pkg_list = NULL, pkg_name = NULL, row_idx = NULL){
  ob_name <- pkg_list %>%
    purrr::pluck(pkg_name) %>%
    purrr::pluck("resources") %>%
    purrr::pluck(row_idx) %>%
    purrr::pluck("object_name")

  # turn into a tibble and add the package name
  tibble::tibble(object_name = ob_name, package_name = pkg_name)
}
