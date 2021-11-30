################################################################################
### Title: "Week 14 - Bagging, Random Forests, and Boosting"
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
library(rpart)
library(ranger) # You will need this to run random forests
library(rattle)
library(rsample) #This helps us divide our data by strata 

# You will need to install xgboost. For that, you need to have RTools installed on your computer first if you use Windows. Check this out if you have Windows: https://www.rdocumentation.org/packages/installr/versions/0.22.0/topics/install.Rtools
# After that, install xgboost to R
#install.packages("xgboost")
# If installing it from CRAN fails, you can also install it by downloading the file and going to "Tools --> Install Packages" using the file downloaded from here: https://cran.r-project.org/src/contrib/Archive/xgboost/

####################
## Car seats sale
###################

library(ISLR)
data("Carseats") # Load the data from the ISLR package (this is the package for the book we are using!)

head(Carseats) # Explore the data

set.seed(100)

split <- initial_split(Carseats, prop = 0.7, strata = "Sales")

carseats.train  <- training(split)
carseats.test   <- testing(split)

tuneGrid <- expand.grid(cp = seq(0, 0.01, 0.0001)) # we set this tuneGrid after looking at the plot

# Excercise: With which tuneGrid would you begin?

mcv <- train(Sales ~., data = carseats.train, method = "rpart", 
             trControl = trainControl("cv", number = 10), tuneGrid = tuneGrid)

fancyRpartPlot(mcv$finalModel) #This is the best way to plot the tree out of the caret package

# We can also look at the most important covariates, based on that tree:
varImp(mcv, scale = TRUE)

plot(varImp(mcv, scale = TRUE))

# Question: Why isn't necessarily the most important covariate the one at the top of the tree in this plot?


#### Bagging


# How do these compare to the importance of the covariates for the bagged trees? Let's see

set.seed(100)

# We now ran bagged trees using the caret package
bt <- train(Sales ~ ., data = carseats.train,
            method = "treebag", trControl = trainControl("cv", number = 10),
            nbagg = 100,  
            control = rpart.control(cp = 0))

plot(varImp(bt, scale = TRUE)) #Importance of the covariates!


# Cross-validation can be very slow, so let's do OOTB validation:

library(ipred)

set.seed(100)

# train bagged model
b1 <- bagging(Sales ~ ., data = carseats.train,
              nbagg = 100, coob = TRUE,
              control = rpart.control(cp = 0))

b1

#Question: How do we get RMSE?

pred <- b1 %>% predict(carseats.test) # predictions

###### Random forests

set.seed(100)

# We have a lot of parameters! (we can also use tuneLength as an overall default parameter)

tuneGrid <- expand.grid(
  mtry = seq(2:11), # Number of random covariates that will test
  splitrule = "variance", # Split rule (for regressions use "variance", for classification use "gini")
  min.node.size = 5
)

rfcv <- train(Sales ~ ., data = carseats.train,
              method = "ranger", # You can also use "rf", but "ranger" is faster!
              trControl = trainControl("cv", number = 10),
              importance = "permutation",
              ntrees = 100, # You can erase this argument, but if you want, you can control the number of trees!
              tuneGrid = tuneGrid)

# Question: Change tuneGrid to tuneLength = 10, what do you get?

plot(rfcv)

# Question: How many trees is this RF running? You can see it here:
rfcv$finalModel # See results here


#### Run faster

# One of the problems with random forests or other methods, is that they can be quite slow. Can we speed them up?

# Yes!

# We can parallelize some of the process. For that, we'll need a couple of new packages:
library(parallel)
library(doParallel)

cl <- makePSOCKcluster(detectCores() - 1) # detectCores() will detect the number of cores from your computer. convention to leave 1 core for OS
registerDoParallel(cl)

# Let's run our RF (and let's measure how long it takes!):

system.time(rfcv <- train(Sales ~ ., data = carseats.train,
                          method = "ranger",
                          trControl = trainControl("cv", number = 10, allowParallel = TRUE), # We need to include the allowParallel argument
                          tuneLength = 10)
)

stopCluster(cl) # We need to close the cluster once we are done

registerDoSEQ() # We also need to unregister the backend

# The parallel RF takes like 12s in my computer. Let's see how much it takes the original RF without parallelizing:

system.time(rfcv <- train(Sales ~ ., data = carseats.train,
                          method = "ranger",
                          trControl = trainControl("cv", number = 10),
                          tuneLength = 10)
)

# This takes around 30s, so using a parallel approach could save you a bunch of time!

#### Boosting

# Now, we are going to run some boosting
set.seed(100)

gbm <- train(Sales ~ ., data = carseats.train,
             method = "gbm",                          # We are using gradient boosting
             trControl = trainControl("cv", number = 10),
             tuneLength = 20) # Play around with this parameter!

# Final Model information
gbm$finalModel

# Best Tuning parameters?
gbm$bestTune

# You can also try extreme gradient boosting, which is more efficient
cl <- makePSOCKcluster(detectCores()-1)
registerDoParallel(cl)

set.seed(100)

xgbm <- train(Sales ~ ., data = carseats.train,
             method = 'xgbTree',                          # We are using extreme gradient boosting
             trControl = trainControl("cv", number = 10, allowParallel = TRUE))

stopCluster(cl)
registerDoSEQ()

# Final Model information
xgbm$finalModel

# Best Tuning parameters?
xgbm$bestTune

# Exercise: Compare all the RMSE for the testing dataset with all the different models we have fit. Which one is better?


#########################################################################
#### Classification problem

## Exercise: repeat the same models as before, but now use `HighSales` as your outcome. What do you get?

Carseats$HighSales=ifelse(Carseats$Sales<=8, 0, 1) # Build a binary outcome

set.seed(100)

split <- initial_split(Carseats, prop = 0.7, strata = "HighSales") #Create a new training and testing datasete

carseats.train  <- training(split)
carseats.test   <- testing(split)


# Exercise: 1) Find the best pruned decision tree, 2) Run some bagged trees, 3) Run a random forest
# You can do all that adapting the code above!


# I will help you with some boosting code: (this one can take a while)
set.seed(100)

ada <- train(factor(HighSales) ~ ., data = carseats.train,
             method = "ada",                                      #I'm using now adaptative boosting
             trControl = trainControl("cv", number = 10),
             tuneLength = 10)



gbm <- train(factor(HighSales) ~ ., data = carseats.train,
             method = "gbm",                                      #I'll also run gradient boosting
             trControl = trainControl("cv", number = 10),
             tuneLength = 10)

#Let's compare the results for these two boosting methods:

# Ada boosting
rmse(ada, carseats.test)

# Gradient boosting
rmse(gbm, carseats.test)
