################################################################################
### Title: "Homework 6 Submission"
### Course: STA 235H
### Semester: Fall 2023
### Name: Magdalena Bennett
################################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
library(tidyverse)
library(caret)
library(modelr)

# 1. REGRESSION TASK ###########################################################

## 1.1 CLEAN AND WRANGLE DATA: This section should contain any changes you want 
# to make to the dataset. It is not mandatory, but it helps if you comment
# your code.

# Load data
hbo_r = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

# Change character variables to factors
hbo_r = hbo_r %>% mutate_if(is.character, as.factor)

## 1.2 SPLIT THE DATA: 

set.seed(100)

# We will choose 70% of the data for training purposes:
train_ids = sample(1:nrow(hbo_r), 0.7*nrow(hbo_r))

train.data = hbo_r %>% slice(train_ids)
test.data = hbo_r %>% slice(-train_ids)

## 1.3 MODEL 1:

set.seed(100)

nvars = 4

train.control = trainControl(method = "cv", number = 5) #set up a 5-fold cv

# This is my preferred model:
reg.model = train(logins ~ . - id, 
               data = train.data, 
               method = "leapForward",
               tuneGrid = data.frame(nvmax = 1:nvars), 
               trControl = train.control)

## 1.4 MODEL 2:

#...


# 2. CLASSIFICATION TASK #######################################################

## 2.1 CLEAN AND WRANGLE DATA:

# Load data
hbo_c = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

# Change character variables to factors
hbo_c = hbo_c %>% mutate_if(is.character, as.factor)

## 2.2 SPLIT THE DATA: 

set.seed(100)

# We will choose 70% of the data for training purposes:
train_ids = sample(1:nrow(hbo_c), 0.7*nrow(hbo_c))

train.data = hbo_c %>% slice(train_ids)
test.data = hbo_c %>% slice(-train_ids)

## 2.3 MODEL 1:

lambda_seq = seq(0,0.5,length = 100) 

set.seed(100)

train.control = trainControl(method = "cv", number = 10)

# This is my preferred model

class.model = train(factor(unsubscribe) ~ . , data = train.data, 
              method = "glmnet",
              preProcess = "scale", 
              trControl = trainControl("cv", number = 10), 
              tuneGrid = expand.grid(alpha = 0,
                                     lambda = lambda_seq)
)


## 2.4 MODEL 2:

#...


#### SAVE YOUR PREFERRED MODELS FOR SUBMISSION:

save(reg.model, class.model, file = "C:/Users/maibe/Dropbox/ROutput/mc72574_BennettM_models.RData")


################################################################################
###### THIS IS NOT PART OF THE SUBMITTED SCRIPT ################################
################################################################################

# If you want to check that your submission works correctly, start with a clean 
# environment, load your models and see if they predict correctly:

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

# Load your models
load("C:/Users/maibe/Dropbox/ROutput/mc72574_BennettM_models.RData")

# Load your data
hbo_r = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

# Check performance:
rmse(reg.model, hbo_r)
