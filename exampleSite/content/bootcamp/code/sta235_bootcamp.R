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




