#' Convert chromosomes column to a propery ordered factor
#' @importFrom data.table setnames setcolorder
set_chromosomes <- function(x, style) {
  style  <- match.arg(style, c("ncbi", "ensembl", "ucsc", "dbsnp"))
  col_order <- names(x)

  x[, chromosome := as.character(chromosome)]
  chroms <- unique(x[, "chromosome"])
  chroms[, key := chromosome]

  # strip chromosome prefixes
  chroms[, key := sub("^(ch|chr)", "", key, ignore.case = TRUE)]
  chroms[, key := sub("M$", "MT",      key, ignore.case = TRUE)]

  # map to specified style
  chrom_table <- chrom_table[, c("key", style), with = FALSE]
  chroms <- chroms[chrom_table, on = "key"][, key := NULL][!is.na(chromosome)]

  x[["chromosome"]] <- x[, c("chromosome")][chroms, on = "chromosome"][[style]]
  x
}


# gwas: PGC SCZ results
# > microbenchmark::microbenchmark(set_chromosomes(data.table(gwas), "ucsc"), times = 3)
# Unit: milliseconds
#                                       expr      min       lq     mean   median       uq      max neval
#  set_chromosomes(data.table(gwas), "ucsc") 414.2297 443.1423 463.7373 472.0549 488.4911 504.9273     3
