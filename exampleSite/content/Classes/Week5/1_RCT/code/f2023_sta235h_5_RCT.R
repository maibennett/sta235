##############################################################
### Title: "Week 5 - Randomized Controlled Trials"
### Course: STA 235H
### Semester: Fall 2023
### Professor: Magdalena Bennett
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(estimatr)
#install.packages(modelsummary)
library(modelsummary)

## Are Emily and Greg More Employable Than Lakisha and Jamal? Example of an audit study

d = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week5/1_RCT/data/lakisha_aer.csv")

# Some variables of interest

# education: 0 = not reported; 1 = High school dropout (HSD); 2 = High school graduate (HSG); 3 = Some college; 4 = college +
# ofjobs: Number of jobs listed on resume
# yearsexp: Years of experience
# computerskills: Applicant lists computer skills
# sex: gender of the applicant (according to name)
# race: race-sounding name
# h: high quality resume
# l: low quality resume
# city: c = chicago, b = boston
# call: applicant was called back

## Let's assume we are only interested in the "race" treatment. Create a variable treat = 1 if race = "b" and 0 if race = "w"

d = d %>% mutate(treat = ifelse(race == "b", 1, 0))

## Q: How many treated observations are there? And how many control?

d %>% group_by(treat) %>% count() # group_by() groups your data according to the different levels of the variables in the argument (in this case, treat).
# You could also do the same with d %>% group_by(treat) %>% table()

############################ BALANCE CHECK ####################################

## First step is check for balance: This means, make sure baseline covariates 
# are the same between both groups!
## Let's check if randomization was done correctly: Balance table

# We are going to create another dataset that only contains the variables 
# we want to compare (baseline covariates/characteristics + the treatment variable)

# DO NOT INCLUDE POST-TREATMENT VARIABLES
d_bal = d %>% select(treat, education, ofjobs, yearsexp, computerskills, h, l, city)

# We will use datasummary_balance() to get a pretty table
datasummary_balance(~ treat, data = d_bal, title = "Balance table", 
                    fmt=2, dinm_statistic = "p.value") # Q: Does education make sense as a continuous variable?

# The first argument provides the variable for the groups we want to compare (in this case treat=0 and treat=1)
# The second argument is our data
# Third argument is the title of our table (if we want to include one)
# fmt = 2 is an argument to set the number of decimal places we would like for our table (change it to fmt=4 and see what happens!)
# dinm_statistic provides the statistic that is returned to assess the difference between groups. 
# (By default it provides the standard error, but the p.value is easier to assess differences)


# Note that you can obtain the same values for the balance table using tidyverse code, 
# but note that it doesn't teell us if the difference is statistically significant or not!:
d_bal %>% group_by(treat) %>% summarize(across(.cols = everything(), .fns = mean)) 

#across() tells the summarize() function which variables (.cols) to use for summarizing (in this case, everything). We want to get the mean of each variable for treat = 0 and treat = 1. 
# You can change mean for any other statistic that you're interested in (standard deviation, median, etc.).
# Q: Why does city return an NA value?


# Let's transform education in a factor variable

d_bal = d %>% mutate(education = factor(education, labels = c("No Info","HSD","HSG","Some college","College +"))) %>% 
  select(treat, education, ofjobs, yearsexp, computerskills, h, l, city)

datasummary_balance(~ treat, data = d_bal, title = "Balance table", fmt=2, dinm_statistic = "p.value")

# Task: Build binary variables for each level of education 
# (e.g. mutate(educ_no_info = ifelse(education == 0, 1, 0)), and include those binary variables in your balance table. 
# Is the difference between groups statistically significant?

############################ ESTIMATING CAUSAL EFFECT ##########################
## Now, let's run a simple model

summary(lm_robust(call ~ treat, data = d)) #Question: Why do we use lm_robust() and not lm()?

# Q: What is the estimand we are estimating? Comment your results.

# Now, let's add covariates

summary(lm_robust(call ~ treat + factor(education) + ofjobs + yearsexp + computerskills + h + factor(city), data = d))

# Q: Does the point estimate change? Why or why not?


##################### EXCERCISE AT HOME ########################################

# Do the same analysis (balance and estimate the causal effect), but now using
# female vs male sounding name as the treatment variable. Is there an effect?

