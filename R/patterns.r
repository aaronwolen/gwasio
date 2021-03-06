.gwas_patterns <- list(
  chromosome  = "^(hg\\d{2})?chr(om)?(osome)?$",
  marker      = "^(mark(er)?(name)?|rs[\\.\\-_]?id|snp(id)?)$",
  position    = "^(pos(ition)?|bp)$",
  a1          = "^a(llele)?[1a]$",
  a2          = "^a(llele)?[2b]$",
  frequency   = "^fr(e)?q(uency)?|af$",
  information = "^info(rmation)?$",
  zscore      = "^z[\\.\\-_]?(score)?$",
  beta        = "^b(eta)?$",
  se          = "^s(td|tandard)?[\\.\\-_]?e(rr|rror)?$",
  pvalue      = "^p[\\.\\-_]?(val|value)?$"
)

# return name of slot containing a unique matching pattern
detect_patterns <- function(strings, patterns = .gwas_patterns) {

  hits <- purrr::map(
    purrr::set_names(strings),
    stringi::stri_count_regex,
    pattern = patterns,
    opts_regex = list(case_insensitive = TRUE)
  )
  hits <- purrr::discard(hits, function(x) all(x == 0))

  # only rename variables that match a single pattern
  n.hits <- purrr::map_int(hits, sum)
  if (any(n.hits > 1)) {
    ambiguous <- purrr::keep(n.hits, ~ . > 1)
    purrr::walk2(names(ambiguous), ambiguous,
                 ~ warning(.x, " matched ", .y, " variables.", call. = FALSE))
    hits <- hits[setdiff(names(hits), names(ambiguous))]
  }

  out <- purrr::map_chr(hits, function(x) names(patterns)[which(x > 0)])
  # ensure each pattern is matched only once
  out[!duplicated(out)]
}
