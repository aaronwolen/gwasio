context("Test variable patterns")

test_that("chromosome", {
  x <- c("chromosome", "chrom", "chr", "hg18chr", "hg19chr")
  hits <- stri_count_regex(x, .gwas_patterns$chromosome)
  expect_true(all(hits))
})

test_that("marker", {
  x <- c("marker", "markername", "snp", "snpid", "rsid", "rs_id")
  hits <- stri_count_regex(x, .gwas_patterns$marker)
  expect_true(all(hits))
})

test_that("position", {
  x <- c("position", "pos", "bp")
  hits <- stri_count_regex(x, .gwas_patterns$position)
  expect_true(all(hits))
})

test_that("a1", {
  x <- c("a1", "allele1", "allelea")
  hits <- stri_count_regex(x, .gwas_patterns$a1)
  expect_true(all(hits))
})

test_that("a2", {
  x <- c("a2", "allele2", "alleleb")
  hits <- stri_count_regex(x, .gwas_patterns$a2)
  expect_true(all(hits))
})

test_that("frequency", {
  x <- c("frequency", "freq", "frq", "af", "CEUaf")
  hits <- stri_count_regex(x, .gwas_patterns$frequency)
  expect_true(all(hits))
})

test_that("information", {
  x <- c("information", "info")
  hits <- stri_count_regex(x, .gwas_patterns$information)
  expect_true(all(hits))
})

test_that("zscore", {
  x <- c("zscore", "z", "z-score", "z.score", "z_score")
  hits <- stri_count_regex(x, .gwas_patterns$zscore)
  expect_true(all(hits))
})

test_that("beta", {
  x <- c("beta", "b")
  hits <- stri_count_regex(x, .gwas_patterns$beta)
  expect_true(all(hits))
})

test_that("se", {
  x <- c("se", "standarderr", "stderror", "std.error")
  hits <- stri_count_regex(x, .gwas_patterns$se)
  expect_true(all(hits))
})

test_that("pvalue", {
  x <- c("pvalue", "p", "pval", "p-val", "p.value")
  hits <- stri_count_regex(x, .gwas_patterns$pvalue)
  expect_true(all(hits))
})
