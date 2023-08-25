######################################################################
### Title: "Week 2 - Multiple Regression: Interactions & Other Issues"
### Course: STA 235H
### Semester: Fall 2023
### Professor: Magdalena Bennett
#######################################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")
# scipen=999 removes scientific notation; scipen=0 turns it on.
options(scipen = 0)

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(vtable)

################################################################################
### In-class exercises
################################################################################

# Continuation of the Bechdel Test Example ----

rawData <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/data/bechdel.csv")

## Select movies post 1990
bechdel <- rawData %>% filter(Year>1989)

## Passes Bechdel test:
bechdel <- bechdel %>% mutate(bechdel_test = ifelse(rating==3, 1, 0),
                              Adj_Revenue = Adj_Revenue/10^6,
                              Adj_Budget = Adj_Budget/10^6)

lmb <- lm(Adj_Revenue ~ bechdel_test*Adj_Budget + Metascore + imdbRating, data=bechdel)

summary(lmb)

#### Q: We are using "*" to interact two variables. What happens if you use ":" instead? Do you think this is correct?
#### Q: Create a new variable, bechdel_budget, that interacts bechdel_test and Adj_Budget, and write a new regression that replicates lmb. Do you get the same results? (Hint: You should!)


# Cars, cars, cars ----

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/SoCalCars.csv", stringsAsFactors = FALSE)

## Let's clean some data

## Select only cars from the year 1970 onwards, that are under $100k, and have less than 150k miles (and more than 10k).

## Let's create new variables:

### luxury: dummy variable for luxury brands (in `luxury_brand` vector) (source: https://luxe.digital/business/digital-luxury-ranking/best-luxury-car-brands/)
### Transform price from dollars to thousands of dollars, and miles to thousands of miles.
### Transform year so that it's the number of years since 1970s

luxury_brands <- c("Audi", "BMW", "Cadillac", "Ferrari", "Jaguar", "Lamborghini", "Land Rover", "Lexus",
                   "Maserati", "Mercedes-Benz", "Porsche", "Rolls-Royce", "Tesla", "Volvo")

cars <- cars %>% filter(type != "new" & mileage >= 10000 & mileage <= 150000 & price < 100000 & year >= 1970) %>%
  mutate(luxury = ifelse(make %in% luxury_brands, 1, 0),
         price = price/1000,
         mileage = mileage/1000,
         year = year - 1970)


## Let's run a regression of price on mileage, year, and rating.

lm1 <- lm() #COMPLETE THIS FUNCTION

summary(lm1) #Interpret the intercept

### How do we recover only coefficients?
coef(lm1) # vector of coefficients

summary(lm1)$coefficients #matrix of coefficients, SE, t-value and p-values


## Let's plot mileage against price. What do you see?

ggplot(data = cars, aes(y = price, x = mileage)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) + #pch changes the type of the marker (you can see the options here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
  theme_bw()+
  xlab("Mileage (1,000 Miles)") + ylab("Price (1,000 USD)") +
  # The options below (in theme) are just to show you how to make your plots look better. Adapt them as you wish.
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),
        legend.position="none",
        title = element_text(size=18),
        plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid = element_blank(),
        axis.line = element_line(colour = "dark grey"))


### We can also easiy include a regression line using geom_smooth:

ggplot(data = cars, aes(y = price, x = mileage)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) + #pch changes the type of the marker (you can see the options here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
  geom_smooth(method = "lm", color = "#900DA4", lwd = 1.5, se = FALSE) + #The method is `lm` (linear model), and we don't want to include the standard errors for the fitted line 
  theme_bw()+
  xlab("Mileage (1,000 Miles)") + ylab("Price (1,000 USD)") +
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),
        legend.position="none",
        title = element_text(size=18),
        plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid = element_blank(),
        axis.line = element_line(colour = "dark grey"))

## Let's run a regression of price on mileage, year, rating, and the interaction of mileage and year.
lm2 <- lm(price ~ rating + mileage + year*luxury, data = cars)

summary(lm2)

#### Q: What's the change in price for one additional year for luxury-brand cars vs non-luxury-brand cars, holding other variables constant?


# Visualizing data ----

## Let's do a histogram of our outcome variable

ggplot(data = cars, aes(x = price)) +
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + #You can change "bins" depending on your data. Make sure you don't have too many or too few! Play around with.
  theme_bw()+
  xlab("Price (M $)") + ylab("Count")

