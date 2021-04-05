################################################################################
### Title: "Week 10 - Prediction I"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to 
#run install.packages() line
library(tidyverse)
library(ggplot2)
library(estimatr)
library(broom)
library(rdrobust)

################################################################################
################ Measuring churn ###############################################

disney <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/2_ModelSelection/data/disney.csv")

head(disney)

# Create a new variable:

disney <- disney %>% mutate(logins_0 = as.numeric(logins==0))

# Divide data: 80% vs 20% split

set.seed(100) #Always set seed for replicability!

n = nrow(disney) #number of observations in the dataset

train <- sample(1:n, n*0.8) #randomly select 80% of the rows

train.data <- disney[train,] #use only the rows that were selected for training

test.data <- disney[-train,] #the rest are used for testing

### Simple model
lm_simple <- lm(unsubscribe ~ mandalorian + logins_0, data = train.data) #Train the model on the TRAINING DATASET

### Complex model
lm_complex <- lm(unsubscribe ~ female + city + age + I(age^2) + factor(logins) + mandalorian, data = train.data) #Train the model on the TRAINING DATASET

# Estimate RMSE for these models on the TRAINING dataset:

RMSE <- function(y, y_hat){
  sqrt(mean((y - y_hat)^2))
}

# For simple model:
RMSE(train.data$unsubscribe, predict(lm_simple))

# For complex model:
RMSE(train.data$unsubscribe, predict(lm_complex))