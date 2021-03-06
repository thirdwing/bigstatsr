#' @import bigmemory
#' @useDynLib bigstatsr
#' @importFrom Rcpp sourceCpp
#'
#' @param X A [big.matrix][bigmemory::big.matrix-class].
#' You shouldn't have missing values in your data.
#'
#' @param y Vector of responses.
#'
#' @param ind.train An optional vector of the row indices that are used,
#' for the training part. If not specified, all data are used.
#'
#' @param block.size Maximum number of columns read at once.
#' Default is `1000`.
#'
#' @param ncores Number or cores used. Default doesn't use parallelism.
#'
#' @param fun.scaling A function that returns a named list of
#' __`mean`__ and __`sd`__ for every column, to scale each of their elements
#' such as followed: \deqn{\frac{X_{i,j} - mean_j}{sd_j}}.
#'
#' @param use.Eigen Should the `Eigen` library be used
#' for matrix computations? Default tries to detect MRO. See details.
#' @details For matrix computations, using \code{Eigen} library is faster.
#' However, if you link \code{R} with an optimized math library,
#' using \code{R}'s base operations is even much faster.
#'
#' For example, you can easily link \code{R} with the
#' \href{https://software.intel.com/en-us/intel-mkl}{Intel®
#' Math Kernel Library} (Intel® MKL) through
#' \href{https://mran.revolutionanalytics.com/open/}{Microsoft
#' R Open} (MRO). It really improves performance
#' of \code{R} and \code{RcppArmadillo} matrix computations,
#' yet not the ones of \code{RcppEigen} (at least not directly).
#'
#' So, \enumerate{
#' \item \code{Eigen} should be prefered if you don't change anything,
#' \item base \code{R} should be prefered if you use MRO,
#' \item \code{Eigen} may be prefered if you manage to link \code{RcppEigen}
#' with the MKL (please \href{mailto:florian.prive.21@gmail.com}{contact me}
#' if you do!).}
"_PACKAGE"
