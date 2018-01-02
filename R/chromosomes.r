#' Convert chromosomes column to a propery ordered factor
#' @param x vector of chromosome values
#' @inheritParams read_gwas
#'
#' @importFrom data.table data.table :=
set_chromosomes <- function(x, chromosome_style) {
  style  <- match.arg(chromosome_style, c("ncbi", "ensembl", "ucsc", "dbsnp"))

  chrom_input <- data.table::data.table(chromosome = x)
  chrom_key <- unique(chrom_input)

  # strip chromosome prefixes
  chrom_key$key <- as.character(chrom_key$chromosome)
  chrom_key$key <- sub("23", "X", chrom_key$key, fixed = TRUE)
  chrom_key$key <- sub("^(ch|chr)", "", chrom_key$key, ignore.case = TRUE)
  chrom_key$key <- sub("M$", "MT", chrom_key$key, ignore.case = TRUE)

  # map input to specified style
  chrom_table <- chrom_table[, c("key", style) , with = FALSE]
  chrom_key <- chrom_table[chrom_key, on = "key"][, ("key") := NULL]

  # be conservative: abort if conversion would introduce missing values
  if (any(is.na(chrom_key[[style]]))) {
    warning(
      "Non-standard chromosomes detected - skipping chromosome conversion.",
      call. = FALSE
    )
    return(x)
  }
  chrom_input[chrom_key, on = "chromosome"][[style]]
}


# gwas: PGC SCZ results
# > microbenchmark::microbenchmark(set_chromosomes(gwas$chromosome, "ucsc"))
# Unit: milliseconds
#                                     expr      min      lq     mean   median       uq      max neval
# set_chromosomes(gwas$chromosome, "ucsc") 25.20014 31.8288 59.65431 39.73228 93.63918 286.5315   100
