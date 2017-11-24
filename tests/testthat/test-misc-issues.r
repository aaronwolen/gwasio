context("Miscellaneous issues")

test_that("header and data can use different delimiters", {
  file    <- "tables/different-header-delimiter.txt"
  expect_silent(table <- read_gwas(file, verbose = FALSE))
})

test_that("handles compressed files", {
  ref <- read_gwas("tables/columns-variant1-canonical.txt")
  expect_equal(read_gwas("tables/columns-variant1-canonical.txt.zip"), ref)
  expect_equal(read_gwas("tables/columns-variant1-canonical.txt.gz"), ref)
})

test_that("handles multiple files", {
  files <- dir("tables", pattern = "variant[234]", full.names = TRUE)
  expect_true(is.data.frame(read_gwas(files)))

  # respects custom names
  names(files) <- c("gwas1", "gwas2", "gwas3")
  gwas <- read_gwas(files)
  expect_equal(unique(gwas$.gwas), names(files))
})
