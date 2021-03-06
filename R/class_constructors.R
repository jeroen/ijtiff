#' `ijtiff_img` class.
#'
#' A class for images which are read or to be written by the `ijtiff` package.
#'
#' @param img An array representing the image. \itemize{\item For a
#'   single-plane, grayscale image, use a matrix `img[y, x]`. \item For a
#'   multi-plane, grayscale image, use a 3-dimensional array `img[y, x, plane]`.
#'   \item For a multi-channel, single-plane image, use a 4-dimensional array
#'   with a redundant 4th slot `img[y, x, channel, ]` (see [ijtiff_img]
#'   'Examples' for an example). \item For a multi-channel, multi-plane image,
#'   use a 4-dimensional array `img[y, x, channel, plane]`.}
#' @param ... Named arguments which are set as attributes.
#'
#' @return A 4 dimensional array representing an image, indexed by `img[y, x,
#'   channel, frame]` (this is consistent with the `EBImage` package
#'   (\url{https://bioconductor.org/packages/EBImage/})) with selected
#'   attributes.
#'
#' @export
#'
#' @examples
#' img <- matrix(1:4, nrow = 2)  # to be a single-channel, grayscale image
#' ijtiff_img(img, description = "single-channel, grayscale")
#' img <- array(seq_len(2 ^ 3), dim = rep(2, 3))  # 1 channel, 2 frame
#' ijtiff_img(img, description = "blah blah blah")
#' img <- array(seq_len(2 ^ 3), dim = c(2, 2, 2, 1))  #  2 channel, 1 frame
#' ijtiff_img(img, description = "blah blah")
#' img <- array(seq_len(2 ^ 4), dim = rep(2, 4))  # 2 channel, 2 frame
#' ijtiff_img(img, software = "R")
ijtiff_img <- function(img, ...) {
  checkmate::assert_array(img, min.d = 2, max.d = 4)
  checkmate::assert_numeric(img)
  if (length(dim(img)) == 2) dim(img) %<>% c(1, 1)
  if (length(dim(img)) == 3) dim(img) %<>% {c(.[1:2], 1, .[3])}
  checkmate::assert_array(img, d = 4)
  dots <- list(...)
  if (length(dots)) {
    namez <- names(dots)
    if (is.null(namez)) stop("All arguments in ... must be named.")
    for (n in namez) attr(img, n) <- dots[[n]]
  }
  class(img) %<>% c("ijtiff_img", .)
  img
}