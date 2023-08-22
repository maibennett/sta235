##############################################################
### Title: Bootcamp example code
### Author: Magdalena Bennett
### Date Created: 08/23/2023
### Last edit: [08/23/2023] - Created code
##############################################################

#Clear memory
rm(list = ls())

#Clear the console
cat("\014")

#Turn off scientific notation (turn back on with 0)
options(scipen = 999)

# Load packages
library(tidyverse) #includes dplyr and ggplot2!

# If there is a package you don't have installed, you can use install.packages("tidyverse")
# Only run once! (no need to install packages every time you run your code)

# Load data (this is loading data directly from Github)
sales = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/bootcamp/data/US_Regional_Sales_Data.csv")

## Inspecting your data

# Exercise 1: Let's explore the data. How many variables and observations do we have? What type of variables do we have?

## We can see in the environment pane that we have 7991 obs and 16 variables. Most of them are character variables (chr), but some are numeric (int and num).

# Exercise 2: Install the package vtable, load it, and run the code vtable(sales). What do you get? Use the ?vtable to see the options for this function.

#install.packages(vtable)
library(vtable)

?vtable

vtable(sales)



## Data wrangling

# Exercise 1: Unit cost and unit price should be numeric. Let's change this! (hint: you can use the function as.numeric() to transform a variable!)


