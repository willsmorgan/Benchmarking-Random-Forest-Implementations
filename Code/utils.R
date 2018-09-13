#### Benchmarking utils
#### Author: William Morgan

## Purpose:
# Create datasets of arbitrary size from random normal distributions used for testing
# the different random forest packages. Include functionality for both regression
# and classification tests.

# In addition, define the general testing procedure for the random forest packages
# that will be tested. For now, this will only contain randomForest, ranger, and Rborist
# as obliqueRF and ParallelForest were crashing and the issues could not be resolved.

#------------------------------------------------------------------------------#
libs <- c("purrr", "data.table", "magrittr", "dplyr",
          "microbenchmark", "randomForest", "ranger", "Rborist")
lapply(libs, function(x) {
  if (x %in% installed.packages()) {
    library(x, character.only = TRUE)
  } else {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})


## Data-generating function
genDataset <- function(n, n_features, outcome = 'binary') {
  
  # Generate numeric DF with dimensions n x n_features;
  # 
  # Each column is a std. normal
  
  # Create DF of features
  list <- rep(list(vector(mode = 'numeric',  length = n)), n_features) %>%
    map(rnorm) 
  
  names(list) <- paste0("X", as.character(seq(1, n_features)))
  
  X <- bind_rows(list)
  
  # Create outcome
  if (outcome == "binary") {
    Y <- as.factor(rbernoulli(n))
  } else if (outcome == "continuous") {
    Y <- rnorm(n) 
  }
  
  Y <- data.frame(Y = Y)
  data <- bind_cols(X, Y)
  return(data)
}

# Create benchmarking test for default settings
runDefaultTest <- function(data) {
  test <- microbenchmark(
    'randomForest' = {
      randomForest(Y ~ ., data = data,
                   ntree = 500,
                   mtry = floor(sqrt(dim(data)[2])))
    },
    'ranger' = {
      ranger(Y ~ ., data = data,
             num.trees = 500,
             mtry = floor(sqrt(dim(data)[2])))
    },
    'Rborist' = {
      Rborist(x = data[, grep("^X.*", names(data))], y = unlist(data[, "Y"]),
              nTree = 500,
              predFixed = floor(sqrt(dim(data)[2])))
    },
    times = 100
  )
  
  test %<>% group_by(expr) %>% summarise(mean_time = mean(time) / 1e9)
  
  return(test)
}

# Create test for optimized settings
runOptTest <- function(data) {
  test <- microbenchmark(
    'randomForest' = {
      randomForest(Y ~ ., data = data,
                   ntree = 500,
                   mtry = floor(sqrt(dim(data)[2])),
                   proximity = FALSE,
                   keep.forest = FALSE)
    },
    'ranger' = {
      ranger(Y ~ ., data = data,
             num.trees = 500,
             mtry = floor(sqrt(dim(data)[2])),
             write.forest = FALSE)
    },
    'Rborist' = {
      Rborist(x = data[, grep("^X.*", names(data))], y = unlist(data[, "Y"]),
              nTree = 500,
              predFixed = floor(sqrt(dim(data)[2])),
              noValidate = TRUE,
              thinLeaves = TRUE)
    },
    times = 100
  )
  
  test %<>% group_by(expr) %>% summarise(mean_time = mean(time) / 1e9)
  
  return(test)
}