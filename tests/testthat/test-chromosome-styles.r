context("Chromosome Styles")

test_that("convert from NCBI style", {
  expect_equal(
    set_chromosomes(chrom_table$ncbi, "ucsc"),
    chrom_table$ucsc
  )
  expect_equal(
    set_chromosomes(chrom_table$ncbi, "dbsnp"),
    chrom_table$dbsnp
  )
  expect_equal(
    set_chromosomes(chrom_table$ncbi, "ensembl"),
    chrom_table$ensembl
  )
})

test_that("convert from UCSC style", {
  expect_equal(
    set_chromosomes(chrom_table$ucsc, "ncbi"),
    chrom_table$ncbi
  )
  expect_equal(
    set_chromosomes(chrom_table$ucsc, "dbsnp"),
    chrom_table$dbsnp
  )
  expect_equal(
    set_chromosomes(chrom_table$ucsc, "ensembl"),
    chrom_table$ensembl
  )
})

test_that("convert from dbSNP style", {
expect_equal(
    set_chromosomes(chrom_table$dbsnp, "ucsc"),
    chrom_table$ucsc
  )
  expect_equal(
    set_chromosomes(chrom_table$dbsnp, "ncbi"),
    chrom_table$ncbi
  )
  expect_equal(
    set_chromosomes(chrom_table$dbsnp, "ensembl"),
    chrom_table$ensembl
  )
})

test_that("conversion is skipped with non-standard chromosomes", {
  expect_warning(set_chromosomes(c(chrom_table$ncbi, "unknown"), "ucsc"))
})

test_that("chromosome order is maintained", {
  x <- c(2, 1, 2)
  y <- set_chromosomes(c(2, 1, 2), "ncbi")
  expect_equal(x, as.numeric(y))
})
