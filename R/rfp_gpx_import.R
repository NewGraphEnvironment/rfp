#' Import GPX Waypoints and Tracks directly from a GPS plugged into a Mac.
#'
#' This function reads GPX files from specified directories, extracts waypoints and tracks,
#' and saves them into specified formats based on provided time filters.
#'
#' The function allows the user to preview all waypoint dates before applying any
#' filters. If `dates_view` is set to TRUE, it will display all dates read from
#' the GPX files without filtering. This is useful for verifying which data to filter
#' will be processed.
#'
#' @param dir_gpx_waypoints A character string specifying the directory containing GPX waypoint files.
#'                           Default is '/Volumes/GARMIN/Garmin/GPX/'.
#' @param dir_gpx_tracks A character vector specifying the directories containing GPX track files.
#'                       Default is c("/Volumes/GARMIN/Garmin/GPX/Archive/", "/Volumes/GARMIN/Garmin/GPX/Current/").
#' @param dir_out A character string specifying the directory to save the output files.
#'                 Default is '~/Library/CloudStorage/OneDrive-Personal/Projects/2024_data/gps'.
#' @param time_start A character string representing the start date for filtering waypoints and tracks based on when the .
#'                   waypoint was created and the END time of each track (if the track was automatically wrapped by the
#'                   gps.  Default is "2024-01-01".
#' @param time_end A character string representing the end date for filtering waypoints and tracks based on when the .
#'                   waypoint was created and the END time of each track (if the track was automatically wrapped by the
#'                   gps. Default is "2099-01-01".
#' @param layer_output_name A character string specifying the name of the layer to export and the string to append to
#'                   each waypoint and track so that name collisions do not occur and to specify surveyor.
#'                   Default is "2024_ai". This is appended to each layer's name (e.g., gps_waypoints_2024_ai.gpx).
#' @param gpkg_name A character string specifying the filename for the GPKG export.
#'                  Default is "gps_2024". This creates a geopackage named gps_2024.gpkg.
#' @param dates_view A logical flag indicating whether to display the filtered waypoint dates
#'                   in a pretty format in the terminal. Default is FALSE. If dates are displayed in the terminal, the
#'                   output files are not generated. This is useful for visualizing options for setting
#'                   time_start and time_end params.
#' @param gpx_layer_type A character vector specifying the types of layers to read from the GPX files.
#'                       Default is c("waypoints", "tracks", "track_points").  "routes" and "route_points" are untested.
#'
#' @importFrom purrr map
#' @importFrom sf st_read st_write
#' @importFrom dplyr bind_rows mutate arrange pull filter
#' @importFrom fs path dir_ls
#' @importFrom cli cli_alert_info cli_abort
#' @importFrom chk chk_string
#' @importFrom lubridate ymd_hms
#'
#' @return None. The function saves the waypoints to specified files and optionally displays the dates.
#' @export
rfp_gpx_import <- function(dir_gpx_waypoints = '/Volumes/GARMIN/Garmin/GPX/',
                           dir_gpx_tracks = c("/Volumes/GARMIN/Garmin/GPX/Archive/", "/Volumes/GARMIN/Garmin/GPX/Current/"),
                           dir_out = "~/Library/CloudStorage/OneDrive-Personal/Projects/2024_data/gps",
                           time_start = "2024-01-01",
                           time_end = "2099-01-01",
                           layer_output_name = "2024_ai",
                           gpkg_name = "gps_2024",
                           dates_view = FALSE,
                           gpx_layer_type = c("waypoints", "tracks", "track_points")) {

  # Validate inputs
  chk::chk_string(dir_gpx_waypoints)
  chk::chk_string(dir_out)
  chk::chk_string(time_start)
  chk::chk_string(time_end)
  chk::chk_string(layer_output_name)
  chk::chk_string(gpkg_name)

  # Validate gpx_layer_type
  valid_layers <- c("waypoints", "tracks", "track_points")
  if (!all(gpx_layer_type %in% valid_layers)) {
    cli::cli_abort("Invalid gpx_layer_type specified. Allowed values are: {paste(valid_layers, collapse = ', ')}")
  }

  # Create dir_out
  fs::dir_create(dir_out)

  # Read all GPX files from the specified directories
  filestoread_waypoints <- list.files(dir_gpx_waypoints,
                                      pattern = '.gpx',
                                      full.names = TRUE)

  filestoread_tracks <- unlist(purrr::map(dir_gpx_tracks, ~ fs::dir_ls(.x, pattern = '.gpx', full.names = TRUE)))

  # Function to process each layer
  process_layer <- function(layer, filestoread) {
    layer_data <- filestoread |>
      purrr::map(sf::st_read, layer = layer, quiet = TRUE) |>
      dplyr::bind_rows()

    # Create the time column if it does not exist
    if (!("time" %in% names(layer_data))) {
      layer_data <- layer_data |>
        dplyr::mutate(name_old = name,
                      time = lubridate::ymd_hms(name_old)) # Create time from name_old
    } else {
      layer_data <- layer_data |>
        dplyr::mutate(name_old = name)
    }

    # Update the name column
    layer_data <- layer_data |>
      dplyr::mutate(name = paste0(layer_output_name, "_", name)) |>
      dplyr::arrange(time)

    # Display all dates if dates_view is TRUE
    if (dates_view) {
      pretty_dates <- layer_data |>
        dplyr::pull(time) |>
        format('%Y-%m-%d %H:%M:%S') # Format for pretty output

      cli::cli_alert_info("These are all {layer} dates read - not yet filtered. The function is not executed.")
      cat(pretty_dates, sep = "\n")
      return(invisible())  # Return invisibly after displaying dates
    }

    # Apply the time filter
    layer_data_filtered <- layer_data |>
      dplyr::filter(time >= time_start & time <= time_end)

    # Save to GPX format
    layer_data_filtered |>
      sf::st_write(fs::path(dir_out, paste0("gps_", layer, "_", layer_output_name, ".gpx")),
                   dataset_options = "GPX_USE_EXTENSIONS=yes",
                   delete_dsn = TRUE)

    # Save to GPKG format with proper naming to avoid spaces
    layer_data_filtered |>
      sf::st_write(fs::path(dir_out, paste0(gpkg_name, ".gpkg")),
                   layer = paste0("gps_", layer, "_", layer_output_name),  # Ensure no spaces
                   delete_dsn = FALSE, # Do not delete existing GPKG, just add layers
                   append = FALSE)

    # Inform the user where the files were saved
    cli::cli_alert_info("{layer} have been saved to:\n- {fs::path(dir_out, paste0('gps_', layer, '_', layer_output_name, '.gpx'))}\n- {fs::path(dir_out, paste0(gpkg_name, '.gpkg'))} (Layer: {layer_output_name})")
  }


  # Process each layer specified in gpx_layer_type
  for (layer in gpx_layer_type) {
    if (grepl("track", layer)) {  # Checks if "track" is part of the layer type
      process_layer(layer, filestoread_tracks)
    } else if (layer == "waypoints") {
      process_layer(layer, filestoread_waypoints)
    }
  }
}


