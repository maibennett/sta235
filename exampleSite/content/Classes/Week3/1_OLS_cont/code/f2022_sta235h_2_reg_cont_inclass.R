######################################################################
### Title: "Week 2 - Multiple Regression: Interactions & Other Issues"
### Course: STA 235H
### Semester: Fall 2022
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

# Quadratic model ----

## Let's look at data from the Current Population Survey (CPS) 1985
library(AER) #Install this package if you haven't
data("CPS1985")

## We can look at the variable descriptions using ?CPS1985


## Run the mincer equation:

lm_mincer <- lm()

## What is the return to an additional year of experience for someone with average experience?