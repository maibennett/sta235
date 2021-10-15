################################################################################
### Title: "Midterm - Practice exercises"
### Course: STA 235H
### Semester: Fall 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

library(tidyverse)
library(estimatr)
library(ggplot2)
library(modelsummary)

### 1. How much does being a celebrity pay?

parade <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Midterm_Review/data/Parade2005.csv")

head(parade)

summary(lm(earnings ~ age + gender + celebrity, data = parade))

summary(lm(earnings ~ age + gender*celebrity, data = parade))

### 2. Math matters!

math <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Midterm_Review/data/math_reform.csv")

head(math)

# class: Year of the high-school class
# state: Name of the state
# reform_math: Whether there was a reform of compulsory math for that class.
# reformyr_math: Year that the math reform was implemented.
# incearn_ln: logarithm of average income earnings for the class.


# Estimate a difference-in-differences model using this data, for the first early adopting state: North Dakota in 1984. 
# What is the effect of the math reform on the logarithm of income?

# We will focus on the period up to 1986. What do we do?

math_before1987 <- math %>% filter(class<=1986)

# Let's drop those states that adopted reforms after 1984 but before or on 1986:

math_before1987 %>% filter(reformyr_math>1984 & reformyr_math<=1986) %>% group_by(state) %>% count()

drop_states <- c("Alabama", "Alaska", "District of Columbia", "West Virginia", "Nevada") # Complete

math_before1987 <- math_before1987 %>% filter(!(state %in% drop_states))
  
# Estimate the effect of adopting this reform on income

math_before1987 <- math_before1987 %>% mutate(treat = ifelse(state == "North Dakota", 1, 0),
                                              post = ifelse(class>=1984, 1, 0))

summary(lm(incearn_ln ~ treat*post, data = math_before1987))
