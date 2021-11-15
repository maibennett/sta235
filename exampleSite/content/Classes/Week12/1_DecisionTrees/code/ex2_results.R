################################################################################
### Title: "Week 12 In-Class Exercise - Decision Trees"
### Course: STA 235H
### Semester: Fall 2021
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
library(caret)
library(rattle)
library(modelr)

############################################
#### Decision Trees
############################################

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week12/1_DecisionTrees/data/Placement_Data_Full_Class.csv")

# Task: We want to predict whether a student is placed or not (status) according to their characteristics.
#       1) Run a Decision Tree using 10-fold CV and whatever tuneLength or TuneGrid you see fit. 
#       2) Show a plot for your final tree. What is the optimal complexity parameter and the accuracy of the prediction?

# Notes: `sl_no` is a serial number identifying students and should not be used for prediction. 
#        `salary` is an outcome for those placed, so it should also be left out (not used as a predictor)

d <- d %>% select(-c(sl_no, salary))

### INSERT CODE HERE (be sure to show your answers (plots) for optimal cp and accuracy)

# When you are done, you can submit it on Canvas.
set.seed(100)

n <- nrow(d)

train.row <- sample(1:n, 0.8*n) # Same thing as before. We need to divide our data

test.data <- d %>% slice(-train.row)
train.data <- d %>% slice(train.row)

# Let's use the caret package to run a classification tree
ct <- train(
  factor(status) ~ ., data = train.data,
  method = "rpart", # The method is called rpart (Recursive Partitioning And Regression Trees)
  trControl = trainControl("cv", number = 10), # cross-validation with 10 fold
  tuneGrid = expand.grid(cp = seq(0,2,by = 0.01))  # Play around with this parameter: Is the granularity for the search of the best complexity parameter
)

plot(ct)

ct$bestTune
# We get a complexity parameter of 0.07

fancyRpartPlot(ct$finalModel)

#Predictions:
pred_type <- ct %>% predict(test.data)

test.data <- test.data %>% mutate(prediction = pred_type)

mean(factor(test.data$status) == test.data$prediction)
#83.7% of accuracy (which is better from what we got using KNN!)




