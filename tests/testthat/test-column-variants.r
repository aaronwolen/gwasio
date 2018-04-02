context("Column label variants")

test_that("canonical labels recognized", {
  file    <- "tables/columns-variant1-canonical.txt"
  labels  <- names(.gwas_patterns)
  expect_silent(table   <- read_gwas(file, verbose = FALSE))
  expect_equal(colnames(table), labels)
  expect_equal(dim(table), c(5, 11))
})

test_that("abbreviated labels recognized", {
  file    <- "tables/columns-variant2-abbreviated.txt"
  labels  <- names(.gwas_patterns)
  expect_silent(table   <- read_gwas(file, verbose = FALSE))
  expect_equal(colnames(table), labels)
  expect_equal(dim(table), c(5, 11))
})

test_that("variant 3 recognized", {
  file    <- "tables/columns-variant3.txt"
  labels  <-
    c("marker",
      "position",
      "a1",
      "a2",
      "frequency",
      "pvalue")
  expect_silent(table   <- read_gwas(file, verbose = FALSE))
  expect_equal(colnames(table), labels)
  expect_equal(dim(table), c(5, 6))
})

test_that("variant 4", {
  file    <- "tables/columns-variant4.txt"
  labels  <-
    c("marker",
      "a1",
      "a2",
      "frequency",
      "information",
      "beta",
      "se",
      "pvalue")
  expect_silent(table   <- read_gwas(file, verbose = FALSE))
  expect_equal(colnames(table), labels)
  expect_equal(dim(table), c(9, 8))
})
