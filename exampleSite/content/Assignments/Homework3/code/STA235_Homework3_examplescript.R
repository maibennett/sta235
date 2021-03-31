
##############################################################
### Title: Homework 3
### Course: STA 235
### Semester: Spring 2021
### Name: [YOUR NAME HERE]
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries (load any package you might need)
library(tidyverse)
library(ggplot2)
library(estimatr)
library(rdrobust)
library(designmatch)

# Task 1: Break a leg! (40 points)

injury <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework3/data/injury.csv")



# Task 2: That 1[0]%... (40 points)

texas <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework3/data/texas10.csv")

# Question 2.5
texas_college <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework3/data/texas10college.csv")