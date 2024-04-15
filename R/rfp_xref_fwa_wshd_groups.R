#' Table used to crosswalk freshwater atlas watershed group codes and watershed group names
#'
#' @description
#'
#' Table that can be used to reliably get names of watershed groups from codes or the other way around.
#' Updateing procedures are documented in the `data-raw` directory.
#'
#' @format ## `rfp_xref_fwa_wshd_groups`
#' A data frame with 246 rows and 2 columns:
#' \describe{
#'   \item{watershed_group_code}{The four character watershed group code, e.g. ADMS (Adams River), ALBN (Alberni Inlet).}
#'   ...
#' }
#' @source <https://catalogue.data.gov.bc.ca/dataset/freshwater-atlas-watershed-groups/resource/7239c84e-418a-4a9e-97bf-61b166410384>
"rfp_xref_fwa_wshd_groups"
