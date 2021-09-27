################################################################################
### Title: "Week 5 - Randomized Controlled Trials II and Observational Studies"
### Course: STA 235H
### Semester: Fall 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(ggplot2)
#install.packages(estimatr)
library(estimatr)
library(modelsummary)

## Get Out the Vote study

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week5/1_RCT/data/voters_covariates.csv")

# Some variables of interest

# persons: Number of voters in the household (1 or 2)
# competiv: Wether the district is competitive or not
# vote*: Whether the person voted in year *
# newreg: Whether the person is newly registered as a voter or not
# age: Age of the person
# contact: Whether the household was contacted (1) or not (0)
# treat_real: Whether the household was randomized into treatment (1) or not (0). If NA, the household was not part of the randomization sample.
# state: Variable for the state.
# female2: Whether the person is female or not.

# Drop variables with unlisted phone numbers
d_s1 <- d %>% filter(!is.na(treat_real))

# 1) Check for balance

# For each strata (they should be comparable within strata)

d_s1_bal <- d_s1 %>% mutate(treat_strata = interaction(factor(treat_real),factor(competiv),factor(state))) %>%
  select(-c(vote02, competiv, state, treat_real, treat_pseudo))

datasummary_balance(~ treat_strata, data = d_s1_bal, dinm_statistic = "p.value")
# Q: What do the column names mean? (e.g. what is 0.1.0 mean?)

d_s1_bal2 <- d_s1 %>% select(-c(vote02, competiv, state, treat_pseudo))

datasummary_balance(~ treat_real, data = d_s1_bal2, dinm_statistic = "p.value")
# Q: What do the column names mean? (e.g. what is 0.1.0 mean?)

# 2) Let's estimate the effect

library(estimatr) # We are using lm_robust() because we have a binary variable as an outcome.

d_s1 <- d_s1 %>% mutate(strata = interaction(state, competiv))

summary(lm_robust(vote02 ~ treat_real + strata, data = d_s1))

# Q: What can you say about this evidence? Interpret the coefficient of interest.

# Q: What do you think will happen if we add covariates?

summary(lm_robust(vote02 ~ treat_real + strata + vote00 + vote98 + age + female2, data = d_s1))



## Let's now check the observable data: