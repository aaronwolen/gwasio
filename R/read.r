#' Read a GWAS results file into a data frame.
#'
#' @section Delimiters:
#'
#' The \code{delim} argument accepts any of the following values:
#'
#' \enumerate{
#'  \item \code{"tab"}
#'  \item \code{"comma"}
#'  \item \code{"space"}
#' }
#'
#' @inheritParams data.table::fread
#' @param delim Symbolic name for single character used to separate fields
#'
#' @importFrom data.table fread

read_gwas <- function(file, verbose = TRUE) {

  data <- fread(file)

  col.names <- detect_patterns(names(data))

  if (verbose) {
    dev.null <- Map(
      function(x, y) message("Column ", x, " renamed to ", y),
      x = names(col.names),
      y = col.names
    )
  }

  data.table::setnames(data, names(col.names), col.names)
  data
}
