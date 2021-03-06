################################################################################

getNextR <- function(X, R.old, ind.train, block.size,
                     vec.center, vec.scale, use.Eigen) {
  n <- length(ind.train)
  m <- ncol(X)
  L <- nrow(R.old)
  R <- matrix(NA, L, m)
  G <- matrix(0, L, n)

  intervals <- CutBySize(m, block.size)
  nb.block <- nrow(intervals)

  for (j in 1:nb.block) {
    ind <- seq2(intervals[j, ])
    tmp <- scaling(X[ind.train, ind], vec.center[ind], vec.scale[ind])

    G <- incrMat(G, tcrossprod(R.old[, ind], tmp)) # use.Eigen
  }

  for (j in 1:nb.block) {
    ind <- seq2(intervals[j, ])
    tmp <- scaling(X[ind.train, ind], vec.center[ind], vec.scale[ind])

    R[, ind] <- mult(G, tmp, use.Eigen)
  }

  R <- R / m
  # MSE <- mean((R - R.old)^2)
  # list(R = R, MSE = MSE)
}

################################################################################

BigMult2 <- function(X, mat, ind.train, block.size,
                     vec.center, vec.scale, use.Eigen) {
  res <- matrix(0, length(ind.train), ncol(mat))

  intervals <- CutBySize(ncol(X), block.size)
  nb.block <- nrow(intervals)

  for (j in 1:nb.block) {
    ind <- seq2(intervals[j, ])
    tmp <- scaling(X[ind.train, ind], vec.center[ind], vec.scale[ind])
    if (use.Eigen) {
      res <- incrMat(res, multEigen(tmp, mat[ind, ]))
    } else {
      res <- incrMat(res, tmp %*% mat[ind, ])
    }
  }

  res
}

################################################################################

BigMult3 <- function(mat, X, ind.train, block.size,
                     vec.center, vec.scale, use.Eigen) {
  m <- ncol(X)
  res <- matrix(0, nrow(mat), m)

  intervals <- CutBySize(m, block.size)
  nb.block <- nrow(intervals)

  for (j in 1:nb.block) {
    ind <- seq2(intervals[j, ])
    tmp <- scaling(X[ind.train, ind], vec.center[ind], vec.scale[ind])

    res[, ind] <- mult(mat, tmp, use.Eigen)
  }

  res
}

################################################################################

#' A randomized algorithm for SVD.
#'
#' A randomized algorithm for SVD (or PCA) of a "big.matrix".
#'
#' @inherit bigstatsr-package params
#' @param K Number of PCs to compute. This algorithm shouldn't
#' be used to compute a lot of PCs. Default is `10`.
#' @param I The number of iterations of the algorithm. Default is `10`.
#' @param backingpath If `X` is filebacked and parallelism is used,
#' the path where are stored the files that are backing `X`.
#'
#' @return
#' @export
#'
#' @example examples/example-randomSVD.R
#' @seealso [big_funScaling] [prcomp] [svd]
#' @references Rokhlin, V., Szlam, A., & Tygert, M. (2010).
#' A Randomized Algorithm for Principal Component Analysis.
#' SIAM Journal on Matrix Analysis and Applications, 31(3), 1100–1124.
#' doi:10.1137/080736417
big_randomSVD2 <- function(X, fun.scaling,
                           ind.train = seq(nrow(X)),
                           block.size = 1e3,
                           K = 10, max.I = 20,
                           use.Eigen = TRUE) {
  check_X(X)
  stopifnot((ncol(X) - K) >= ((max.I + 1) * (K + 12)))

  # parameters
  L <- K + 12
  n <- length(ind.train)
  m <- ncol(X)

  # scaling
  stats <- fun.scaling(X, ind.train)
  means <- stats$mean
  sds <- stats$sd
  rm(stats)

  # computation of G and H
  R <- list()
  R[[1]] <- BigMult3(mat = matrix(rnorm(L * n), L, n), # G0
                     X, ind.train, block.size,
                     means, sds, use.Eigen) # R0
  i <- 1
  MSE.old <- Inf
  while(i <= max.I) {
    R[[i+1]] <- getNextR(X, R[[i]], ind.train,
                    block.size, means, sds,
                    use.Eigen)
    mylm <- lm(as.numeric(R[[i+1]]) ~ as.numeric(R[[i]]) - 1)
    print(r2 <- summary(mylm)$r.squared)
    if (r2 > (1 - 1e-8)) {
      printf("Stop after %d interations\n", i)
      break
    }
    i <- i + 1
  }

  #return(t(do.call(rbind, R)))

  # svds
  H.svd <- svd(t(do.call(rbind, R)), nv = 0) # m * L * I or just V
  rm(R); gc()

  T.t <- BigMult2(X, H.svd$u, ind.train, block.size, means, sds,
                  use.Eigen = use.Eigen)
  T.svd <- svd(T.t, nu = K, nv = K)

  list(d = T.svd$d[1:K], u = T.svd$u, v = H.svd$u %*% T.svd$v,
       means = means, sds = sds)
}

### mini test:
# H <- list()
# l <- list(a = matrix(1:4, 2), b = matrix(5:8, 2))
# H[1] <- l["a"]
# l <- list(a = matrix(11:14, 2), b = matrix(5:8, 2))
# H[2] <- l["a"]

