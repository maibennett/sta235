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
library(optmatch)

# The formula inside matchit() is the treatment (contact, which is different to the treatment assignment) as a function of the covariates. 
# If we had different strata, you would need to add that, too.
# We will just use Nearest Neighbor matching first.

# Note that the arguments in the matchit() function are the formula (just like in lm(), I include all the covariates I want to control for)
# I also give matchit the sample I want to use
# The method then it's important. There are different kind of methods, but here we are using "nearest", which refers to nearest neighbor matching 
# (looks for the closest neighbor in terms of propensity score and matches it to that!)
# This is optional, but I'm asking the function to match exactly on state (meaning, I can only find a treated unit for a control unit within the same state)
# Finally, I'm also setting a caliper of 0.2. This means that, at most, treated and control matched units can be 0.2 units apart (this will reduce our sample size, but improve the matching)

m1 <- matchit(contact ~ persons + vote00 + vote98 + newreg + age + female2, data = d_sample,
              method = "nearest", exact = ~ state, caliper = 0.2)

# Let's check balance before and after matching (focus on the first three columns)
summary(m1)

# Now, let's get our matched data:
d_m1 <- match.data(m1)

# Check whether it looks good:
d_m1 %>% select(contact) %>% table() #Same number of treatment and controls!

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

###########################################################################
#### EXERCISE #############################################################
###########################################################################

# Data for student's evaluations (at the professor level) for UT Austin

profs <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/1_ObsStudies/data/profs.csv",
                  stringsAsFactors = TRUE)

head(profs)

# Variables:
# minority: Is the professor from a minority?
# age: age in years
# gender: professor's gender
# credits: single credits or more
# beauty: beauty rating (normalized to mean 0 SD 1)
# eval: student's evaluation
# division: upper or lower division course
# native: Is the professor a native English speaker?
# tenure: Does the professor have tenure?
# students: Number of students that respond the survey
# allstudents: Total number of students
# prof: professor's ID.


# We will transform factor variables into binary (numeric) variables. Remember to always check what the base category is!!
profs <- profs %>% mutate(treat = as.numeric(beauty > 0),
                          female = 2 - as.numeric(gender), # Notice that gender has two levels: (1) female and (2) male. First, we transform it to numeric, and then substract it from 2 (notice that now we will get a binary variable with 1 for female and 0 for male)
                          single_credit = as.numeric(credits)-1,
                          upper_div = as.numeric(division)-1,
                          native = as.numeric(native)-1,
                          tenure = as.numeric(tenure)-1,
                          minority = as.numeric(minority)-1) 

# Question 1: 
# Run a simple regression between eval (outcome) and treat (beauty above the mean). 
# Interpret the coefficient of interest. Can we say it's a causal effect?

# Question 2:
# Match professors based on female, native, single_credit, tenure, minority, allstudents, and age. Run a regression on the matched sample between eval (outcome) and treat.
# Interpret the coefficient of interest. Can we say it's a causal effect?

# Use this template (complete where required)

m2 <- matchit(#COMPLETE,
              method = "nearest", caliper = 0.2)

# Get matched data


# Run simple regression
