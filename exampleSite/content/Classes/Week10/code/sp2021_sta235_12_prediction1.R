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

# Divide data: 80% vs 20% split

set.seed(100) #Always set seed for replication!

# We will stratify for selection (so we get unsubcribers in both datasets):
id_u <- disney %>% dplyr::filter(unsubscribe==1) %>% dplyr::select(id) #id for users that unsubscribed
id_s <- disney %>% dplyr::filter(unsubscribe==0) %>% dplyr::select(id) #id for users that have not unsubscribed

train_u <- sample(id_u$id, nrow(id_u)*0.8) #randomly select 80% of the rows
train_s <- sample(id_s$id, nrow(id_s)*0.8) #randomly select 80% of the rows

train.data <- disney[c(train_u,train_s),] #use only the rows that were selected for training

test.data <- disney[-c(train_u,train_s),] #the rest are used for testing

### Simple model
lm_simple <- lm(unsubscribe ~ mandalorian + (logins==0), data = train.data) #Train the model on the TRAINING DATASET

### Complex model
lm_complex <- lm(unsubscribe ~ female + city + age + I(age^2) + factor(logins) + mandalorian, data = train.data) #Train the model on the TRAINING DATASET

# Create a function to calculate the Root Mean Squared Error (RMSE): It takes two arguments, y (obs outcome) and y_hat (predicted outcome)
# It substracts both vectors, squares the difference, calculates de mean, and then take the square root.
RMSE <- function(y, y_hat){
  sqrt(mean((y - y_hat)^2))
}


# Estimate RMSE for these models on the TRAINING dataset:
# For simple model:
RMSE(train.data$unsubscribe, predict(lm_simple))

# For complex model:
RMSE(train.data$unsubscribe, predict(lm_complex))

## Question: Which mode is better?

# Estimate RMSE for these models on the TESTING dataset:
# For simple model:
RMSE(test.data$unsubscribe, predict(lm_simple, newdata = test.data))

# For complex model:
RMSE(test.data$unsubscribe, predict(lm_complex, newdata = test.data))

## Question: Which mode is better?