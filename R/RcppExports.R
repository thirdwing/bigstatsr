# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

bigcolvars <- function(pBigMat, rowInd) {
    .Call('bigstatsr_bigcolvars', PACKAGE = 'bigstatsr', pBigMat, rowInd)
}

transpose3 <- function(pBigMat, pBigMat2) {
    invisible(.Call('bigstatsr_transpose3', PACKAGE = 'bigstatsr', pBigMat, pBigMat2))
}

univRegLin <- function(pBigMat, y, rowInd) {
    .Call('bigstatsr_univRegLin', PACKAGE = 'bigstatsr', pBigMat, y, rowInd)
}

univRegLin2 <- function(pBigMat, covar, y, rowInd) {
    .Call('bigstatsr_univRegLin2', PACKAGE = 'bigstatsr', pBigMat, covar, y, rowInd)
}

multEigen <- function(X, Y) {
    .Call('bigstatsr_multEigen', PACKAGE = 'bigstatsr', X, Y)
}

crossprodEigen5 <- function(X, Y) {
    .Call('bigstatsr_crossprodEigen5', PACKAGE = 'bigstatsr', X, Y)
}

scaling <- function(source, mean, sd) {
    .Call('bigstatsr_scaling', PACKAGE = 'bigstatsr', source, mean, sd)
}

complete2 <- function(mat) {
    .Call('bigstatsr_complete2', PACKAGE = 'bigstatsr', mat)
}

incrSup2 <- function(mat, source) {
    .Call('bigstatsr_incrSup2', PACKAGE = 'bigstatsr', mat, source)
}

tcrossprodEigen3 <- function(res, bM) {
    invisible(.Call('bigstatsr_tcrossprodEigen3', PACKAGE = 'bigstatsr', res, bM))
}

incrMat <- function(dest, source) {
    .Call('bigstatsr_incrMat', PACKAGE = 'bigstatsr', dest, source)
}

