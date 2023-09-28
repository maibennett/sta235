######################################################################
### Title: "Homework 3"
### Course: STA 235H
### Semester: Fall 2023
### Name: [INSERT YOUR NAME HERE]
#######################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# [LOAD PACKAGES HERE]

# Task 2 - 

social = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework3/data/social_insure_adap.csv")

# Q2.1


# Task 3 - How to train... a person

nsw_rct = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework3/data/train_rct.csv")

nsw_obs = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework3/data/train_cps.csv")

# Q3.1