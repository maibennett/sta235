
6) Finally, let's do a (forward) Stepwise selection model (using again a 5-fold CV). Remember that you need to identify how many predictors we have in this case (and factor variables count for more than 1 depending on the number of levels!):

```{r}
set.seed(100)

nvars <- length(lm_clv_cv$coefnames)
  
train.control <- trainControl(method = "cv", number = 5) #set up a 10-fold cv

lm.fwd <- train(Customer.Lifetime.Value ~ . - Response, data = marketing, method = "leapForward",
                tuneGrid = data.frame(nvmax = 1:nvars), trControl = train.control)

lm.fwd$bestTune #This is the number of variables we will be using

lm.fwd

# If we want to recover the coefficient names, we can use the coef() function:
coef(lm.fwd$finalModel, lm.fwd$bestTune$nvmax)

```