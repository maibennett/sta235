
library(purrr)
library(wakefield)
library(scales)

set.seed(100)

n = 2000

id = seq(1,2000)

time = purrr::accumulate(1:680, ~ .x +runif(1,0,0.5), .init = 1.05)
time2 = sort(runif(80,176,180))
l = 2000-length(time) - length(time2)
time3 = purrr::accumulate(1:l, ~ .x +runif(1,0,0.5), .init = 180.1)
time = c(time, time2, time3)[1:2000]

treat = as.numeric(time<=180)

age = 44.59 - time^2*0.0008392 + 0.3905*time + rnorm(2000,0,15)

age = round(rescale(age,to= c(16,84)),0)

female = sample(c(0,1), replace = TRUE, size = 2000, prob = c(0.3,0.7))

income = age*1400 - 10000*treat + rnorm(2000,0,10000)

income[income<0] = runif(sum(income<0),10000,20000)

sales = 125 + treat*30*(1 + -(time-259.6752)*0.005) + (income-50000)*0.00125 + rnorm(2000,0,10)


d = data.frame("id" = id,
              "time" = time,
              "age" = age,
              "female" = female,
              "income" = income,
              "sales" = sales,
              "treat" = treat)

c = 180

ggplot(data = d, aes(x = time, y = treat)) +
  geom_point() +
  geom_smooth(data = filter(d, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(d, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue")

ggplot(data = d, aes(x = time, y = sales)) +
  geom_point() +
  geom_smooth(data = filter(d, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(d, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue")

ggplot(data = d, aes(x = time, y = income)) +
  geom_point() +
  geom_smooth(data = filter(d, time>c), method = "loess", se=TRUE, color = "red", fill = "red") +
  geom_smooth(data = filter(d, time<=c), method = "loess", se=TRUE, color = "blue", fill = "blue")

ggplot(data = d, aes(x = time)) +
  geom_density()

write.csv(d, file = "sales_mod.csv", row.names = FALSE)