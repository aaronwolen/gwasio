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
  expect_true(is.data.frame(read_gwas(files, chromosome_style = NULL)))

  # respects custom names
  names(files) <- c("gwas1", "gwas2", "gwas3")
  gwas <- read_gwas(files, chromosome_style = NULL)
  expect_equal(unique(gwas$.gwas), names(files))
})

test_that("handles column names from pretty printed files", {
  gwas <- read_gwas("tables/plink-dosage.txt")
  expect_equal(dim(gwas), c(6, 8))
})

test_that("preprocessor can handle ascii null characters", {
  file <- "tables/plink-dosage-with-ascii-null.txt"
  expect_error(read_gwas(file), regexp = "embedded nul in string")
  gwas <- read_gwas(file, preprocess = "tr -d '\\000' < %s")
  expect_equal(dim(gwas), c(6, 8))
})
