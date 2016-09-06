.gwas_patterns <- list(
  chromosome = c(
    "chromosome"
    ),
  marker = c(
    "marker",
    "rsid",
    "snp",
    "markername"
  ),
  position = c(
    "position",
    "bp"
  ),
  a1 = c(
    "a1",
    "allele1",
    "allelea"
  ),
  a2 = c(
    "a2",
    "allele2",
    "alleleb"
  ),
  frequency = c(
    "frequency",
    "freq",
    "frq"
  ),
  information = c(
    "information",
    "info"
  ),
  zscore = c(
    "zscore",
    "z"
  ),
  beta = c(
    "beta",
    "b"
  ),
  se = c(
    "se"
  ),
  pvalue = c(
    "pvalue",
    "p.value",
    "pval",
    "p.val",
    "p"
  )
)

# return name of slot containing a unique matching pattern
detect_patterns <- function(strings, patterns = .gwas_patterns) {

    out <- setNames(vector("list", length(strings)), strings)

    for (s in strings) {
      for (p in names(patterns)) {
        pat <- patterns[[p]]
        matches <-  na.omit(match(tolower(s), pat))

        # only accept single matches
        if (length(matches) == 1) {
          out[[s]] <- c(out[[s]], p)
        }
      }
    }
    unlist(out)
  }
