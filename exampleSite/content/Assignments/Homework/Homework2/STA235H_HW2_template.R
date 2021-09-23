######################################################################
### Title: "Homework 2"
### Course: STA 235H
### Semester: Fall 2021
### Students: Name 1, Name 2, Name 3, and Name 4
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
### Task 1: Do training programs work?
################################################################################

lalonde <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/data/hw2/nsw_lalonde_rct.csv")

## Question 1.4

#Complete this with your code

#...