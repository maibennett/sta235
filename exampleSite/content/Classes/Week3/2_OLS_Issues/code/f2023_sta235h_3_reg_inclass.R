######################################################################
### Title: "Week 3 - Outliers and Linear Probability Models"
### Course: STA 235H
### Semester: Fall 2023
### Professor: Magdalena Bennett
#######################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")
# scipen=999 removes scientific notation; scipen=0 turns it on.
options(scipen = 0)

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(vtable)
library(AER) #package that includes some interesting data
library(estimatr) #package to run linear regressions with robust SE

################################################################################
######################## In-Class Exercise #####################################
################################################################################

###################### OUTLIERS ################################################

### HMDA Example

# This is the data from 2017 HMDA for Bastrop county (https://www.consumerfinance.gov/data-research/hmda/historic-data/?geo=tx&records=first-lien-owner-occupied-1-4-family-records&field_descriptions=labels)
# (you can also find the whole dataset for Austin by changing the name of the file to hmda_2017_austin.csv)

loans <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/2_OLS_Issues/data/hmda_2017_austin_bastrop.csv", stringsAsFactors = FALSE)

# You can find information about the variables here: https://files.consumerfinance.gov/hmda-historic-data-dictionaries/lar_record_codes.pdf

# Let's look at loans that were approved (action_taken = 1) 
# for home purchase (loan_purpose = 1) (hint: you will need to subset your data)


# Q: How could we see if we have outliers? Create a histogram of loan_amount_000s


# Show a scatter plot of loan amount vs applicant's income:


# Fit a regression line to the previous plot:


# Fit a regression line but *excluding* the clear outliers for income

# Q: Run a regression with and without outliers. Do your results change qualitatively?


###################### LINEAR PROBABILITY MODELS ###############################

data(HMDA) # This dataset is loaded from the AER package

# To know what the variables are, you can type ?HMDA on the console
head(HMDA)

#1) Use ifelse to set it to 1 if deny is "yes" and 0 in another case
HMDA = HMDA %>% mutate(deny_num = ) # COMPLETE THIS

## Linear Probability Model (LPM)

# Q: Run a LPM using deny (the numeric version) as the outcome, and pirat (payment to income ratio), chist (credit history), single, hschool (high school diploma),
# insurance, and race as the covariates.

lm_deny = #COMPLETE THIS
  
# Q: interpret the coefficient for pirat, hschool, and afam.
  
  
#################### EXERCISE ON YOUR OWN ######################################

## Ames Housing dataset: Data for the housing market in Ames, Iowa.
## You can check the codebook here: https://sta235.com/Classes/Week3/2_OLS_Issues/data/ames_codebook.csv

housing <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week3/2_OLS_Issues/data/AmesHousing.csv")

# Only keep single family housing: (Bldg.Type)
housing <- housing %>% filter(Bldg.Type=="1Fam")

# Create 1) a histogram for Lot Area and 2) a scatter plot between SalePrice (y) and lot area (x). 
# Q) How many outliers (in terms of lot area) do you have? 


# Run a regression with your entire data between Sale Price, Lot Area, Year Built, and Bedrooms above ground. 
# Q: What is the association between sale price and lot area in this model?

lm_all = lm() # COMPLETE
summary(lm_all)

# Run the same regression as before, but exclude the outliers (in terms of lot area)
# Q: What is the association between sale price and lot area in this model? Is it the similar as before?

lm_wo_outliers = lm() # COMPLETE
summary(lm_wo_outliers)


# Create a dummy variable (price500) that takes the value of 1 if the sale price is greater than $500,000 and 0 in another case
housing = housing %>% # COMPLETE

# Run a regression with price500 as the outcome, and lot area, number of bedrooms above ground, year built, 
# overall quality of the materials, and pool area as covariates.
  
lm_price = #COMPLETE
  
# Q: Interpret the coefficient for `Overall.Qual`
# Q: Run the same regression as before, but use lm() instead of lm_robust(). Is there our change in the coefficient for Lot.Area?
# Should we use lm() or lm_robust() then? Or it doesn't matter?
