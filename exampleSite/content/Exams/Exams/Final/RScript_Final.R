################################################################################
### Title: "R Code for Final"
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

#Causal inference packages
library(tidyverse)
library(modelsummary)
library(estimatr)
library(vtable)
library(rdrobust)

#Prediction packages
library(caret)
library(rpart)
library(rattle)
library(rsample)
library(modelr)

hbo = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

## REGRESSIONS AND CAUSAL INFERENCE ##

# Data Description

sumtable(hbo)

# Quadratic model

lmq = lm(logins ~ age + I(age^2), data = hbo)

summary(lmq)

# See vector of coefficients
lmq$coefficients

# Extract one coefficient
lmq$coefficients["age"]

# Balance Table

datasummary_balance(~ unsubscribe, data = hbo, fmt = 3, dinm_statistic = "p.value")


sales = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week8/1_RDD/data/sales.csv")

# Scatter plot with regression line

ggplot(data = sales, aes(x = income, y = sales)) +
  geom_point(size = 2, color = "darkorange") +
  geom_smooth(color = "darkgrey", se = FALSE, method = "lm") +
  xlab("X label") + ylab("Y label") +
  theme_minimal()

# Regression Discontinuity (RDD)

summary(rdrobust(x = sales$time, y = sales$sales, c = 259.7))

rdplot(x = sales$time, y = sales$sales, c = 259.7, x.label = "X label", y.label = "Y label")


## PREDICTION ## 

data = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week10/1_ModelSelection/data/hbomax.csv")

# Split data

set.seed(100)

train_id = sample(1:nrow(data), 0.7*nrow(data))

train.data = data %>% slice(train_id)
test.data = data %>% slice(-train_id)

# Split data (with stratification)

split = initial_split(data, prop = 0.7, strata = "logins")

train.data = training(split)
test.data = testing(split)

# Linear Model (with cross-validation)

lm.cv = train(logins ~ .,
              data = data,
              trControl = trainControl(method = "cv", number = 5))

## RMSE

rmse(lm.cv, data)

# Stepwise

lm.fwd = train(logins ~ .,
              data = data,
              trControl = trainControl(method = "cv", number = 5),
              method = "leapForward",
              tuneGrid = data.frame(nvmax = 1:5))

lm.fwd = train(logins ~ .,
               data = data,
               trControl = trainControl(method = "cv", number = 5),
               method = "leapBackward",
               tuneGrid = data.frame(nvmax = 1:5))


# Ridge and Lasso

ridge = train(factor(unsubscribe) ~ .,
              data = data,
              trControl = trainControl(method = "cv", number = 5),
              method = "glmnet",
              tuneGrid = expand.grid(alpha = 0,
                                     lambda = seq(0, 0.1, length = 10)))

lasso = train(factor(unsubscribe) ~ .,
              data = data,
              trControl = trainControl(method = "cv", number = 5),
              method = "glmnet",
              tuneGrid = expand.grid(alpha = 1,
                                     lambda = seq(0, 0.1, by = 0.001)))

## Best tuning parameter
ridge$bestTune

ridge$finalModel

## Coefficients
coef(ridge$finalModel, ridge$bestTune$lambda)

coefs = coef(lasso$finalModel, lasso$bestTune$lambda)

coefs@p[2] - 1

## Accuracy
pred.values = ridge %>% predict(test.data)

mean(pred.values == test.data$unsubscribe)


# Decision trees

dt = train(logins ~ .,
              data = data,
              trControl = trainControl(method = "cv", number = 5),
              method = "rpart",
              tuneGrid = expand.grid(cp = seq(0, 0.1, length = 10)))

fancyRpartPlot(dt$finalModel, caption = "Title")

# Bagging

bg = train(logins ~ .,
           data = data,
           trControl = trainControl(method = "cv", number = 5),
           method = "treebag",
           nbagg = 10)


# Random Forests

tuneGrid = expand.grid(
  mtry = 1:5, # Number of random covariates that will test
  splitrule = "variance", # Split rule (Important: for regressions use "variance", for classification use "gini")
  min.node.size = 5
)

rf = train(logins ~ .,
           data = data,
           trControl = trainControl(method = "cv", number = 5),
           method = "ranger",
           num.trees = 10,
           tuneGrid = tuneGrid)

plot(rf)

# Boosting

tuneGrid = expand.grid(
  n.trees = c(10,20,30), # Number of trees that will test
  interaction.depth = c(1, 2), # Number of splits it will attempt
  shrinkage = c(0.01, 0.1), # Learning rates
  n.minobsinnode = 10 # Min observations in each node.
)

boost = train(logins ~ .,
           data = data,
           trControl = trainControl(method = "cv", number = 5),
           method = "gbm",
           tuneGrid = tuneGrid)

boost$finalModel

boost$bestTune
