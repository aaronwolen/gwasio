context("Column naming")

file <- "tables/nameless.txt"

test_that("warning thrown if header row contains numbers", {
  expect_warning(read_gwas(file), "Detected numbers in first row")
})

test_that("column names are generated if header=FALSE", {
  expect_silent(table <- read_gwas(file, header = FALSE))
  expect_equal(dim(table), c(5, 11))
})

test_that("column names can be specified", {
  labels <- paste0("col", 1:11)
  expect_silent(table <- read_gwas(file, header = FALSE, col.names = labels))
  expect_equal(names(table), labels)
})
