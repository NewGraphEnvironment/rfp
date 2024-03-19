#' rfp_meta_bcd_xref_col_comments
#'
#' Check if a given schema_table and column exist in the BC Data Catalogue WMS service.
#' If they exist, it returns a dataframe with information about the column.
#'
#' @param schema_table A string. The name of the schema_table to check.
#' @param column A string. The name of the column to check.
#'
#' @importFrom chk chk_string
#' @importFrom stringr str_to_upper str_to_lower
#' @importFrom dplyr mutate filter select
#' @importFrom cli cli_abort cli_alert_danger
#' @importFrom bcdata bcdc_describe_feature
#'
#' @return A tibble with information about the column if it exists. Information included is the character value of
#' schema_table provided, the column name, the R column type, and the column comments.
#' @family meta bcdata
#' @export
#'
#' @examples
#' \dontrun{
#' rfp_meta_bcd_xref_col_comments("whse_imagery_and_base_maps.gsr_airports_svw", "airport_name")
#' }
rfp_meta_bcd_xref_col_comments <- function(schema_table, column){

  chk::chk_string(schema_table)
  chk::chk_string(column)

  # give informative warning if schema_table doesn't match
  tryCatch({
    bcdata::bcdc_describe_feature(stringr::str_to_upper(schema_table))
  }, error = function(e) {
    cli::cli_abort("The object name {schema_table} does not exist in the BC Data Catalogue WMS service!")
  })

  d <- bcdata::bcdc_describe_feature(stringr::str_to_upper(schema_table)) %>%
    dplyr::mutate(col_name = stringr::str_to_lower(col_name))

  # warn if the column doesn't exist in the table
  if(!column %in% d$col_name){
    cli::cli_alert_danger(paste0("Column ", column, " does not exist in table ", schema_table))
  }

  d %>%
    dplyr::filter(col_name == column) %>%
    dplyr::mutate(object_name = schema_table) %>%
    dplyr::select(object_name, col_name, col_type_local = local_col_type, col_comments = column_comments)
}
