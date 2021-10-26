################################################################################
### Title: "Prediction Project"
### Course: STA 235H
### Semester: Fall 2021
### Names: 
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

library(tidyverse)

# Before doing anything, load your data and select the sample we will use
d_total <- read.csv(...) #Load your HMDA 2020 Travis county data here (downloaded)
  
# These are the row numbers you will need (everyone will use the same observations)
rows <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Project/data/row_sample.csv") %>%
  pull() # Load it as a vector and not a dataframe.

d <- d_total %>% slice(rows)

# Now clean your data and conduct your analysis with the d dataset.
