##############################################################
### Title: "Week 4 - Randomized Controlled Trials"
### Course: STA 235H
### Semester: Fall 2021
### Professor: Magdalena Bennett
##############################################################

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

## Are Emily and Greg More Employable Than Lakisha and Jamal? Example of an audit study

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week4/2_RCT/data/lakisha_aer.csv")

# Some variables of interest

# education: 0 = not reported; 1 = HSD; 2 = HSG; 3 = Some college; 4 = college +
# ofjobs: Number of jobs listed on resume
# yearsexp: Years of experience
# computerskills: Applicant lists computer skills
# sex: sex of the applicant (according to name)
# race: race-sounding name
# h: high quality resume
# l: low quality resume
# city: c = chicago, b = boston
# call: applicant was called back



## Let's assume we are only interested in the "race" treatment. Create a variable treat = 1 if race = "b" and 0 if race = "w"

d <- d %>% mutate(treat = ifelse(race == "b", 1, 0))

## Q: How many treated observations are there? And how many control?

d %>% group_by(treat) %>% count() # group_by() groups your data according to the different levels of the variables in the argument (in this case, treat).



## Let's check if randomization was done correctly: Balance table

d_bal <- d %>% select(treat, education, ofjobs, yearsexp, computerskills, h, l, city)

datasummary_balance(~ treat, data = d_bal, title = "Balance table", fmt=2, dinm_statistic = "p.value") # Q: Does education make sense as a continuous variable?


# Note that you can obtain the same values for the balance table using tidyverse code:

d_bal %>% group_by(treat) %>% summarize(across(.cols = everything(), .fns = mean)) #across() tells the summarize() function which variables (.cols) to use for summarizing (in this case, everything). We want to get the mean of each variable for treat = 0 and treat = 1. You can change mean for any other variable that you're interested in.
# Q: Why does city return an NA value?


# Let's transform education in a factor variable

d_bal <- d %>% mutate(education = factor(education)) %>% select(treat, education, ofjobs, yearsexp, computerskills, h, l, city)

datasummary_balance(~ treat, data = d_bal, title = "Balance table", fmt=2, dinm_statistic = "p.value")

# Task: Using the code seen in the previous code (beauty in the classroom example), build binary variables for each level of education. Is the difference between groups statistically significant?



## Now, let's run a simple model

summary(lm_robust(call ~ treat, data = d)) # We use lm_robust() instead of lm() for binary outcomes to get the correct standard errors (we will see this in following classes).

# Q: What is the estimand we are estimating? Comment your results.

# Now, let's add covariates

summary(lm_robust(call ~ treat + factor(education) + ofjobs + yearsexp + computerskills + h + factor(city), data = d))

# Q: Does the point estimate change? Why or why not?
# Q: What about the SE? 