################################################################################
### Title: "Week 11 - Regularization"
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

hbo = read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week11/1_Shrinkage/data/hbomax.csv")

head(hbo)

# Divide data: 80% vs 20% split

set.seed(100) #Always set seed for replication! (and make sure you are running an updated version of R!)

n = nrow(hbo) # Will tell us how many observations we have

train = sample(1:n, n*0.8) #randomly select 80% of the rows for our training sample

# slice() selects rows from a dataset based on the row number.
train.data = hbo %>% slice(train) #use only the rows that were selected for training

test.data = hbo %>% slice(-train) #the rest are used for testing


############################################
#### Shrinkage
############################################

# You will need to install the package "glmnet"

#### Ridge regression

# Create a vector for different values of lambda 
#(THIS WILL DEPEND ON YOUR EXAMPLE AND YOU NEED TO CHANGE IT ACCORDINGLY)
lambda_seq = c(0, 20, length = 500)

#Question: Change your lambda_seq to go from 0 to 5 instead of 0 to 20. Are your results similar?

set.seed(100)

ridge = train(logins ~ . - unsubscribe - id, data = train.data, # We give the function `train` the formula (`logins` regressed on everything else that's on the dataset). Note: If there are variables *you don't want to include* (e.g. an id variable), you can exclude it with a - sign (e.g. logins ~ . - id).
               method = "glmnet", # We will be using an "Elastic Net" method (which is basically the method family for ridge and lasso reg)
               preProcess = "scale", # Pre-process the data (remember that lasso and ridge are affected by scales! So this standardizes our covariates before doing anything)
               trControl = trainControl("cv", number = 10), # We are using a cross-validation method, with 10 folds. What happens if you change the number of folds?
               tuneGrid = expand.grid(alpha = 0, # alpha is the "mixing" parameter. All you need to know is that `alpha=0` is for ridge regression (and `alpha=1` is for lasso)
                                      lambda = lambda_seq) # values of lambda we are going to test out
)
# This might ask you to install the "glmnet" package (you just have to install it once, and do not need to load it independently (caret will load it for you))

lambda = ridge$results$lambda #We can extract the vector of tested lambdas here
rmse = ridge$results$RMSE # We can extract the C-V RMSE for each of those lambdas!

## Exercise: What other important things do you see in the object `results`? Explore it!

# I create a new dataframe to be able to plot lambda against RMSE
# Here, I'm just creating a new dataframe with two variables: Lambda and RMSE.
cv_lambda = data.frame("lambda" = lambda,
                        "rmse" = rmse)

# Plot lambda vs RMSE
ggplot(data = cv_lambda, aes(x = lambda, y = rmse)) + # x axis will be the parameter lambda and y axis will be RMSE
  geom_line(aes(color = "blue")) + # Let's create a line plot for lambda and RMSE (to see how it behaves)
  geom_vline(aes(xintercept = ridge$bestTune$lambda, color = "purple"), lty=2) + # geom_vline adds a vertical line at a specific value of x (xintercept). In this case, we are providing the value for the best lambda in terms of RMSE
  scale_color_manual(values=c("blue","purple"), # We want an appropriate legend, so we need to pass the different arguments so R knows what to do. First, we provide the colors we want for our different lines
                     labels = c("CV-RMSE","Min \u03BB"), # After that, we provide labels associated with those colors! (the first one is the cross-validation RMSE, and the second one is the best lambda). Note that because lambda is a symbol, we use the HTML representation of it (you can also just write "lambda")
                     name = "") +
  theme_minimal()+
  xlab("\u03BB") + ylab("RMSE") # Finally, we label the axis! (you can use Lambda instead of the symbol for lambda)

## Exercise: Use the function `filter` on cv_lambda dataframe to zoom into lambda (e.g. filter lambda<10), and see the more interesting part.

cv_lambda %>% filter(lambda<10) %>%
ggplot(data = ., aes(x = lambda, y = rmse)) + # x axis will be the parameter lambda and y axis will be RMSE
  geom_line(aes(color = "blue")) + # Let's create a line plot for lambda and RMSE (to see how it behaves)
  geom_vline(aes(xintercept = ridge$bestTune$lambda, color = "purple"), lty=2) + # geom_vline adds a vertical line at a specific value of x (xintercept). In this case, we are providing the value for the best lambda in terms of RMSE
  scale_color_manual(values=c("blue","purple"), # We want an appropriate legend, so we need to pass the different arguments so R knows what to do. First, we provide the colors we want for our different lines
                     labels = c("CV-RMSE","Min \u03BB"), # After that, we provide labels associated with those colors! (the first one is the cross-validation RMSE, and the second one is the best lambda). Note that because lambda is a symbol, we use the HTML representation of it (you can also just write "lambda")
                     name = "") +
  theme_minimal()+
  xlab("\u03BB") + ylab("RMSE") 


# You can also get this same plot (but less pretty) as following:
plot(ridge)

# Check out `bestTune` in the cv object: That will have the lambda that yields the smallest RMSE!
ridge$bestTune$lambda

# Finally, check out the final model:
## Exercise: What do these coefficients represent?
coef(ridge$finalModel, ridge$bestTune$lambda)

# Remember that predictions need to be made on testing data!
pred.ridge = ridge %>% predict(test.data) #If we need this, this will store our predictions for the ridge model on the testing data.

# Model prediction performance
rmse(ridge, test.data)

# Let's compare it to OLS!
#YOU NEED TO COMPLETE THIS
ols = train(logins ~ . - unsubscribe - id, data = train.data,
             method = ,### COMPLETE (which method do we use for a regression?),
             trControl = trainControl("cv", number = 10) # values of lambda we are going to test out
)

# Which one is better? (compare RMSE!)

#### Lasso

## Repeat the same steps for Lasso (remember that now `alpha=1`).
set.seed(100)

lasso = train(logins ~ . - unsubscribe - id, data = train.data, 
               method = "glmnet",
               preProcess = "scale",
               trControl = trainControl("cv", number = 10),
               tuneGrid = expand.grid(alpha = 1,
                                      lambda = lambda_seq)
)

# Exercise: Check out the coefficients for lasso (just adapt the code we used for ridge regression). What happened here?


### CLASSIFICATION (BINARY OUTCOME)

# Do the same exercise as before for ridge regression and lasso, but now use "unsubscribe" as your outcome variable
# and use all other variables in your dataset as predictors (with the exception of id)

lambda_seq = seq(0,1,length = 100) # This is a vector that goes from 0 to 1 and has a length of 100. Use head(lambda_seq) to see how it looks like.

set.seed(100)

ridge_uns = train(factor(unsubscribe) ~ . - id, data = train.data, 
               method = "glmnet",
               preProcess = "scale", 
               trControl = trainControl("cv", number = 10), 
               tuneGrid = expand.grid(alpha = 0,
                                      lambda = lambda_seq)
)

# Question: What happens if we use the formula unsubscribe ~ . - id instead?

plot(ridge_uns)

# Now, we need to calculate accuracy (we WILL NOT use RMSE in this case, but an Accuracy measure)

# First, we predict our results in our test data
pred.type = ridge_uns %>% predict(test.data)

# Then, we see how many we got right, on average:
mean(test.data$unsubscribe == pred.type)

#We have an accuracy, with ridge regression of 73.6%

# Task: Do the same with lasso. Which one do you think is better?

