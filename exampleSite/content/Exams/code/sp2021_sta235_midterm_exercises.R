################################################################################
### Title: "Midterm - Practice exercises"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")


library(tidyverse)
library(estimatr)
library(designmatch)
library(ggplot2)

### Resume Experiment Data

# Context: RCT where researchers sent fictitious resumes out to employers. They randomized whether the name on the resume
# was a Caucasian sounding name or an African-American sounding name (and whether the name was "female" or "male" sounding as well).
# Paper: Bertrand, M. and Mullainathan, S. (2004). Are Emily and Greg More Employable Than Lakisha and Jamal? A Field Experiment on Labor Market Discrimination. American Economic Review, 94, 991-1013.

library(AER)
# To know what the variables are, you can type ?ResumeNames on the console
data("ResumeNames")

head(ResumeNames)

#1) Create a new variable, call_num, which has a value of 1 if resume received a call-back and 0 in other case.


#2) Check the balance in covariates for jobs, experience, quality, city, and holes according to the ethnicity treatment. What do you see? Use the ResumeNames_cov dataset for simplicity.

ResumeNames_covs <- ResumeNames %>% dplyr::select(experience, quality, city, holes) %>%
  mutate(quality_high = as.numeric(quality) - 1,
         boston = ifelse(city=="boston",1,0),
         holes_yes = as.numeric(holes) - 1) %>% # Create numeric variables for the factor variables
  dplyr::select(experience, quality_high, boston, holes_yes)

#experience: years of experience
#quality_high: 1 if quality is high, 0 if its low
#boston: 1 if the city is boston, 0 if it's chicago
#holes_yes: 1 if the resume has holes, 0 if it doesn't 


#3) Fit a linear probability model (LPM) using call_num as the dependent variable and whether the resume had a caucasian or african-american sounding name as the independent variable. Interpret the results.


#4) To the previous model, add experience, city, computer, minimum, and industry. How does the result for the ethnicity "sound" of the name compare to the previous simple linear regression model? Is it what you expect? Explain. 


#5) Now fit a logistic regression for the same model in (3), and estimate the probabilities for an average person in the data. How do they compare? 
# Note: You can use ResumeNames_avg as the new data.

ResumeNames_avg <- ResumeNames %>% select(-call_num) %>% #Keep all variables except the dependent variable
  summarise(across(where(is.numeric), ~mean(.x, na.rm = TRUE)), #If the variable is numeric, we replace it with the mean
            across(where(is.factor), ~factor(names(table(.x))[table(.x)==max(table(.x))], levels = levels(.x)))) #If the variable is a factor, we replace it with the mode

ResumeNames_avg # Look at the average data



###################################################################################################
### Math reform Data

# A data set containing state/year level data on an educational reform and future income. 
# This is an aggregated version of the data used by Goodman (2019, JOLE) to estimate the effect of compulsory high school math coursework on future earnings.
# This policies where at the state level.
# Paper: Goodman, J. (2019). The Labor of Division: Returns to Compulsory High School Math Coursework. JOLE.

library(bacondecomp)
data("math_reform")

head(math_reform)

# class: Year of the high-school class
# state: Name of the state
# reform_math: Whether there was a reform of compulsory math for that class.
# reformyr_math: Year that the math reform was implemented.
# incearn_ln: logarithm of average income earnings for the class.

#1) We want to study the effect of math reform on future earnings, and we will be using a difference-in-differences approach. Identify the two dimensions for a DD analysis in this data.

#2) Estimate a difference-in-differences model using this data. What is the effect of the math reform on the logarithm of income? 

#3) Use the Goodman - Bacon decomposition to decompose the previous result. What comparison has the biggest weight?



#####################################################################################################
### ADA data (Lee, Moretti, and Butler)

#This dataset is collected from the Americans for Democratic Action (ADA) linked with House of Representatives election results for 1946-1995. 
#Authors use the ADA score for all US House representatives from 1946 to 1995 as their voting record index. 
#For each Congress, the ADA chose about twenty-five high-profile roll-call votes and created an index varying from 0 to 100 for each representative. 
#Higher scores correspond to a more "liberal" voting record. The running variable in this study is the vote share. That is the share of all votes that went to a Democrat. 
#ADA scores are then linked to election returns data during that period.

lmb <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Exams/data/lmb_data.csv")

lmb <-lmb %>% dplyr::select(lagdemvoteshare, score, lagdemocrat, democrat, demvoteshare, id, state, year) # only keep the variables we will use

#lagdemvoteshare: democratic vote share in period t
#demvoteshare: democratic vote share in period t+1
#score: "liberal" ADA voting score


# 1) Plot the regression discontinuity design, using the running variable in the X-axis (lagdemvoteshare) and the outcome of interest (demvoteshare) in  the Y-axis. 
# You have to identify the cutoff of interest. Describe the plot and the findings.
# Note: You don't need data for the outcome of interest. You can infer the exact number from the context. Use the rdrobust package for your plot.

library(rdrobust)


# 2) Create a treatment variable (1 if treated and 0 if not) based on the running variable. Also create a variable to measure the distance from the cutoff.


# 3) Use a linear regression to estimate the effect at the discontinuity on devoteshare. You don't have to use any higher polynomial, but you have to allow or the slopes to be different at each side of
# the cutoff. Interpret your results.


# 4) Use rdrobust() function to run the same model as in 3). How do your results differ? Why?

