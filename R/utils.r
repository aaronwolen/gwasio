# Capture header row of input data table
#' @importFrom stringi stri_trim_both stri_split
#' @importFrom purrr flatten_chr "%>%"
read_colnames <- function(input) {
  readLines(input, n = 1) %>%
    stringi::stri_trim_both() %>%
    stringi::stri_split(regex = "[,\t |;:]") %>%
    purrr::flatten_chr()
}

is_compressed <- function(x) {
  grepl("(gz|zip)$", x)
}

# see: https://github.com/hadley/devtools/commit/1b1732c
decompress_zip <- function(x, unzip = getOption("unzip")) {
  files <- utils::unzip(x, list = TRUE)
  file <- files$Name[[1]]

  if (unzip == "internal") {
    return(utils::unzip(x, file, exdir = tempdir()))
  }

  exdir <- tempdir()
  system2(unzip, c("-oq", x, file, paste("-d", exdir)))
  file.path(exdir, file)
}

#' @importFrom R.utils gunzip
decompress_gz <- function(x) {
  R.utils::gunzip(x, temporary = TRUE, remove = FALSE, overwrite = TRUE)
}
