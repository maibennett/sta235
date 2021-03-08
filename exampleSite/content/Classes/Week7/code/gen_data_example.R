
library(purrr)
library(wakefield)

set.seed(100)

n = 2000

id = seq(1,2000)

treat = c(rep(1,1000),rep(0,1000))

time = purrr::accumulate(1:2000, ~ .x +runif(1,0,0.5), .init = 1.05)[-2001]

age = 44.59 - time^2*0.0008697 + 0.3934*time + rnorm(2000,0,5)

female = sample(c(0,1), replace = TRUE, size = 2000, prob = c(0.3,0.7))

income = age*1700 + rnorm(2000,0,10000)

income[income<0] = runif(sum(income<0),10000,20000)

