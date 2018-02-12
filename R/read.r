#' Read a GWAS results file into a data frame.
#'
#' @inheritParams data.table::fread
#' @param input Path to a file containing GWAS summary statistics. If multiple
#'   paths are specified all files will be read in and combined into a single
#'   \code{data.frame}.
#' @param missing Vector of characters that represent missing value codes. By
#'   default the following strings are interpreted as \code{NA}: \code{""},
#'   \code{"."}, \code{"NA"}, \code{"N/A"}, and \code{"null"}.
#' @param chromosome_style Convert chromosomes to ordered factors with labels based on the specified style (default is \code{"ucsc"}; see below for a comparison of the different styles). Set to \code{NULL} to leave chromosomes unchanged.
#' @param preprocess a shell command that preprocesses the file; see below for
#'   more details
#' @param verbose Provide description of processing steps
#'
#' @section Chromosome Styles:
#'
#' We use the \emph{Homo sapiens} chromosome styles defined in Bioconductor's
#' \href{https://bioconductor.org/packages/GenomeInfoDb}{\code{GenomeInfoDb}}.
#' Valid options include \code{"ncbi"}, \code{"ensembl"}, \code{"ucsc"} and
#' \code{"dbsnp"}. The following table provides a preview of each style (note
#' \code{ncbi} and \code{ensembl} are identical):
#'
#' \tabular{rrr}{
#'   ncbi/ensembl  \tab ucsc  \tab dbsnp\cr
#'   1             \tab chr1  \tab ch1 \cr
#'   2             \tab chr2  \tab ch2\cr
#'   3             \tab chr3  \tab ch3\cr
#'   \dots         \tab \dots \tab \dots\cr
#'   X             \tab chrX  \tab chX\cr
#'   Y             \tab chrY  \tab chY\cr
#'   MT            \tab chrM  \tab chMT
#' }
#'
#' @section Preprocessing:
#'
#' The \code{preprocessor} argument allows you to specify shell commands that
#' preprocess the file before it's read into \R. For example, we could use
#' \code{grep} to filter our results to include only markers with an RS number:
#'
#' \preformatted{ read_gwas("my-results.txt", preprocess = "grep -e '^rs'") }
#'
#' Note that \code{read_gwas()} handles the header row separately so column
#' labels wouldn't be filtered out by \code{grep} in this example.
#'
#' By default, the input filename is appended to \code{preprocess} argument
#' prior to execution. However, you can control where the filename should be
#' inserted in the command by using \code{\%s} as a placeholder. In the following
#' example, \code{tr} is being used to remove null terminators:
#'
#' \preformatted{
#'   read_gwas("my-results.txt", preprocess = "tr -d '\\000' < \%s")
#' }
#'
#' @importFrom data.table fread
#' @importFrom tibble tibble as_tibble
#' @importFrom purrr map map_int map_chr walk2 set_names discard keep
#' @importFrom rlang is_named
#' @importFrom stringi stri_count_regex
#' @export

read_gwas <-
  function(input,
           missing = c("NA", "N/A", "null", "."),
           chromosome_style = "ucsc",
           preprocess = NULL,
           verbose = TRUE) {

  if (!rlang::is_named(input)) {
    names <- Map(file_path_sans_ext,
                 x = basename(input),
                 compression = is_compressed(input))
    names(input) <- make.unique(unlist(names, use.names = FALSE))
  }

  out <- lapply(input, read_gwas_file,
                missing = missing, preprocess = preprocess, verbose = verbose)

  if (length(out) > 1) {
    out <- data.table::rbindlist(out, idcol = ".gwas", fill = TRUE)
  } else {
    out <- out[[1]]
  }

  if (!is.null(out$chromosome) & !is.null(chromosome_style)) {
    chromosome_style <- match.arg(chromosome_style,
                                  setdiff(colnames(chrom_table), "key"))
    out[, "chromosome" := set_chromosomes(get("chromosome"), chromosome_style)]
  }

  tibble::as_tibble(out)
}

read_gwas_file <- function(input, missing, preprocess, verbose) {

  if (is_compressed(input)) {
    input <- switch(tools::file_ext(input),
      zip = decompress_zip(input),
      gz = decompress_gz(input)
    )
  }
  input.names <- read_colnames(input)

  if (!is.null(preprocess)) {
    if (grepl("%s", preprocess)) {
      input <- sprintf(preprocess, input)
    } else {
      input <- paste(preprocess, input)
    }
  }

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
