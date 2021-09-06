######################################################################
### Title: "Week 2 - Interactions Models, Colinearity, and Residuals"
### Course: STA 235H
### Semester: Fall 2021
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

cars <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week2/2_OLS_probs/data/SoCalCars.csv", stringsAsFactors = FALSE)

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


# Let's run a regression of price on mileage, year, rating, and the interaction of mileage and year.
lm2 <- lm(price ~ rating + mileage + year*luxury, data = cars)

summary(lm2)

#Question: What's the change in price for one additional year for luxury-brand cars vs non-luxury-brand cars, holding other variables constant?


## Let's plot mileage against year. What do you see?

ggplot(data = cars, aes(y = mileage, x = year)) +
  geom_point(fill = "white", color = "orange", size = 3, pch = 21) + #pch changes the type of the marker (you can see the options here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
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


# Now, let's look at it by luxury vs non-luxury car
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


#### Let's build the residuals

cars <- cars %>% mutate(price_hat = predict(lm(price ~ rating + mileage + year, data = .)), 
                        residual = price - price_hat)


# Looking at the code in class (and the code above), build a histogram for residuals and a catter plot for residuals and the dependent variable.
# Note: Use "log(price)" for your dependent variable. How do the plots look if you use "price" instead?
