################################################################################
### Title: "Week 7 - Natural Experiments"
### Course: STA 235H
### Semester: Fall 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to 
#run install.packages() line
library(tidyverse)
library(ggplot2)
library(estimatr)
library(modelsummary)
library(MatchIt)
library(vtable)

################################################################################
################ Oregon Insurance Plan example #################################
################ Example for a Natural Experiment ##############################


oregon <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week7/1_NaturalExperiments/data/oregonhie_simplified.csv") #Load the data (almost 75k obs)

# This is data from the Oregon Health Insurance Experiment (publicly available at NBER)
# These are two datasets combined: Variables that end in *_list are from the individuals that applied to the lottery. 
# Variables ending in *_12m are from a survey sent out to a subsample 12 months later.
# You can read more documentation about the variables and the data here:
# https://sta235.netlify.app/Classes/Week7/1_NaturalExperiments/data/OHIE_docs/oregonhie_descriptivevars_codebook.pdf
# https://sta235.netlify.app/Classes/Week7/1_NaturalExperiments/data/OHIE_docs/oregonhie_survey12m_codebook.pdf

# Some variables of interest:

# treatment: Selected in the lottery
# applied_app: Submitted an application to enroll in Medicaid
# approved_app: Application for Medicaid was approved

#First, always inspect the data:

oregon %>% group_by(treatment) %>% count()

oregon %>% group_by(treatment, applied_app) %>% count()

vtable(oregon) #This is also good to look at all your data

#Note that variables ending in _list come from one dataset and variables ending in _1m come from another dataset (12 month survey)

## Let's look at the balance

oregon_bal <- oregon %>% select(treatment, birthyear_list, have_phone_list, english_list, female_list, 
                                   week_list, zip_msa_list, pobox_list)

datasummary_balance(~ treatment, data = oregon_bal, fmt = 3, dinm_statistic = "p.value")


# Note that if any individual from the household was chosen, then all the household was chosen.
# This means that individuals from larger households had more possibilities to be chosen.
# Also, individuals in different waves had different probabilities of being chosen. So we will adjust for that.

# Let's run simple regressions between the previous covariates and the treatment assignment, controlling for wave, 
# household size and the interaction. Are there significant differences?

# Note that datasummary_balance() does this same thing in the background, but without including the additional covariates.
lm1 <- lm(birthyear_list ~ treatment + hhsize_12m*wave_survey12m, data = oregon)
lm2 <- lm(have_phone_list ~ treatment + hhsize_12m*wave_survey12m, data = oregon)
lm3 <- lm(english_list ~ treatment + hhsize_12m*wave_survey12m, data = oregon)
lm4 <- lm(female_list ~ treatment + hhsize_12m*wave_survey12m, data = oregon)
lm5 <- lm(zip_msa_list ~ treatment + hhsize_12m*wave_survey12m, data = oregon)

modelsummary(list("Birth year" = lm1, "Have phone" = lm2, 
                  "English" = lm3, "Female" = lm4, "MSA" = lm5), stars = TRUE, gof_omit = 'DF|AIC|BIC|Log.Lik.|F')


#### What about survey responses?

oregon %>% group_by(treatment, returned_12m) %>% count()

# Let's look at the actual percentages by treatment status

oregon_12m <- oregon %>% filter(sample_12m==1)

oregon_12m %>% group_by(treatment) %>% summarise(mean_response = mean(returned_12m, na.rm = TRUE))

summary(lm_robust(returned_12m ~ treatment, data = oregon_12m)) #The difference in non-response is significant.

# Question: What is this nonresponse called? (as we saw in the context of RCTs)



#### Let's analyze some outcomes now:

## Question: What are the assumptions we need to rely on for adjusting for covariates to be enough to yield a causal treatment effect?

# Have any insurance:
summary(lm_robust(ins_any_12m ~ treatment, data = oregon_12m))

# Got all needed medical care in the last 6 months (or didn't need any)
summary(lm_robust(needmet_med_cor_12m ~ treatment, data = oregon_12m))

# Current smoker
summary(lm_robust(smk_curr_12m ~ treatment, data = oregon_12m))


## Task: Try the same thing with matching! Do your results change? Why?