#### Benchmarking random forest packages
#### Author: William Morgan

## Purpose:
# Test 3 popular random forest implementations using microbenchmark on a handful
# of random data sets of varying sizes

#------------------------------------------------------------------------------#

## 0. Setup
libs <- c("dplyr", "data.table", "magrittr")

lapply(libs, function(x) {
  if (x %in% installed.packages()) {
    library(x, character.only = TRUE)
  } else {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

source("Code/utils.R")

#------------------------------------------------------------------------------#

## 1. Regression tests

# Create data
data <- list(
  "1K x 10" = genDataset(1000, 10, outcome = 'continuous'),
  "10K x 10" = genDataset(10000, 10, outcome = 'continuous'),
  "50K x 10" = genDataset(50000, 10, outcome = 'continuous'),
  "100K X 10" = genDataset(10000, 10, outcome = 'continuous'),
  "10K x 100" = genDataset(10000, 100, outcome = 'continuous')
)

# Default tests
default_result <- data.frame(
  expr = vector(mode = "character", length = 0),
  mean_time = vector(mode = "numeric", length = 0),
  dataset = vector(mode = "character", length = 0)
)

for (i in seq_along(data)) {
  cat("Starting dataset: ", names(data[i]))
  result <- runDefaultTest(data[[i]])
  result$dataset <- names(data[i])
  
  bind_rows(default_result, result)  
}


# Run optimized tests
opt_result <- data.frame(
  expr = vector(mode = "character", length = 0),
  mean_time = vector(mode = "numeric", length = 0),
  dataset = vector(mode = "character", length = 0)
)

for (i in seq_along(data)) {
  result <- runDefaultTest(data[[i]])
  result$dataset <- names(data[i])
  
  bind_rows(opt_result, result)  
}

#------------------------------------------------------------------------------#

## 2. Classification tests

# Create data
data <- list(
  "1K x 10" = genDataset(1000, 10, outcome = 'binary'),
  "10K x 10" = genDataset(10000, 10, outcome = 'binary'),
  "50K x 10" = genDataset(50000, 10, outcome = 'binary'),
  "100K X 10" = genDataset(10000, 10, outcome = 'binary'),
  "10K x 100" = genDataset(10000, 100, outcome = 'binary')
)

# Default tests
default_result <- data.frame(
  expr = vector(mode = "character", length = 0),
  mean_time = vector(mode = "numeric", length = 0),
  dataset = vector(mode = "character", length = 0)
)

for (i in seq_along(data)) {
  cat("Starting dataset: ", names(data[i]))
  result <- runDefaultTest(data[[i]])
  result$dataset <- names(data[i])
  
  bind_rows(default_result, result)  
}


# Run optimized tests
opt_result <- data.frame(
  expr = vector(mode = "character", length = 0),
  mean_time = vector(mode = "numeric", length = 0),
  dataset = vector(mode = "character", length = 0)
)

for (i in seq_along(data)) {
  result <- runDefaultTest(data[[i]])
  result$dataset <- names(data[i])
  
  bind_rows(opt_result, result)  
}