library(tidyverse)
library(modelsummary)
library(estimatr)
library(truncnorm)

set.seed(100)

n <- 3426

treat <- 0.6

n_treat <- round(n*treat,0)

n_control <- n - n_treat

city_treat <- sample(c("NY","CA"), n_treat, replace=TRUE)

city_control <- rep("Other", n_control)

treat <- c(rep(1,n_treat),rep(0,n_control))
city <- c(city_treat,city_control)

income <- rep(0,n)

income[treat==1 & city =="NY"] <- rtruncnorm(length(income[treat==1 & city =="NY"]), a = 15000, b = 350000, mean = 82000, sd = 12000)
income[treat==1 & city =="CA"] <- rtruncnorm(length(income[treat==1 & city =="CA"]), a = 10000, b = 400000, mean = 86000, sd = 15000)
income[treat==0 & city =="Other"] <- rtruncnorm(length(income[treat==0 & city =="Other"]), a = 10000, b = 280000, mean = 63000, sd = 14000)


employed <- rep(NA,n)

employed[treat==1 & city =="NY"] <- sample(c(0,1), size = length(employed[treat==1 & city =="NY"]), replace = TRUE, prob = c(0.07,0.93))
employed[treat==1 & city =="CA"] <- sample(c(0,1), size = length(employed[treat==1 & city =="CA"]), replace = TRUE, prob = c(0.05,0.95))
employed[treat==0 & city =="Other"] <- sample(c(0,1), size = length(employed[treat==0]), replace = TRUE, prob = c(0.1,0.9))

female <- sample(c(0,1), n, replace = TRUE)

subscribed0 <- rep(NA,n)

subscribed0[treat==0] <- sample(c(0,1), n_control, replace = TRUE, prob = c(0.51,0.49))

subscribed0[treat==1] <- sample(c(0,1), n_treat, replace = TRUE, prob = c(0.45,0.55))


subscribed1 <- rep(NA,n)

subscribed1[treat==0 & subscribed0==0] <- sample(c(0,1), length(subscribed1[treat==0 & subscribed0==0]), 
                                                                  replace = TRUE, prob = c(0.94,0.05))

subscribed1[treat==1 & subscribed0==0] <- sample(c(0,1), length(subscribed1[treat==1 & subscribed0==0]), 
                                                                  replace = TRUE, prob = c(0.80,0.2))


netflix <- data.frame(id = c(seq(1:n), seq(1:n)),
                      state = c(city, city),
                      income = c(income, income),
                      employed = c(employed, employed),
                      female = c(female, female),
                      subscribed = c(subscribed0, subscribed1),
                      survey = c(rep("April2022", n),rep("July2022", n)))

write.csv(netflix, file = "netflix.csv", row.names = FALSE)

netflix <- netflix %>% mutate(treat = ifelse(state=="Other", 0, 1),
                             post = ifelse(survey=="April2022", 0, 1))

summary(lm_robust(subscribed ~ treat*post, data = netflix))
