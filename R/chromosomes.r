#' Convert chromosomes column to a propery ordered factor
#' @importFrom data.table data.table
set_chromosomes <- function(x, style) {
  style  <- match.arg(style, c("ncbi", "ensembl", "ucsc", "dbsnp"))

  chrom_input <- data.table::data.table(chromosome = x)
  chrom_key <- unique(chrom_input)

  # strip chromosome prefixes
  chrom_key[, key := as.character(chromosome)]
  chrom_key[,
    key := sub("^(ch|chr)", "", key, ignore.case = TRUE)][,
    key := sub("M$", "MT",      key, ignore.case = TRUE)
  ]

  # map input to specified style
  chrom_table <- chrom_table[, c("key", style) , with = FALSE]
  chrom_key <- chrom_table[chrom_key, on = "key"][, key := NULL]
  chrom_input[chrom_key, on = "chromosome"][[style]]
}


# gwas: PGC SCZ results
# > microbenchmark::microbenchmark(set_chromosomes(gwas$chromosome, "ucsc"))
# Unit: milliseconds
#                                     expr      min      lq     mean   median       uq      max neval
# set_chromosomes(gwas$chromosome, "ucsc") 25.20014 31.8288 59.65431 39.73228 93.63918 286.5315   100
