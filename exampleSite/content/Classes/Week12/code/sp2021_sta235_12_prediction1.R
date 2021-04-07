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
library(caret)

################################################################################
################ Measuring churn ###############################################

disney <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/2_ModelSelection/data/disney.csv")

head(disney)

# Divide data: 80% vs 20% split

set.seed(100) #Always set seed for replication!

n <- nrow(disney)

train <- sample(1:n, n*0.8) #randomly select 80% of the rows

train.data <- disney[train,] #use only the rows that were selected for training

test.data <- disney[-train,] #the rest are used for testing

### Simple model
lm_simple <- lm(logins ~ mandalorian + city, data = train.data) #Train the model on the TRAINING DATASET

### Complex model
lm_complex <- lm(logins ~ female + city + age + I(age^2) + mandalorian, data = train.data) #Train the model on the TRAINING DATASET


# Estimate RMSE for these models on the TRAINING dataset:
# For simple model:
pred_simple_train <- lm_simple %>% predict(train.data)
RMSE(pred_simple_train, train.data$unsubscribe)

# For complex model:
pred_complex_train <- lm_complex %>% predict(train.data)
RMSE(pred_complex_train, train.data$unsubscribe)

## Question: Which model is better?

# Estimate RMSE for these models on the TESTING dataset:
# For simple model:
pred_simple_test <- lm_simple %>% predict(test.data)
RMSE(pred_simple_test, test.data$unsubscribe)

# For complex model:
pred_complex_test <- lm_complex %>% predict(test.data)
RMSE(pred_complex_test, test.data$unsubscribe)

## Question: Which model is better?

###############################################################################
#### Cross-validation
###############################################################################

# We will typically use 5 or 10-fold cross validation

set.seed(100) # Set seed for replication!

train.control <- trainControl(method = "cv", number = 10) #This is a function from the package caret. We are telling our data that we will use a cross validation approach (cv) with 10 folds (number). Use ?trainControl to see the different methods we could use!

lm_simple <- train(logins ~ mandalorian + city, data = disney, method="lm",
               trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_simple

lm_complex <- train(logins ~ female + city + age + I(age^2) + mandalorian, data = disney, method="lm",
                   trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_complex


# Exercise: use the function `trainControl(method = "LOOCV")` to do a Leave One Out (LOO) cross validation. Do your results change? How? What are the advantages and disadvantages of using LOO?

###############################################################################
##### Stepwise selection
###############################################################################

library(leaps)

regfit.fwd <- regsubsets(logins ~ . - unsubscribe, data=disney, method = "forward") # do forward stepwise selection

summary(regfit.fwd) #interpret these results. 

#Questions: Do the same procedure, but backwards. Do you get the same results?

### Adding cross-validation
set.seed(100)

train.control <- trainControl(method = "cv", number = 10) #set up a 10-fold cv

lm.fwd <- train(logins ~ . - unsubscribe, data = disney,
                    method = "leapForward", 
                    tuneGrid = data.frame(nvmax = 1:5), #We are saying that we will use max 5 covariates
                    trControl = train.control)
lm.fwd$results

# Question: Which model do you choose?

# Excercise: Do the same CV procedure, but with backwards stepwise. Which model do you choose in that case?