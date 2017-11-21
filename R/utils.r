# Capture header row of input data table
#' @importFrom stringi stri_trim_both stri_split
#' @importFrom purrr flatten_chr "%>%"
read_colnames <- function(input) {
  readLines(input, n = 1) %>%
    stringi::stri_trim_both() %>%
    stringi::stri_split(regex = "[,\t |;:]") %>%
    purrr::flatten_chr()
}

