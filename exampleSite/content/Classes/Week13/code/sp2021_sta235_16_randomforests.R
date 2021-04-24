################################################################################
### Title: "Week 13 - Bagging, Random Forests, and Boosting"
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
library(broom)
library(caret)
library(rpart)
library(rpart.plot)
library(rattle) # This is to make pretty tree plots with the caret package.
library(ipred) # Package to do bagging (though you can do it with the caret package too)
library(rsample) #This helps us divide our data by strata 
library(vip) #For plotting the importance of covariates

####################
## Car seats sale
###################

library(ISLR)
data("Carseats") # Load the data from the ISLR package (this is the package for the book we are using!)

head(Carseats) # Explore the data

set.seed(100)

split <- initial_split(Carseats, prop = 0.7, strata = "Sales") # This will create a 70-30 splir, with 4 strata (by default) of the outcome variable.

carseats.train  <- training(split)
carseats.test   <- testing(split)

# Let's start with a simple decision tree, no pruning (cp = 0.01)

rp <- rpart(Sales ~., data = carseats.train, method = "anova", 
            control = rpart.control(cp = 0.01))

rpart.plot(rp)

# Now, let's prune it with a cp of 0.05!

rpp <- prune(rp, cp = 0.05)

rpart.plot(rpp)

# Now, let's try to get cp through cross-validation

mcv <- train(Sales ~., data = carseats.train, method = "rpart",
             trControl = trainControl("cv", number = 10), tuneLength = 50)

plot(mcv) # Exercise: Check out the optimal cp that is found. How much is it?

tuneGrid <- expand.grid(cp = seq(0, 0.01, 0.0001)) # To improve the search for cp, we give the train function a grid to look for cp

mcv <- train(Sales ~., data = carseats.train, method = "rpart", 
             trControl = trainControl("cv", number = 10), tuneGrid = tuneGrid)

plot(mcv)

fancyRpartPlot(mcv$finalModel) #This is the best way to plot the tree out of the caret package


#### Bagging

set.seed(100)

# train bagged model
b1 <- bagging(Sales ~ ., data = carseats.train,
              nbagg = 100,coob = TRUE,            #nbagg is the number of bags we'll use (usually 100 is fine, but play around with this!). coob is for estimating the error rate for outside the bag obs.
              control = rpart.control(cp = 0)) # We give a cp=0 because we want full grown trees.

b1 # Exercise: Interpret this output. Also, look at all the different objects within b1. Can you plot one of the trees that is used here?


# Let's look at our decision tree again (this will be the best pruned DT):

set.seed(100)

tuneGrid <- expand.grid(cp = seq(0.002, 0.004, 0.000001))

mcv <- train(Sales ~ ., data = carseats.train,
             method = "rpart", trControl = trainControl("cv", number = 10),
             tuneGrid = tuneGrid)

pred.mcv <- mcv %>% predict(carseats.test) # We estimate the predicted values

RMSE(pred.mcv, carseats.test$Sales) # We calculate the RMSE for this DT.

# We can also look at the most important covariates, based on that tree:
vip::vip(mcv, num_features = 10, geom = "point")

# Question: What does num_features mean? Look into the other parameters of the function!

# How do these compare to the importance of the covariates for the bagged trees? Let's see

# We now ran bagged trees using the caret package
bt <- train(Sales ~ ., data = carseats.train,
            method = "treebag", trControl = trainControl("cv", number = 10),
            nbagg = 100,  
            control = rpart.control(cp = 0))


vip::vip(bt, num_features = 10, geom = "point")


###### Random forests

set.seed(100)

rfcv <- train(Sales ~ ., data = carseats.train,
              method = "rf",                       # We basically do the same thing, but change the method.
              trControl = trainControl("cv", number = 10),
              tuneLength = 10) # By default, the parameter that it's trying to optimize is the number m (mtry) of covariates that it samples

plot(rfcv)

# Question: How many trees is this RF running? You can see it here:
rfcv$finalModel

# What if we want to change the number of trees?

