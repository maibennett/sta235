######################################################################
### Title: "Homework 1"
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
library(ggplot2)
library(vtable)

################################################################################
### Task 1: How much should insurance cost?
################################################################################

insurance <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/data/hw1/insurance.csv")

## Question 1.2

ggplot(...) #Complete this with your code

## Question 1.3
ggplot(...)

## Question 1.4
lm(...)