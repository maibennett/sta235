#Clear memory
rm(list = ls())

#Clear the console
cat("\014")


library(tidyverse)

d <- read.csv("https://raw.githubusercontent.com/jaredsmurray/sta371g_s19/master/docs/data/beauty.csv")

# Imagine there's no real relationship between teaching and beauty (beta1 = 0)
# But being pretty increases self-esteem, and, at the same time, getting good evaluations, also increases self-esteem.
# (beta2 = 0.5 and beta3 = 0.2)

#Let's generate some data!

generateData <- function(n, seed = 123, beta2, beta3){
  
  set.seed(seed)
  
  beauty <- rnorm(n, 5,2)
  teaching_ability <- sample(seq(1,10), n, replace = TRUE)
  
  selfesteem <- beta2*beauty + beta3*teaching_ability + rnorm(n)
    
  return(data.frame(beauty,teaching_ability,selfesteem))
  
}

d <- generateData(n = 1000, beta2 = 0.5, beta3 = 0.01)

summary(lm(teaching_ability ~ beauty + selfesteem, data = d))

summary(lm(teaching_ability ~ beauty, data = d))
