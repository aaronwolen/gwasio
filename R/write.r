#' Write a GWAS results data frame to a csv file.
#'
#' @inheritParams readr::write_csv
#'
#' @importFrom readr write_csv
#' @export

write_gwas_csv <- function(x, path, na = "NA", append = FALSE, col_names = !append) {
  readr::write_csv(x, path, na, append, col_names)
}
