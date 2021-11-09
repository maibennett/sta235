################################################################################
### Title: "Week 11 - KNN"
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
library(modelr)

############################################
#### K-Nearest Neighbor
############################################

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week11/1_KNN/data/purchases_type.csv")

# If we are doing a classification task, make sure your outcome is a factor variable:
d <- d %>% mutate() # COMPLETE

set.seed(100)

n <- nrow(d)

train.row <- sample(1:n, 0.8*n) # Same thing as before. We need to divide our data

test.data <- d[-train.row,]
train.data <- d[train.row,]

knnc <- train(
  type ~., data = train.data, # `type` is a factor variable now
  method = "knn", # The method will be KNN
  trControl = trainControl("cv", number = 10), # cross-validation with 10 fold
  preProcess = c("center","scale"), # Again, we need to center and scale because we will be working with distances! (we want all distances to mean the same, meaning be in the same scale)
  tuneLength = 15 # Play around with this parameter: Is the granularity for the search of the best K
)

# Exercise: Omit the tuneLength parameter. What do you see when you do plot(knn)? Increase tuneLength=35. What are the differences now?
# Excercise: Replace tuneLength for tuneGrid = expand.grid(k = 1:50). What do you get in this case? (think of something similar to what we were doing with lambda in shrinkage methods)

plot(knnc)

# You can also find the opt K:
knnc$bestTune

#Exercise: Interpret this plot!

# Now let's get our predicted classifications!
pred.type <- knnc %>% predict(test.data)
test.data <- test.data %>% mutate(prediction = pred.type)

test.data %>% select(type, prediction) %>% table # Now we select only our observed types and our predictions to see how we did

test.data %>% select(type, prediction) %>% table %>% proportions(., margin = 1) %>%
  round(., 3) # For accuracy, we also need the proportions

# If we want to obtain the overall accuracy IN THE TRAINING DATASET, we can get it from "results"
knnc$results$Accuracy[knnc$results$k == knnc$bestTune$k]

# If we want to obtain the overall accuracy IN THE TESTING DATASET, we can get it from our observed and predicted outcomes.
mean(test.data$type == pred.type)

## Regression

# Let's do the same as before, but now with a continuous outcome
knnr <- train(
  spend ~. - type, data = train.data,
  method = "knn",
  trControl = trainControl("cv", number = 10),
  preProcess = c("center","scale"),
  tuneLength = 50 #Again, play around with this parameter.
)

plot(knnr) #Exercise: Interpret this plot. What is on the Y axis? Is it better to have high values of Y or low?

#Question: What's the best K in this case?

# Let's test the error rates:
rmse(knnr, test.data)

# Excercise: How would you interpret that error?

