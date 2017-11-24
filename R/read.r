#' Read a GWAS results file into a data frame.
#'
#' @inheritParams data.table::fread
#' @param input Either the file name to read (containing no \\n character), a
#'   shell command that preprocesses the file (e.g. \code{fread("grep blah
#'   filename")}) or the input itself as a string (containing at least one
#'   \\n), see examples. In both cases, a length 1 character string. A filename
#'   input is passed through path.expand for convenience and may be a URL
#'   starting \code{http://} or \code{file://}.
#' @param missing Vector of characters that represent missing value codes. By
#'   default the following strings are interpreted as \code{NA}: \code{""},
#'   \code{"."}, \code{"NA"}, \code{"N/A"}, and \code{"null"}.
#' @param verbose Provide description of processing steps
#'
#' @importFrom data.table fread
#' @importFrom purrr map map_int map_chr walk2 set_names discard keep
#' @importFrom stringi stri_count_regex
#' @export

read_gwas <-
  function(input,
           missing = c("NA", "N/A", "null", "."),
           verbose = TRUE) {

  if (is_compressed(input)) {
    input <- switch(tools::file_ext(input),
      zip = decompress_zip(input),
      gz = decompress_gz(input)
    )
  }

  input.names <- read_colnames(input)
  data <- fread(input, col.names = input.names, skip = 1, na.strings = missing)

  col.names <- detect_patterns(input.names)


  if (verbose) {
    purrr::walk2(names(col.names),
                 col.names,
                 ~ message("Column ", .x, " renamed to ", .y))
  }

  data.table::setnames(data, names(col.names), col.names)
  data
}
