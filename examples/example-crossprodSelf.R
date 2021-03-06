# Simulating some data
X <- big.matrix(41, 17)
X[] <- rnorm(length(X))

# Comparing with tcrossprod
big_noscale <- big_scale(center = FALSE)
test <- big_crossprodSelf(X, fun.scaling = big_noscale)
print(dim(test$K))
print(all.equal(test$K, crossprod(X[,])))

# Using only half of the data for "training"
ind <- sort(sample(nrow(X), nrow(X)/2))
test2 <- big_crossprodSelf(X, fun.scaling = big_noscale,
                           ind.train = ind)
print(dim(test2$K))
print(all.equal(test2$K, crossprod(X[ind, ])))
