################################################################################
### Title: "Week 6 - Randomized Controlled Trials II and Observational Studies"
### Course: STA 235H
### Semester: Fall 2022
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(estimatr)
library(modelsummary)

## Get Out the Vote study

# If you are loading this in class, you might be better loading the second file (it's just a smaller version of the same dataset)

# If you're running this at home, load this (complete data):
#d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/1_RCT/data/voters_covariates.csv")

# If you're running this live in class, load this dataset:
d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/1_RCT/data/sample_gotv.csv")

# Drop this first variable (row names)
d <- d %>% select(-X)

# Some variables of interest

# persons: Number of voters in the household (1 or 2)
# competiv: Wether the district is competitive or not (1: No, 2: Yes)
# vote*: Whether the person voted in year * (vote00 and vote98 were before the randomization, vote02 was after)
# newreg: Whether the person is newly registered as a voter or not
# age: Age of the person
# contact: Whether the household was contacted (1) or not (0)
# treat_real: Whether the household was randomized into treatment (1) or not (0). If NA, the household was not part of the randomization sample.
# state: Variable for the state (0 and 1).
# female2: Whether the person is female or not.

# Drop variables with unlisted phone numbers
d_s1 <- d %>% filter(!is.na(treat_real))

####### 1. Check for balance

# Create a dataset to check for balance. Remember to check for balance for each strata (they should be comparable within strata)

# Transform competiv into a binary variable, and create two variables for state:
d_s1 <- d_s1 %>% mutate(competiv = competiv - 1,
                        stateA = ifelse(state==1, 1, 0))

# Create strata variables: Interaction between state and competitiveness level.
# Also, we will create the interaction between state, competitiveness level, AND treatment level
d_s1 <- d_s1 %>% mutate(strata = interaction(stateA, competiv),
                        strata_treat = interaction(treat_real, stateA, competiv))

# Create a dataset for balance:
d_s1_bal <- d_s1 %>% select(strata_treat, persons, vote00, vote98, newreg, age, female2, fem_miss)

datasummary_balance(~ strata_treat, data = d_s1_bal, dinm_statistic = "p.value")
# Q: What do the column names mean? (e.g. what is 0.1.0 mean?)

# What if we wanted to see p-values *within strata?*

# 1) See which strata do I have?
d_s1 %>% select(strata) %>% table()

# 2) Create a dataset for each stratum
d_s1_bal_s1 <- d_s1 %>% filter(strata=="0.0") %>% select(treat_real, persons, vote00, vote98, newreg, age, female2, fem_miss)

# 3) Create the balance table for the stratum
datasummary_balance(~ treat_real, data = d_s1_bal_s1, dinm_statistic = "p.value", fmt=3)
#Q: Can you do this for other strata?


####### 2. Estimate the causal effect

summary(lm_robust(vote02 ~ treat_real + strata, data = d_s1)) # We are using lm_robust() because we have a binary variable as an outcome.

# Q: What can you say about this evidence? Interpret the coefficient of interest.

# Q: What do you think will happen if we add covariates?

summary(lm_robust(vote02 ~ treat_real + strata + vote00 + vote98 + age + female2, data = d_s1))
