# Create a chromosome style conversion data.table
library(data.table)
library(devtools)

if (require(GenomeInfoDb, quietly = TRUE)) {
  chrom_file <- system.file("extdata", "dataFiles", "Homo_sapiens.txt",
                            package = "GenomeInfoDb")
} else {
  stop("Must install GenomeInfoDb from Bioconductor")
}

chrom_table <- fread(chrom_file)
chrom_table[, c("circular", "auto", "sex") := NULL]
setnames(chrom_table, names(chrom_table), tolower(names(chrom_table)))

# convert to factors
cols <- names(chrom_table)
chrom_table[,
  (cols) := lapply(.SD, function(x) factor(x, unique(x))),
  .SDcols = cols
]

# use ncbi style as 'foreign key' for cross-style mapping
chrom_table[, key := ncbi]
setkeyv(chrom_table, cols = "key")

devtools::use_data(chrom_table, internal = TRUE, overwrite = TRUE)
