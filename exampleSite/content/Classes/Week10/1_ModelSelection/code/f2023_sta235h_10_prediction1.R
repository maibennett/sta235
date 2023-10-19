################################################################################
### Title: "Week 10 - Prediction I"
### Course: STA 235H
### Semester: Fall 2023
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

hbo = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

head(hbo)

# Divide data: 80% vs 20% split

set.seed(100) #Always set seed for replication! (and make sure you are running an updated version of R!)

n = nrow(hbo) # Will tell us how many observations we have

train = sample(x = 1:n, size = n*0.8) #randomly select 80% of the rows for our training sample

# slice() selects rows from a dataset based on the row number.
train.data = hbo %>% slice(train) #use only the rows that were selected for training

test.data = hbo %>% slice(-train) #the rest are used for testing

### Simple model
lm_simple = lm(logins ~ succession + city, data = train.data) #Train the model on the TRAINING DATASET

### Complex model
lm_complex = lm(logins ~ female + city + age + I(age^2) + succession, data = train.data) #Train the model on the TRAINING DATASET


# Let's look at the RMSE for these models on the TRAINING dataset:
# For simple model:
rmse(lm_simple, train.data) #rmse() in the `modelr` package takes model we are using and the data.

# For complex model:
rmse(lm_complex, train.data)

# If we wanted to actually get the predictions, we could also do that with the following line:
pred_complex_train = lm_complex %>% predict(train.data) #We start with the model, and then use the function predict on the data we want.

## Question: According to this, which model is better? Is this the comparison we want?

# Estimate RMSE for these models on the TESTING dataset (THIS IS WHAT WE WANT TO ASSESS THE MODEL):
# For simple model:
rmse(lm_simple, test.data)

# For complex model:
rmse(lm_complex, test.data)

## Question: Using this comparison, which model is better? Is this the comparison we want?

####################################################################################
# Prediction for a specific individual:
####################################################################################

#If we wanted to predict for a specific individual, we can create a new dataset and use that with the predict() function.

# Remember to create (at least) all the variables that are in the *model*!
data_new = data.frame(female = 1,
                      city = 1,
                      age = 30,
                      succession = 1,
                      unsubscribed = 0)

lm_complex %>% predict(data_new)

# Using the complex model, for a female who lives in a city and it's 30 yo and
# has watched succession, we predict 3.3 logins in the past week.

###############################################################################
#### Cross-validation
###############################################################################

# We will typically use 5 or 10-fold cross validation

set.seed(100) # Set seed for replication!

train.control = trainControl(method = "cv", number = 10) #This is a function from the package caret. We are telling our data that we will use a cross validation approach (cv) with 10 folds (number). Use ?trainControl to see the different methods we could use!

lm_simple_cv = train(logins ~ succession + city, data = hbo, method="lm",
               trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_simple_cv


lm_complex_cv = train(logins ~ female + city + age + I(age^2) + succession, data = hbo, method="lm",
                       trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_complex_cv

# Question: Looking at both models, which one would you prefer?


################################################################################
##### Stepwise
################################################################################

set.seed(100) # Set a seed for replication

train.control = trainControl(method = "cv", number = 10) #set up a 10-fold cv

lm.fwd = train(logins ~ . - unsubscribe, data = train.data, # We take out unsubscribe because it's also an outcome (happens *after* logins)
               method = "leapForward", # "leapForward" is for Forward Stepwise and "leapBackward" is for backwards.
               tuneGrid = data.frame(nvmax = 1:5), #We include 5 variables, because that's all the predictors we are using for our model.
               trControl = train.control) 

lm.fwd$results

# We can see the number of covariates that is optimal to choose:
lm.fwd$bestTune

# And how does that model looks like:
summary(lm.fwd$finalModel)

# If we want the RMSE
rmse(lm.fwd, test.data)

# Note: Even if we are doing cross-validation, because we now have a *tuning parameter*
# (nvmax), we still need to train our model in the training data.
