#### Benchmarking random forest packages
#### Author: William Morgan

## Purpose:
# Test 3 popular random forest implementations using microbenchmark on a handful
# of random data sets of varying sizes

#------------------------------------------------------------------------------#

# 0. Setup
libs <- c("dplyr", "data.table", "magrittr")

lapply(libs, function(x) {
  if (x %in% installed.packages()) {
    library(x, character.only = TRUE)
  } else {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

source("")