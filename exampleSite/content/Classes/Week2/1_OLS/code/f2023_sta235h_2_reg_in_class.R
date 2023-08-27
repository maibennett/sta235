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

# Cars, cars, cars ----

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/SoCalCars.csv", stringsAsFactors = FALSE)

## Let's clean some data

## Select only used cars from the year 1970 onwards, that are under $100k, and have less than 150k miles (and more than 10k).

## Let's create new variables:

### luxury: dummy variable for luxury brands (in `luxury_brand` vector) (source: https://luxe.digital/business/digital-luxury-ranking/best-luxury-car-brands/)
### Transform price from dollars to thousands of dollars, and miles to thousands of miles.
### Transform year so that it's the number of years since 1970s

luxury_brands <- c("Audi", "BMW", "Cadillac", "Ferrari", "Jaguar", "Lamborghini", "Land Rover", "Lexus",
                   "Maserati", "Mercedes-Benz", "Porsche", "Rolls-Royce", "Tesla", "Volvo")

cars <- cars %>% filter() %>% #COMPLETE CODE
  mutate(luxury = ifelse(make %in% luxury_brands, 1, 0),
         price = , #COMPLETE CODE
         mileage = , #COMPLETE CODE
         year = ) #COMPLETE CODE

## Let's plot year against price. What do you see?

ggplot(data = cars, aes(y = price, x = year)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) + #pch changes the type of the marker (you can see the options here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
  theme_bw()+
  xlab("Year (since 1970)") + ylab("Price (1,000 USD)")


## Let's run a regression of price on mileage, year, rating, luxury, and the interaction of luxury and year.

lm2 <- lm() #COMPLETE THE CODE

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

### This is the percentage change (exact): Exponentiate the coefficient, substract one, and multiply by 100
(exp(lm_log$coefficients["mileage"]) - 1)*100

##### Q: How does this compare with \beta_1*100% ?

