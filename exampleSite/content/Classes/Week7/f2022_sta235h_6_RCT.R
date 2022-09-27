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


#############################################

# Just for performance purposes, we will use a smaller sample of the original data (just looking at one stratum):
d_sample <- d_s1 %>% filter(state == 1 & competiv == 1)

## In this section, we are going to be working with observational data, meaning that there is no random assignment.
## In this case, then, the treatment variable will be "contact", and not treat_real. Imagine a firm that is just calling a bunch of numbers
## and can reach some of them and not others.

#############################################

# Let's do some matching now. We will be using the MatchIt package (it's very complete)

#install.packages(MatchIt)
library(MatchIt)

# The formula inside matchit() is the treatment (contact, which is different to the treatment assignment) as a function of the covariates. Remember to include the strata!
# We will just use NN matching first, and exact match on strata.
# Question: We don't include state here, why? 

# Note that the arguments in the matchit() function are the formula (just like in lm(), I include all the covariates I want to adjust for)
# I also give matchit the sample I want to use
# The method then it's important. There are different kind of methods, but here we are using "nearest", which refers to nearest neighbor matching 
# (looks for the closest neighbor in terms of propensity score and matches it to that!)
# This is optional, but I'm asking the function to match exactly on strata (meaning, I can only find a treated unit for a control unit within the same strata)
# Finally, I'm also setting a caliper of 0.2. This means that, at most, treated and control matched units can be 0.2 units apart (this will reduce our sample size, but improve the matching)

m1 <- matchit(contact ~ persons + vote00 + vote98 + newreg + age + female2, data = d_sample,
              method = "nearest", exact = ~ strata, caliper = 0.2)

#m1$match.matrix stores the indexes (rows) for the matched control units (notice that they are stored as strings, so we need to transform them to numeric!)
head(m1$match.matrix)

#We will save both the treatment and control index: (Note: as.numeric(x) basically transforms a variable to numeric)
t_id <- as.numeric(rownames(m1$match.matrix)) #We extract the rownames from the matrix, and convert it to numeric
c_id <- as.numeric(m1$match.matrix)

# Generate a data frame only with the matched units:
d_m1 <- d_sample %>% slice(c(t_id, c_id)) # Slice subsets the data according to row numbers 
# Q: How many observations should d_m1 have? Why?

# Check whether it looks good:
d_m1 %>% group_by(contact) %>% count() #Same number of treatment and controls!

# Let's check for balance
d_m1_bal <- d_m1 %>% select(contact, persons,vote00,vote98,newreg,age,female2)

datasummary_balance(~ contact, data = d_m1_bal, fmt = 3, dinm_statistic = "p.value")

# Q: What about balance for the unmatched sample, d_sample? How does that look?

# Let's now run the simple regression of our outcome on our treatment variable:
summary(lm_robust(vote02 ~ contact, data = d_m1))

#Q: Interpret the results. What do we find here?


# Finally, let's compare the previous results with simple OLS.
# Q: Should we get the same results? Why or why not? (look both at the point estimate and the significance)

summary(lm_robust(vote02 ~ contact + persons + vote00 + vote98 + newreg + age + female2, data = d_sample))

# Q: Do you think the CIA holds in this case? Why or why not?