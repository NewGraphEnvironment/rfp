#' Function to create a lookup table for BC Data Catalogue
#'
#' @param pkg_exclude A character vector specifying the packages to exclude. Default is c("bc-web-map-library").
#' This package name is associated with several datasets that do not have wms download capabilities.
#' @return A data frame with columns object_name, package_name, url_browser, description, id_package, id_dataset, url_download.
#' @importFrom purrr map_df map2_df map pluck map_lgl
#' @importFrom dplyr mutate filter select left_join count group_by bind_rows row_number ungroup n
#' @importFrom stringr str_to_lower
#' @importFrom cli cli_alert_danger
#' @importFrom bcdata bcdc_search
#' @family meta bcdata
#' @export
#'
#' @examples
#' \dontrun{
#'   lookup_table <- rfp_meta_bcd_xref()
#'   head(lookup_table)
#' }
rfp_meta_bcd_xref <- function(
    pkg_exclude = c("bc-web-map-library")){

  # start with a list of packages that has wms capabilities...
  l_raw <- bcdata::bcdc_search(res_format = "wms", n = 10000)

  l <- l_raw[!(names(l_raw) %in% pkg_exclude)]

  # make sure all the packages have a resource_df
  test_resource_df<- all(
    l %>%
      purrr::map(pluck, "resource_df") %>%
      purrr::map_lgl(is.list)
  )

  if (!test_resource_df) {
    cli::cli_alert_danger("Not all data packages contain a list element called 'resource_df'.")
  }

  bcdata_lookup_raw <- l %>%
    purrr::map_df(~ purrr::pluck(.x, "resource_df") %>%
                    dplyr::mutate(object_name_idx = dplyr::row_number()) %>%
                    dplyr::filter(format == "wms"),
                  .id = "package_name") %>%
    dplyr::select(url, id_dataset = id, package_name, object_name_idx)
    # dplyr::filter(!package_name %in% pkg_exclude)

  test_dupes_pkgs <- bcdata_lookup_raw %>%
    dplyr::group_by(package_name) %>%
    dplyr::filter(dplyr::n() > 1)

  # Check if there are any duplicates and print an error message if there are
  if (nrow(test_dupes_pkgs) > 0) {
    cli::cli_alert_danger("There are duplicate package names with details below.")
  }

  object_names <- purrr::map2_df(
    .x = bcdata_lookup_raw$package_name,
    .y = bcdata_lookup_raw$object_name_idx,
    .f = ~ rfp_meta_bcd_xref_pkg_schtab(pkg_list = l, pkg_name = .x, row_idx = .y)
  ) %>%
    dplyr::mutate(object_name = stringr::str_to_lower(object_name))


  # get the id_package for each package so we can join
  id_description <- l %>%
    purrr::map(~ list(id_package = purrr::pluck(.x, "id"), description = purrr::pluck(.x, "notes"))) %>%
    dplyr::bind_rows(.id = "package_name")

  # now join our object names to the bcdata_lookup_raw and reorder columns to have object name then package name
  bcdata_lookup <-  dplyr::left_join(
    dplyr::left_join(
      bcdata_lookup_raw,
      object_names,
      by = "package_name"
    ),
    id_description,
    by = "package_name"
  ) %>%
    dplyr::mutate(url_browser = paste0("https://catalogue.data.gov.bc.ca/dataset/", id_package)) %>%
    dplyr::select(object_name, package_name, url_browser, description, id_package, id_dataset, url_download = url)

  if (nrow(test_dupes_pkgs) > 0) {
  dupes <- test_dupes_pkgs %>%
    dplyr::ungroup() %>%
    dplyr::select(package_name) %>%
    dplyr::distinct()


  test_dupes_warn <- bcdata_lookup %>%
    filter(package_name %in% dupes$package_name)

  print(test_dupes_warn)
  }

  return(bcdata_lookup)
}

