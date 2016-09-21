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
#' @param input Either the file name to read (containing no \\n character), a
#'   shell command that preprocesses the file (e.g. \code{fread("grep blah
#'   filename")}) or the input itself as a string (containing at least one
#'   \\n), see examples. In both cases, a length 1 character string. A filename
#'   input is passed through path.expand for convenience and may be a URL
#'   starting \code{http://} or \code{file://}.
#' @param verbose Provide description of processing steps
#'
#' @importFrom data.table fread
#' @importFrom purrr map map_int map_chr walk2 set_names discard keep
#' @importFrom stringi stri_count_regex

read_gwas <- function(input, verbose = TRUE) {

  data <- fread(input)

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
