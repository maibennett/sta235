######################################################################
### Title: "Midterm"
### Course: STA 235H
### Semester: Fall 2021
### Student: Name
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
library(modelsummary)
library(ggplot2)
library(estimatr)


################################################################################
### Task 1: Going green!
################################################################################

barrels_rct <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Exams/data/midterm/barrels_rct.csv") %>% 
  # This makes it so "No barrel" is the reference category
  mutate(barrel = fct_relevel(barrel, "No barrel"))

barrels_obs <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Exams/data/midterm/barrels_observational.csv") %>% 
  # This makes it so "No barrel" is the reference category
  mutate(barrel = fct_relevel(barrel, "No barrel"))

## Question 1.2

#Complete this with your code

#...