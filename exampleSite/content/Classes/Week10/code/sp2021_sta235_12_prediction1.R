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

# We will stratify for selection (so we get unsubcribers in both datasets):
id_u <- disney %>% dplyr::filter(unsubscribe==1) %>% dplyr::select(id) #id for users that unsubscribed
id_s <- disney %>% dplyr::filter(unsubscribe==0) %>% dplyr::select(id) #id for users that have not unsubscribed

train_u <- sample(id_u$id, nrow(id_u)*0.8) #randomly select 80% of the rows
train_s <- sample(id_s$id, nrow(id_s)*0.8) #randomly select 80% of the rows

train.data <- disney[c(train_u,train_s),] #use only the rows that were selected for training

test.data <- disney[-c(train_u,train_s),] #the rest are used for testing

### Simple model
lm_simple <- glm(unsubscribe ~ mandalorian + (logins==0), data = train.data, family = binomial(link = logit)) #Train the model on the TRAINING DATASET

### Complex model
lm_complex <- glm(unsubscribe ~ female + city + age + I(age^2) + factor(logins) + mandalorian, data = train.data, family = binomial(link = logit)) #Train the model on the TRAINING DATASET


# Estimate RMSE for these models on the TRAINING dataset:
# For simple model:
pred_simple_train <- lm_simple %>% predict(train.data, type="response")
RMSE(pred_simple_train, train.data$unsubscribe)

# For complex model:
pred_complex_train <- lm_complex %>% predict(train.data, type="response")
RMSE(pred_complex_train, train.data$unsubscribe)

## Question: Which model is better?

# Estimate RMSE for these models on the TESTING dataset:
# For simple model:
pred_simple_test <- lm_simple %>% predict(test.data, type="response")
RMSE(pred_simple_test, test.data$unsubscribe)

# For complex model:
pred_complex_test <- lm_complex %>% predict(test.data, type="response")
RMSE(pred_complex_test, test.data$unsubscribe)

## Question: Which model is better?

###############################################################################
#### Cross-validation
###############################################################################

# We will typically use 5 or 10-fold cross validation

set.seed(100) # Set seed for replication!

train.control <- trainControl(method = "cv", number = 10) #This is a function from the package caret. We are telling our data that we will use a cross validation approach (cv) with 10 folds (number). Use ?trainControl to see the different methods we could use!

lm_simple <- train(factor(unsubscribe) ~ mandalorian + (logins==0), data = disney, method="glm",family=binomial(),
               trControl = train.control) #See that here (in the train function), we just pass all the data. The function will divide it in folds and do all that!

lm_simple


