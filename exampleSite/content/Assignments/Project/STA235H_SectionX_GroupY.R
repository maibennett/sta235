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

# Set your working directory (e.g. folder where you are working in)
setwd("C:/Users/mc72574/Dropbox/") # Change this path to make it work on your machine!

# Before doing anything, load your data and select the sample we will use
# You can change the name of your dataset, depending on the name you saved it under.
d_total <- read.csv("county_48453.csv") #Load your HMDA 2020 Travis county data here (downloaded)
  
# These are the row numbers you will need (everyone will use the same observations)
rows <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Assignments/Project/data/row_sample.csv") %>%
  pull() # Load it as a vector and not a dataframe.

d <- d_total %>% slice(rows)

# Now clean your data and conduct your analysis with the d dataset.

### REMEMBER TO DO EVERYTHING IN YOUR R SCRIPT
# (When the instruction team runs this, they should get the same results using the original data)

#############################################
## EXAMPLE:
# The purpose of this example is just to show the objects that you need to save. 
# It is not an accurate depiction of a real model.

## Preferred model continuous outcome:
model1 <- train(loan_purpose ~ interest_only_payment, data = d,
             method = "lm")


## Preferred model binary outcome:
model2 <- train(business_or_commercial_purpose ~ interest_only_payment, data = d,
             method = "lm")

# Save your preferred model for binary outcome and continuous outcome
save(lm1, lm2, file = "STA235H_SectionX_GroupY.Rdata") # You will need to submit this .Rdata file