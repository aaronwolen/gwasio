context("Chromosome Styles")

test_that("convert from NCBI style", {
  chrs <- data.table::copy(chrom_table)
  data.table::setnames(chrs, "ncbi", "chromosome")

  expect_equal(
    set_chromosomes(chrs, "ucsc")$chromosome,
    chrom_table$ucsc
  )
  expect_equal(
    set_chromosomes(chrs, "dbsnp")$chromosome,
    chrom_table$dbsnp
  )
  expect_equal(
    set_chromosomes(chrs, "ensembl")$chromosome,
    chrom_table$ensembl
  )
})

test_that("convert from UCSC style", {
  chrs <- data.table::copy(chrom_table)
  data.table::setnames(chrs, "ucsc", "chromosome")

  expect_equal(
    set_chromosomes(chrs, "ucsc")$chromosome,
    chrom_table$ucsc
  )
  expect_equal(
    set_chromosomes(chrs, "dbsnp")$chromosome,
    chrom_table$dbsnp
  )
  expect_equal(
    set_chromosomes(chrs, "ensembl")$chromosome,
    chrom_table$ensembl
  )
})

test_that("convert from dbSNP style", {
  chrs <- data.table::copy(chrom_table)
  data.table::setnames(chrs, "dbsnp", "chromosome")

  expect_equal(
    set_chromosomes(chrs, "ucsc")$chromosome,
    chrom_table$ucsc
  )
  expect_equal(
    set_chromosomes(chrs, "dbsnp")$chromosome,
    chrom_table$dbsnp
  )
  expect_equal(
    set_chromosomes(chrs, "ensembl")$chromosome,
    chrom_table$ensembl
  )
})
