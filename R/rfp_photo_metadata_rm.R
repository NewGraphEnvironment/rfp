#' Remove Metadata from a Photo
#'
#' This function removes all metadata from a specified photo file using `exiftool`.
#' Optionally, it can overwrite the original file or create a backup.
#'
#' @param path_photo A character string specifying the path to the photo file.
#' @param overwrite_original A logical value indicating whether to overwrite
#'   the original photo file (default is `TRUE`). If `FALSE`, a backup
#'   file with the suffix `_original` will be created.
#' @importFrom exifr exiftool_call
#' @importFrom chk chk_string chk_file
#'
#' @return None. The function modifies the specified file by removing its metadata.
#' @family photos
#' @export
#' @examples
#' \dontrun{
#'   rfp_photo_metadata_rm("path/to/photo.jpg")
#'
#'   or many at the same time
#'
#'   list_of_photo_paths |> purrr::walk(rfp_photo_metadata_rm)
#' }
rfp_photo_metadata_rm <- function(path_photo, overwrite_original = TRUE) {
  # Check that `photo` is a valid string
  chk::chk_string(path_photo)
  chk::chk_file(path_photo)

  # Set the arguments for exiftool
  args <- c("-all=")
  if (overwrite_original) {
    args <- c(args, "-overwrite_original")
  }

  # Remove metadata from the photo
  exifr::exiftool_call(args = args, fnames = path_photo)
}

