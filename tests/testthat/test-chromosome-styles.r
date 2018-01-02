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
