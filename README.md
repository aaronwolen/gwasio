# `gwasio`

[![Travis-CI Build Status](https://travis-ci.org/aaronwolen/gwasio.svg?branch=master)](https://travis-ci.org/aaronwolen/gwasio)

Standardize heterogeneous GWAS results.

## Usage

`gwasio` is only available on GitHub for the moment but you can use the devtools packages to install the most recent development version:

```r
devtools::install_github("aaronwolen/gwasio")
```

The `read_gwas()` function is designed to efficiently load tabular files containing GWAS summary statistics into R and returning a [tibble](http://tibble.tidyverse.org) data frame with standardized variable names.

 Here are the first 10 rows of an example GWAS file, `data/ADSX_ea.assoc.dosage.csv`:

```
SNP,A1,A2,FRQ,INFO,BETA,SE,P
rs3094315,G,A,0.1776,0.8966,0.0498,0.1403,0.7229
rs149886465,C,A,0.9651,0.8581,0.2493,0.2990,0.4046
rs3131972,A,G,0.1837,0.9132,0.0316,0.1372,0.8182
rs148649543,C,T,0.9642,0.8473,0.2865,0.2972,0.3352
rs3131971,T,C,0.1889,0.8379,0.0712,0.1417,0.6154
rs61770173,C,A,0.1570,0.9025,0.0864,0.1470,0.5567
rs2073814,C,G,0.1975,0.8657,0.0215,0.1371,0.8753
rs2073813,G,A,0.8482,0.9748,-0.0918,0.1434,0.5221
chr1:753844:D,CCT,C,0.8826,0.4775,-0.0274,0.2285,0.9046
```

Using `read_gwas()` returns the following:

```r
read_gwas("data/ADSX_ea.assoc.dosage.csv")

# A tibble: 9,381,340 x 8
          marker    a1    a2 frequency information    beta     se pvalue
           <chr> <chr> <chr>     <dbl>       <dbl>   <dbl>  <dbl>  <dbl>
 1     rs3094315     G     A    0.1776      0.8966  0.0498 0.1403 0.7229
 2   rs149886465     C     A    0.9651      0.8581  0.2493 0.2990 0.4046
 3     rs3131972     A     G    0.1837      0.9132  0.0316 0.1372 0.8182
 4   rs148649543     C     T    0.9642      0.8473  0.2865 0.2972 0.3352
 5     rs3131971     T     C    0.1889      0.8379  0.0712 0.1417 0.6154
 6    rs61770173     C     A    0.1570      0.9025  0.0864 0.1470 0.5567
 7     rs2073814     C     G    0.1975      0.8657  0.0215 0.1371 0.8753
 8     rs2073813     G     A    0.8482      0.9748 -0.0918 0.1434 0.5221
 9 chr1:753844:D   CCT     C    0.8826      0.4775 -0.0274 0.2285 0.9046
10 chr1:753848:D    TG     T    0.8890      0.4808  0.1460 0.2335 0.5318
# ... with 9,381,330 more rows
```

If you provide multiple GWAS files `read_gwas()` will attempt to apply consistent variable names and combine the individual results into a single data frame with a new grouping column (`.gwas`)

```r
gwas.files <- c(
  adsx   = "data/ADSX_ea.assoc.dosage.csv",
  alabsx = "data/ALABSX_ea.assoc.dosage.csv"
)

read_gwas(gwas.files)

           .gwas           marker a1 a2 frequency information    beta     se  pvalue
       1:   adsx        rs3094315  G  A    0.1776      0.8966  0.0498 0.1403 0.72290
       2:   adsx      rs149886465  C  A    0.9651      0.8581  0.2493 0.2990 0.40460
       3:   adsx        rs3131972  A  G    0.1837      0.9132  0.0316 0.1372 0.81820
       4:   adsx      rs148649543  C  T    0.9642      0.8473  0.2865 0.2972 0.33520
       5:   adsx        rs3131971  T  C    0.1889      0.8379  0.0712 0.1417 0.61540
      ---
18763055: alabsx       rs62240042  C  T    0.7137      0.5401 -0.0395 0.0767 0.60670
18763056: alabsx chr22:51236013:I  A AT    0.8219      0.5588 -0.1815 0.0890 0.04168
18763057: alabsx        rs3896457  T  C    0.7445      0.5478 -0.0524 0.0790 0.50660
18763058: alabsx      rs149733995  A  C    0.9440      0.4797  0.4084 0.1597 0.01064
18763059: alabsx      rs181833046  A  T    0.8423      0.4292  0.0079 0.1068 0.94070
```




