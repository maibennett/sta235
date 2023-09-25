################################################################################
### Title: "Week 6 - Randomized Controlled Trials II and Observational Studies"
### Course: STA 235H
### Semester: Fall 2023
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
#install.packages(MatchIt)
library(MatchIt)

## Get Out the Vote study

# If you're running this at home, this is the complete data from the study, if you want to load it:
#d = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/1_ObsStudies/data/voters_covariates.csv")

# If you're running this live in class, load this dataset (smaller dataset from the entire study):
d = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/1_ObsStudies/data/sample_gotv.csv")

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

# Drop variables with unlisted phone numbers, and we will not be using `treat_pseudo`

d %>% count(is.na(treat_real))

d_s1 = d %>% filter(!is.na(treat_real)) %>% select(-treat_pseudo)

# Just for performance purposes, we will use a smaller sample of the original data (just looking at one stratum):
d_s1 = d_s1 %>% filter(state == 1 & competiv == 1)

####### 1. Check for balance

# Create a dataset to check for balance. 
d_s1_bal = d_s1 %>% select(-vote02, -contact)
  
  #COMPLETE

datasummary_balance(~ treat_real, data = d_s1_bal, 
                    dinm_statistic = "p.value", fmt = 3) #COMPLETE
# Q: Is this study balanced? How can you know?



####### 2. Estimate the causal effect

lm1 = lm_robust(vote02 ~ treat_real, data = d_s1)
summary(lm1)

# COMPLETE CODE


################################################################################
##### OBSERVATIONAL STUDY ######################################################
## In this section, we are going to be working with observational data, meaning that there is no random assignment.
## In this case, then, the treatment variable will be "contact", and not treat_real. 
## Imagine a firm that is just calling a bunch of numbers
## and can reach some of them and not others.
################################################################################

# Let's first get the simple difference in means between these two groups
# (Remember that contact is not randomized!)

summary(lm_robust(vote02 ~ contact, data = d_s1))

# Q: Interpret this coefficient. Is this a causal effect?

# Let's add some covariates now:
summary(lm_robust(vote02 ~ contact + persons + vote00 + vote98 + newreg + age + female2, data = d_s1))

# Q: What happened here? Why did the estimate change?


# Let's do some matching now. We will be using the MatchIt package (it's very complete)

# The formula inside matchit() is the treatment (contact, which is different to the treatment assignment) as a function of the covariates. 
# If we had different strata, you would need to add that, too.
# We will just use Nearest Neighbor matching first.

# Note that the arguments in the matchit() function are the formula (just like in lm(), I include all the covariates I want to control for)
# I also give matchit the sample I want to use with data = 
# The method then it's important. There are different kind of methods, but here we are using "nearest", which refers to nearest neighbor matching 
# (looks for the closest neighbor in terms of propensity score and matches it to that!)
# This is optional, but I'm asking the function to match exactly on state (meaning, I can only find a treated unit for a control unit within the same state)
# Finally, I'm also setting a caliper of 0.2. This means that, at most, treated and control matched units can be 0.2 units apart (this will reduce our sample size, but improve the matching)

m1 = matchit(contact ~ persons + vote00 + vote98 + newreg + 
               age + female2, data = d_s1,
             method = "nearest", exact = ~ state, caliper = 0.2)

# Let's check balance before and after matching (focus on the first three columns)
summary(m1)

# Now, let's get our matched data:
d_m1 = match.data(m1)

# Check whether it looks good:
d_m1 %>% select(contact) %>% table() #Same number of treatment and controls!

# Let's check for balance
d_m1_bal = d_m1 %>% select(contact, persons,vote00,vote98,newreg,age,female2)

datasummary_balance(~ contact, data = d_m1_bal, fmt = 3, dinm_statistic = "p.value")

# Q: What about balance for the unmatched sample, d_sample? How does that look?

# Let's now run the simple regression of our outcome on our treatment variable 
# using the matched data:

lm_match = # COMPLETE


#Q: Why are we running a simple regression and not including covariates?
#Q: Interpret the results. What do we find here?

# Finally, let's compare the previous results with OLS (line 81).
# Q: Should we get the same results? Why or why not? (look both at the point estimate and the significance)
