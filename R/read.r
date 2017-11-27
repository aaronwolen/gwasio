#' Read a GWAS results file into a data frame.
#'
#' @inheritParams data.table::fread
#' @param input Path to a file containing GWAS summary statistics. If multiple
#'   paths are specified all files will be read in and combined into a single
#'   \code{data.frame}.
#' @param missing Vector of characters that represent missing value codes. By
#'   default the following strings are interpreted as \code{NA}: \code{""},
#'   \code{"."}, \code{"NA"}, \code{"N/A"}, and \code{"null"}.
#' @param verbose Provide description of processing steps
#'
#' @importFrom data.table fread
#' @importFrom purrr map map_int map_chr walk2 set_names discard keep
#' @importFrom rlang is_named
#' @importFrom stringi stri_count_regex
#' @export

read_gwas <-
  function(input,
           missing = c("NA", "N/A", "null", "."),
           verbose = TRUE) {

  if (!rlang::is_named(input)) {
    names <- Map(file_path_sans_ext,
                 x = basename(input),
                 compression = is_compressed(input))
    names(input) <- make.unique(unlist(names, use.names = FALSE))
  }

  out <- lapply(input, read_gwas_file, missing = missing, verbose = verbose)

  if (length(out) > 1) {
    data.table::rbindlist(out, idcol = ".gwas", fill = TRUE)
  } else {
    out[[1]]
  }
}

read_gwas_file <- function(input, missing, verbose) {

  if (is_compressed(input)) {
    input <- switch(tools::file_ext(input),
      zip = decompress_zip(input),
      gz = decompress_gz(input)
    )
  }

  input.names <- read_colnames(input)
  data <- fread(input, col.names = input.names, skip = 1, na.strings = missing,
                verbose = FALSE)

  col.names <- detect_patterns(input.names)


  if (verbose) {
    purrr::walk2(names(col.names),
                 col.names,
                 ~ message("Column ", .x, " renamed to ", .y))
  }

  data.table::setnames(data, names(col.names), col.names)
  data
}
