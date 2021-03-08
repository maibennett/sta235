
library(purrr)
library(wakefield)
library(scales)

set.seed(100)

n = 2000

id = seq(1,2000)

treat = c(rep(1,1000),rep(0,1000))

time = purrr::accumulate(1:2000, ~ .x +runif(1,0,0.5), .init = 1.05)[-2001]

age = 44.59 - time^2*0.0008392 + 0.3905*time + rnorm(2000,0,15)

age = round(rescale(age,to= c(16,84)),0)

female = sample(c(0,1), replace = TRUE, size = 2000, prob = c(0.3,0.7))

income = age*1400 + rnorm(2000,0,10000)

income[income<0] = runif(sum(income<0),10000,20000)

sales = 125 + treat*30*(1 + -(time-259.6752)*0.005) + (income-50000)*0.00125 + rnorm(2000,0,10)


d = data.frame("id" = id,
              "time" = time,
              "age" = age,
              "female" = female,
              "income" = income,
              "sales" = sales,
              "treat" = treat)

ggplot(data = d, aes(x = time, y = treat)) +
  geom_point()

ggplot(data = d, aes(x = time, y = sales)) +
  geom_point()


rdplot(sales,time,c=259.6752)