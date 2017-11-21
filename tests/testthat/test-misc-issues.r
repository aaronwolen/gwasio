context("Miscellaneous issues")

test_that("header and data can use different delimiters", {
  file    <- "tables/different-header-delimiter.txt"
  expect_silent(table <- read_gwas(file, verbose = FALSE))
})