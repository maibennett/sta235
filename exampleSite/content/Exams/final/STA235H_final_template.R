######################################################################
### Title: "Final"
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
### Task 2: Candy, candy, candy, I can't let you go
################################################################################

candy <- read.csv("https://raw.githubusercontent.com/maibennett/website_github/master/exampleSite/content/files/data/candy_v2.csv")

## Question 1.1

#Complete this with your code

#...