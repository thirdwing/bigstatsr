################################################################################

# Global variables
ALL.TYPES <- c("char", "short", "integer", "float", "double")

ERROR_BIGMATRIX <- "X must be a big.matrix."

# also defined in src/utils.h
ERROR_TYPE <- "unknown type detected for big.matrix object!"

################################################################################

check_X <- function(X, y = NULL, y.type = "null") {
  if (class(X) != "big.matrix")
    stop(ERROR_BIGMATRIX)
}

################################################################################

detect_MRO <- function() {
  is.element("RevoUtilsMath", rownames(utils::installed.packages()))
}

################################################################################

# function for comparing PCs
diffPCs <- function(test, rot) {
  k <- ncol(test)
  diff1 <- 2 * abs(test - rot[, 1:k]) / (abs(test) + abs(rot[, 1:k]))
  diff2 <- 2 * abs(test + rot[, 1:k]) / (abs(test) + abs(rot[, 1:k]))
  diff <- pmin(diff1, diff2)
  mean(diff)
}

################################################################################

printf <- function(...) cat(sprintf(...))

################################################################################

CutBySize <- function(m, block.size, nb = ceiling(m / block.size)) {
  int <- m / nb

  upper <- round(1:nb * int)
  lower <- c(1, upper[-nb] + 1)
  size <- c(upper[1], diff(upper))

  cbind(lower, upper, size)
}

################################################################################

seq2 <- function(lims) {
  seq(lims[1], lims[2])
}

################################################################################