rfcv <- train(Sales ~ ., data = carseats.train,
              method = "rf", ntree = 200,         # We can change the number of trees here
              trControl = trainControl("cv", number = 10),
              tuneLength = 10)

rfcv$finalModel # See results here

# What if we want to know which number of trees is best? We can create a loop!

modellist <- list() #   We create a list to save our results

#train with different ntree parameters
for (ntree in c(50,100,200,500, 1000)){
  set.seed(100)
  
  rfm <- train(Sales ~ ., data = carseats.train,
               method = "rf", ntree = ntree,        # For each iteration, we are going to change ntree
               trControl = trainControl("cv", number = 10),
               tuneLength = 10)
  
  key <- toString(ntree) # We create a key so we can identify our results
  
  modellist[[key]] <- rfm # Then in the position of key, we store our model
}

#Compare results
results <- resamples(modellist) # This will just resample our results so we can get confidence intervals!
summary(results) # Look at these results.. pretty, no?

dotplot(results) # And we can plot them super easy. Can you interpret these plots? Which ntree would you choose?

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
                          method = "rf",
                          trControl = trainControl("cv", number = 10, allowParallel = TRUE), # We need to include the allowParallel argument
                          tuneLength = 10)
)

stopCluster(cluster) # We need to close the cluster once we are done

registerDoSEQ() # We also need to unregister the backend

# The parallel RF takes like 12s in my computer. Let's see how much it takes the original RF without parallelizing:

system.time(rfcv <- train(Sales ~ ., data = carseats.train,
                          method = "rf",
                          trControl = trainControl("cv", number = 10),
                          tuneLength = 10)
)

# This takes around 30s, so using a parallel approach could save you a bunch of time!

#### Boosting

# Now, we are going to run some boosting
cl <- makePSOCKcluster(detectCores()-1)
registerDoParallel(cl)

set.seed(100)

gbm <- train(Sales ~ ., data = carseats.train,
             method = "gbm",                          # We are using gradient boosting
             trControl = trainControl("cv", number = 10, allowParallel = TRUE), # I'm running this parallel, but if you don't want to, just set this to FALSE, and ignore the registerDoParallel() function
             tuneLength = 20) # Play around with this parameter!

stopCluster(cl)
registerDoSEQ()


# Exercise: Compare all the RMSE for the testing dataset with all the different models we have fit. Which one is better?


#########################################################################
#### Classification problem

## Exercise: repeat the same models as before, but now use `HighSales` as your outcome. What do you get?

Carseats$HighSales=ifelse(Carseats$Sales<=8, 0, 1) # Build a binary outcome

set.seed(100)

split <- initial_split(Carseats, prop = 0.7, strata = "Sales") #Create a new training and testing datasete

carseats.train  <- training(split)
carseats.test   <- testing(split)


# Exercise: 1) Find the best pruned model, 2) Run some bagged trees, 3) Run a random forest
# You can do all that adapting the code aboVe!


# I will help you with some boosting code: (this one can take a while)
cl <- makePSOCKcluster(detectCores()-1)
registerDoParallel(cl)

set.seed(100)

ada <- train(factor(HighSales) ~ ., data = carseats.train,
             method = "ada",                                      #I'm using now adaptative boosting
             trControl = trainControl("cv", number = 10, allowParallel = TRUE),
             tuneLength = 10)

stopCluster(cl)
registerDoSEQ()


cl <- makePSOCKcluster(detectCores()-1)
registerDoParallel(cl)

set.seed(100)

gbm <- train(factor(HighSales) ~ ., data = carseats.train,
             method = "gbm",                                      #I'll also run gradient boosting
             trControl = trainControl("cv", number = 10, allowParallel = TRUE),
             tuneLength = 10)

stopCluster(cl)
registerDoSEQ()

#Let's compare the results for these two boosting methods:

# Ada boosting
RMSE(ada %>% predict(carseats.test), carseats.test$Sales)

# Gradient boosting
RMSE(gbm %>% predict(carseats.test), carseats.test$Sales)
