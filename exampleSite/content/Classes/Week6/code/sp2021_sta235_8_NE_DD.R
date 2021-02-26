##############################################################
### Title: "Week 6 - Natural Experiments and Diff-in-Diff"
### Course: STA 235
### Semester: Spring 2021
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
library(generics)
library(estimatr)
library(designmatch)
library(MatchIt)
library(broom)
library(vtable) #Useful package to visualize data
library(cobalt)

#####################################################################

## Oregon Insurance Plan example

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week6/data/oregonhie_simplified.csv") #Load the data (almost 75k obs)

#First, always inspect the data:

table(d$treatment)

table(d$treatment, d$applied_app)

vtable(d) #This is also good to look at all your data

#Note that variables ending in _list come from one dataset and variables ending in _ed come from another dataset. Not all of them merge! (1: Only in _list dataset, 2: Only in _ed dataset, 3: In both)

## Let's look at the balance

d_covs <- d %>% dplyr::select(birthyear_list, have_phone_list, english_list, female_list, week_list, zip_msa_list, pobox_list, 
                              any_visit_pre_ed, num_visit_pre_cens_ed, any_hosp_pre_ed, num_hosp_pre_cens_ed, charg_tot_pre_ed)