#### Q: Describe this plot. What can you say about it?

## We can also look at some descriptive statistics:

cars %>% select(price) %>% summary(.)

## Let's create a new variable, log_price

cars <- cars %>% mutate(log_price = log(price)) #Be careful here! If Y=0, then log is not defined!

#### Q; Now, plot the same plot as before, but using log_price. How would you describe this 
  
ggplot() # COMPLETE THIS

## Now let's run the regression:

lm_log <- lm(log_price ~ rating + mileage + luxury + year, data = cars)

summary(lm_log)

#### Q: How do we interpret the coefficient for mileage as a percentage?

### This is a vector of coefficients
lm_log$coefficients

### This is the coefficient for mileage:
lm_log$coefficients["mileage"]

### This is the percentage change
(exp(lm_log$coefficients["mileage"]) - 1)*100

##### Q: How does this compare with \beta_1*100% ?


# Quadratic model ----

## Let's look at data from the Current Population Survey (CPS) 1985
library(AER) #Install this package if you haven't
data("CPS1985")

## We can look at the variable descriptions using ?CPS1985

## Let's plot our outcome variable:

CPS1985 %>%
  ggplot(data = ., aes(x = wage)) + # The "." is a stand-in for whatever is piped before (in this case, the dataset)
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + 
  theme_minimal()+
  xlab("Wages (USD$/hr)") + ylab("Count")

## Combining pipes (%>%) and ggplot is useful, because you don't necessarily have to create new datasets
## Try it! Let's do the same histogram but only for females

CPS1985 %>% filter(gender == "female") %>%
  ggplot(data = ., aes(x = wage)) + # The "." is a stand-in for whatever is piped before (in this case, the dataset)
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + 
  theme_minimal()+
  xlab("Wages (USD$/hr)") + ylab("Count")
  

## Going back to our original histogram, how would you describe the distribution?
## Let's plot log(wage) now
CPS1985 %>%
  ggplot(data = ., aes(x = log(wage))) + # The "." is a stand-in for whatever is piped before (in this case, the dataset)
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + 
  theme_minimal()+
  xlab("log(Wages)") + ylab("Count")

## Let's run a regression:

CPS1985 <- CPS1985 %>% mutate(log_wage = log(wage)) #create a variable that is the log of wages (Note: Make sure all wages are >0!)

lm1 <- lm(log_wage ~ education + experience, data = CPS1985)

summary(lm1)

#### Q: Interpret the coefficient for education

## Let's plot the relationship between log(wage) and experience:

ggplot(data = CPS1985, aes(y = log_wage, x = experience)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  theme_minimal()+
  xlab("Experience (Years)") + ylab("log(Wage)")

## What if we wanted to add the regression line for the model we fit in `lm1`?

## We will create a copy of our original dataset, but we will fix other variables (besides experience) to their mean.

CPS1985_fit <- CPS1985 %>% mutate(education = mean(education, na.rm=TRUE)) # What does na.rm do?

## Finally, we use the function "predict()" to get the fitted values for log(wages) based on our model lm1

CPS1985_fit <- CPS1985_fit %>% mutate(log_wage_hat_lm = predict(lm1, newdata = .))

## Now let's add this to the previous plot

ggplot(data = CPS1985_fit, aes(y = log_wage, x = experience)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  geom_line(aes(x = experience, y = log_wage_hat_lm), color = "orange", lwd = 1.1) +
  theme_minimal()+
  xlab("Experience (Years)") + ylab("log(Wage)")

## This line doesn't look like it fits the data that well, so we want to include the Mincer equation:

lm_mincer <- lm(log_wage ~ education + experience + I(experience^2), data = CPS1985)

summary(lm_mincer)

## Note: To add a polynomial term we use I() and whatever exponent we want

## Let's repeat the same process as before to add the quadratic fit to the data

CPS1985_fit <- CPS1985_fit %>% mutate(log_wage_hat_lq = predict(lm_mincer, newdata = .))

## Now let's add this to the previous plot

ggplot(data = CPS1985_fit, aes(y = log_wage, x = experience)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  geom_line(aes(x = experience, y = log_wage_hat_lq), color = "orange", lwd = 1.1) +
  theme_minimal()+
  xlab("Experience (Years)") + ylab("log(Wage)")

#### Q: Does it look like it fits better?

#### Q: After what point does the return to experience starts being negative instead of positive?
