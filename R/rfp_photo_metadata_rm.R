#' Remove Metadata from a Photo
#'
#' This function removes all metadata from a specified photo file using `exiftool`.
#' Optionally, it can overwrite the original file or create a backup.
#'
#' @param path_photo A character string specifying the path to the photo file.
#' @param overwrite_original A logical value indicating whether to overwrite
#'   the original photo file (default is `TRUE`). If `FALSE`, a backup
#'   file with the suffix `_original` will be created.
#' @param log_output Optionally produce tibble of log output (default is `TRUE`)
#' @importFrom exifr exiftool_call
#' @importFrom chk chk_string chk_file chk_ext
#' @importFrom tibble tibble
#'
#' @return None. The function modifies the specified file by removing its metadata.
#' @family photos
#' @export
#' @examples
#' \dontrun{
#'   rfp_photo_metadata_rm("path/to/photo.jpg")
#'
#'   # many at the same time with no logging
#'
#'   list_of_photo_paths |> purrr::walk(rfp_photo_metadata_rm, log_output = FALSE)
#'
#'   # many at the same time with logging
#'
#'   log_df <- list_of_photo_paths |> purrr::map_dfr(rfp_photo_metadata_rm)
#' }
rfp_photo_metadata_rm <- function(
    path_photo,
    overwrite_original = TRUE,
    log_output = TRUE) {
  # Check that `photo` is a valid string
  chk::chk_string(path_photo)
  chk::chk_file(path_photo)
  chk::chk_ext(path_photo, c("jpeg", "JPEG", "JPG", "jpg", "png", "PNG"))

  # Set up exiftool command and arguments
  exiftool_path <- system.file("exiftool/exiftool.pl", package = "exifr")
  args <- c("-all=")
  if (overwrite_original) {
    args <- c(args, "-overwrite_original")
  }

  # Execute exiftool command with system2 and capture output
  console_output <- system2(
    command = "perl",
    args = c(exiftool_path, args, path_photo),
    stdout = TRUE,
    stderr = TRUE
  )

  # Initialize log tibble if logging is enabled
  if (log_output) {
    # Parse the output to create a log entry
    log_entry <- tibble::tibble(
      photo_path = path_photo,
      command = paste("perl", exiftool_path, paste(args, collapse = " "), path_photo),  # The command used by exiftool
      status_message = paste(console_output, collapse = "; ")  # Concatenate status lines
    )

    # Return the log entry as output (could be appended outside the function)
    return(log_entry)
  } else {
    # If logging is disabled, return NULL
    #   Remove metadata from the photo with regular call to function
    exifr::exiftool_call(args = args, fnames = path_photo)
  }
}


