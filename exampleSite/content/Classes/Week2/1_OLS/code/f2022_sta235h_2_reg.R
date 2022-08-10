######################################################################
### Title: "Week 2 - Multiple Regression: Interactions & Other Issues"
### Course: STA 235H
### Semester: Fall 2022
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
library(ggplot2)
library(vtable)

################################################################################
### In-class exercises
################################################################################

### Continuation of the Bechdel Test Example

rawData <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/data/bechdel.csv")

# Select movies post 1990
bechdel <- rawData %>% filter(Year>1989)

# Passes Bechdel test:
bechdel <- bechdel %>% mutate(bechdel_test = ifelse(rating==3, 1, 0),
                              Adj_Revenue = Adj_Revenue/10^6,
                              Adj_Budget = Adj_Budget/10^6)

lmb <- lm(Adj_Revenue ~ bechdel_test*Adj_Budget + Metascore + imdbRating, data=bechdel)

summary(lmb)

# Q: We are using "*" to interact two variables. What happens if you use ":" instead? Do you think this is correct?
# Q: Create a new variable, bechdel_budget, that interacts bechdel_test and Adj_Budget, and write a new regression that replicates lmb. Do you get the same results? (Hint: You should!)


### Cars, cars, cars

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/1_OLS/data/SoCalCars.csv", stringsAsFactors = FALSE)

## Let's clean some data

# Select only cars from the year 1970 onwards, that are under $100k, and have less than 150k miles.

# Let's create new variables:

# luxury: dummy variable for luxury brands (in `luxury_brand` vector) (source: https://luxe.digital/business/digital-luxury-ranking/best-luxury-car-brands/)
# Transform price from dollars to thousands of dollars, and miles to thousands of miles.
# Transform year so that it's the number of years since 1970s

luxury_brands <- c("Audi", "BMW", "Cadillac", "Ferrari", "Jaguar", "Lamborghini", "Land Rover", "Lexus",
                   "Maserati", "Mercedes-Benz", "Porsche", "Rolls-Royce", "Tesla", "Volvo")

cars <- cars %>% filter(type != "new" & mileage >= 10000 & mileage <= 150000 & price < 100000 & year >= 1970) %>%
  mutate(luxury = ifelse(make %in% luxury_brands, 1, 0),
         price = price/1000,
         mileage = mileage/1000,
         year = year - 1970)


# Let's run a regression of price on mileage, year, and rating.

lm1 <- lm() #complete this function

summary(lm1) #Interpret the intercept

#How do we recover only coefficients?
coef(lm1) # vector of coefficients

summary(lm1)$coefficients #matrix of coefficients, SE, t-value and p-values

# Question: Are the signs of the coefficients what you expected?

## Let's plot mileage against year. What do you see?

ggplot(data = cars, aes(y = mileage, x = year)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) + #pch changes the type of the marker (you can see the options here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
  theme_bw()+
  xlab("Year") + ylab("Mileage") +
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


# We can also easiy include a regression line using geom_smooth:
ggplot(data = cars, aes(y = mileage, x = year)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) + #pch changes the type of the marker (you can see the options here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
  geom_smooth(method = "lm", color = "#900DA4", lwd = 1.5, se = FALSE) + #The method is `lm` (linear model), and we don't want to include the standard errors for the fitted line 
  theme_bw()+
  xlab("Year") + ylab("Mileage") +
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),
        legend.position="none",
        title = element_text(size=18),
        plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid = element_blank(),
        axis.line = element_line(colour = "dark grey"))

# Let's look at the correlation between year and mileage
cars %>% select(year, mileage) %>% cor(.)

# Let's run a regression of price on mileage, year, rating, and the interaction of mileage and year.
lm2 <- lm(price ~ rating + mileage + year*luxury, data = cars)

summary(lm2)

#Question: What's the change in price for one additional year for luxury-brand cars vs non-luxury-brand cars, holding other variables constant?


# Now, let's look at year and mileage by luxury vs non-luxury car
ggplot(data = cars, aes(y = mileage, x = year, color = factor(luxury))) + #Q: Why do we use factor(luxury) and not just luxury? Try it out without factor.
  geom_point(size = 3, pch = 21) +
  geom_smooth(method = "lm", lwd = 1.5, se = FALSE) + #The method is `lm` (linear model), and we don't want to include the standard errors for the fitted line 
  scale_color_manual("Luxury",values=c("#E16462","#F89441")) + #with scale_color_manual we can choose the title of the legend and the colors for the different groups.
  theme_bw()+
  xlab("Year") + ylab("Mileage") + 
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),
        legend.position=c(0.9,0.82),
        title = element_text(size=12),
        plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid = element_blank(),
        axis.line = element_line(colour = "dark grey"))

# Looking at the previous plot, what correlation is greater (in absolute terms)?


## Visualizing data

# Let's do a histogram of our outcome variable

ggplot(data = cars, aes(x = price)) +
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5, bins = 40) + #You can change "bins" depending on your data. Make sure you don't have too many or too few! Play around with.
  theme_bw()+
  xlab("Price (M $)") + ylab("Count")

#Q: Describe this plot. What can you say about it?

# We can also look at some descriptive statistics:
cars %>% select(price) %>% summary(.)

# Let's create a new variable, log_price

cars <- cars %>% mutate(log_price = log(price)) #Be careful here! If Y=0, then log is not defined!

# Q; Now, plot the same plot as before, but using log_price. How would you describe this 
  
ggplot(...)

# Now let's run the regression:

lm_log <- lm(log_price ~ rating + mileage + luxury + year, data = cars)

summary(lm_log)

# Q: How do we interpret the coefficient for mileage as a percentage?

# This is a vector of coefficients
lm_log$coefficients

# This is the coefficient for mileage:
lm_log$coefficients["mileage"]

# This is the percentage change
(exp(lm_log$coefficients["mileage"]) - 1)*100


## Outliers

# Let's plot Price vs Year:

ggplot(data = cars, aes(y = price, x = year)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) +
  theme_bw()+
  xlab("Year") + ylab("Price")

# Q: Which do you think look like outliers?

#Let's identify them in the data:
# For the purpose of this exercise, every observation that has year<10 will be considered an outlier
cars <- cars %>% mutate(outliers_year = ifelse(year<10, 1, 0)) #ifelse() works like the IF() function in Excel: The first parameter is a logic statement, 
                                                               # then the value if that statement is TRUE, and then if it's FALSE.

# Let's plot it again, identifying the outliers (this is the same as we did it with luxury cars before)
ggplot(data = cars, aes(y = price, x = year, color = factor(outliers_year))) +
  geom_point(size = 3, pch = 21) +
  theme_bw()+
  xlab("Year") + ylab("Price") +
  scale_color_manual("Outliers", values = c("blue","red"))

# Now, let's run a regression with all observations:
lm1 <- cars %>% lm(price ~ rating + mileage + luxury + year, data = .) #We use a . as a stand-in for the data (`cars`) we are piping in
summary(lm1)

# Now, let's do the same but exclude the outliers:

lm1_wo <- cars %>% filter(outliers_year==0) %>% lm(price ~ rating + mileage + luxury + year, data = .)
summary(lm1_wo)

# Q: What can you say about the association between year and price? Is it sensitive to outliers?