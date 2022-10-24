################################################################################
### Title: "Week 10 - Prediction I"
### Course: STA 235H
### Semester: Fall 2022
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
library(estimatr)
library(modelr)
library(caret)

################################################################################
################ Measuring churn ###############################################

hbo <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

head(hbo)

# Divide data: 80% vs 20% split

set.seed(100) #Always set seed for replication! (and make sure you are running an updated version of R!)

n <- nrow(hbo) # Will tell us how many observations we have

train <- sample(1:n, n*0.8) #randomly select 80% of the rows for our training sample

# slice() selects rows from a dataset based on the row number.
train.data <- hbo %>% slice(train) #use only the rows that were selected for training

test.data <- hbo %>% slice(-train) #the rest are used for testing

### Simple model
lm_simple <- lm(logins ~ got + city, data = train.data) #Train the model on the TRAINING DATASET

### Complex model
lm_complex <- lm(logins ~ female + city + age + I(age^2) + got, data = train.data) #Train the model on the TRAINING DATASET


# Estimate RMSE for these models on the TRAINING dataset:
# For simple model:
rmse(lm_simple, train.data) #rmse() in the `modelr` package takes model we are using and the data.

# For complex model:
rmse(lm_complex, train.data)

# If we wanted to actually get the predictions, we could also do that with the following line:
pred_complex_train <- lm_complex %>% predict(train.data) #We start with the model, and then use the function predict on the data we want.

## Question: According to this, which model is better? Is this the comparison we want?

# Estimate RMSE for these models on the TESTING dataset (THIS IS WHAT WE WANT TO ASSESS THE MODEL):
# For simple model:
rmse(lm_simple, test.data)

# For complex model:
rmse(lm_complex, test.data)

## Question: Using this comparison, which model is better? Is this the comparison we want?

###############################################################################
#### Cross-validation
###############################################################################

# We will typically use 5 or 10-fold cross validation

set.seed(100) # Set seed for replication!

train.control <- trainControl(method = "cv", number = 10) #This is a function from the package caret. We are telling our data that we will use a cross validation approach (cv) with 10 folds (number). Use ?trainControl to see the different methods we could use!

lm_simple_cv <- train(logins ~ got + city, data = hbo, method="lm",
               trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_simple_cv

rmse(lm_simple_cv, test.data)

lm_complex_cv <- train(logins ~ female + city + age + I(age^2) + got, data = hbo, method="lm",
                       trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_complex_cv


# Exercise: use the function `trainControl(method = "LOOCV")` to do a Leave One Out (LOO) cross validation. Do your results change? How? What are the advantages and disadvantages of using LOO?

###############################################################################
##### Stepwise selection
###############################################################################

### Adding cross-validation
set.seed(100)

train.control <- trainControl(method = "cv", number = 10) #set up a 10-fold cv

lm.fwd <- train(logins ~ . - unsubscribe, data = hbo,
                    method = "leapForward", 
                    tuneGrid = data.frame(nvmax = 1:5), #We are saying that we will use max 5 covariates (this depends on your data and you need to change it accordingly)
                    trControl = train.control)
lm.fwd$results
# Question: Which model do you choose?

# We can see the number of covariates that is optimal to choose:
lm.fwd$bestTune

# And how does that model looks like:
summary(lm.fwd$finalModel)

# If we want to recover the coefficient names, we can use the coef() function:
coef(lm.fwd$finalModel, lm.fwd$bestTune$nvmax)

# Excercise: Do the same CV procedure, but with backwards stepwise. Which model do you choose in that case? (method = "leapBackward")
