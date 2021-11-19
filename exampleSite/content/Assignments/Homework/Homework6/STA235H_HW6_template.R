######################################################################
### Title: "Homework 6"
### Course: STA 235H
### Semester: Fall 2021
### Students: Name 1, Name 2, Name 3, and Name 4
#######################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")
# scipen=999 removes scientific notation; scipen=0 turns it on.
options(scipen = 999)

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)


################################################################################
### Task 1: IBM knows you are leaving
################################################################################

employees <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/data/hw6/employee_attrition.csv") %>% 
  select(-c(EmployeeCount, Over18, StandardHours))

## Question 1.1


#Complete this with your code

#...