# path_gpkg <- "~/Projects/gis/restoration_wedzin_kwa/background_layers.gpkg"
# mask <- sf::st_read(
#   path_gpkg,
#   layer = "whse_basemapping.fwa_watershed_groups_poly"
# )
# get_this <- c("whse_basemapping.bcgs_5k_grid", "WHSE_BASEMAPPING.BCGS_2500_GRID")
# name_this <- c("test", "test2")
# purrr::walk2(
#   .x = get_this,
#   .y = name_this,
#   .f = ~rfp_source_bcdata(
#     bcdata_record_id = .x,
#     path_gpkg = path_gpkg,
#     layer_name = .y,
#     mask = mask
#   )
# )
#
# rfp_source_bcdata(
#   bcdata_record_id = bcdata_record_id,
#   path_gpkg = path_gpkg,
#   mask = mask,
#   layer_name = "test"
# )
#
# layers <- ngr::ngr_spk_layer_info(path_gpkg)
#
# bcdata_record_id <- stringr::str_to_lower("WHSE_BASEMAPPING.BCGS_2500_GRID")
#
# t2 |>
#   mapview::mapview()
#
# purrr::map(name_this, ~ gdalraster::ogr_layer_delete(path_gpkg, .x))
#
# gdalraster::ogr_layer_delete(path_gpkg, "test")
