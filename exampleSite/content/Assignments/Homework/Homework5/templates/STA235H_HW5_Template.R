######################################################################
### Title: "Homework 5"
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

# Task 2 - Show me the money

earnings = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework5/data/placementv2.csv")


# Q2.1


# Task 3 - IBM knows you are leaving

employees = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Homework/Homework5/data/employees.csv") %>% 
  select(-c(EmployeeCount, Over18, StandardHours))



# Q3.1