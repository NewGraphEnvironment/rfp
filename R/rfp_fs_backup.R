#' Backup a file with optional timestamp
#'
#' Copies a specified file to a backup directory, optionally appending a timestamp.
#'
#' @param path_dir_in Character. Directory of the input file.
#' @param path_in_file Character. Name of the input file.
#' @param path_dir_out Character. Directory where the backup should be stored.
#' @param stamp Character or NULL. Optional string to append to the filename. Defaults to current timestamp.
#'
#' @return Character. Full path to the newly created backup file.
#' @export
#' @importFrom chk chk_string chk_file
#' @importFrom fs path path_file path_ext_remove path_ext dir_create file_copy file_exists
#' @importFrom cli cli_alert_success
#'
#' @examples
#' \dontrun{
#' path_dir_in <- "~/Projects/gis/sern_peace_fwcp_2023"
#' path_in_file <- "background_layers.gpkg"
#' path_dir_out <- "~/Projects/gis/backups"
#' rfp_fs_backup(path_dir_in, path_in_file, path_dir_out)
#' }
rfp_fs_backup <- function(
    path_dir_in,
    path_in_file,
    path_dir_out,
    stamp = format(Sys.time(), "%Y%m%d%H%M")
) {
  # Validate inputs
  chk::chk_string(path_dir_in)
  chk::chk_string(path_in_file)
  chk::chk_string(path_dir_out)
  if (!is.null(stamp)) chk::chk_string(stamp)

  # Check that the input file exists
  chk::chk_file(fs::path(path_dir_in, path_in_file))

  # Create the output directory if it doesn't exist
  fs::dir_create(fs::path(path_dir_out, fs::path_file(path_dir_in)))

  # Construct the base name
  base_name <- fs::path_ext_remove(path_in_file)
  if (!is.null(stamp)) {
    base_name <- paste0(base_name, "_", stamp)
  }

  # Construct the output path
  path_out_file <- fs::path(
    path_dir_out,
    fs::path_file(path_dir_in),
    base_name,
    ext = fs::path_ext(path_in_file)
  )

  # Copy the file
  fs::file_copy(
    fs::path(path_dir_in, path_in_file),
    path_out_file
  )

  # CLI success message
  cli::cli_alert_success("Backup created at {.path {path_out_file}}")

  # Return the path to the backup file
  return(path_out_file)
}
