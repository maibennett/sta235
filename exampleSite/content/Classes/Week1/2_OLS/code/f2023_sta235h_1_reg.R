##########################################################
### Title: "Week 1 - Multiple Regression"
### Course: STA 235H
### Semester: Fall 2023
### Professor: Magdalena Bennett
##########################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(ggplot2)

################################################################################
### In-class exercises
################################################################################

# Load data
rawData <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/data/bechdel.csv")

# Select movies post 1990
bechdel <- rawData %>% filter(Year>1989)

# Passes Bechdel test:

## 1) Create a binary variable called bechdel test that takes the value "PASS" if the rating == 3, and "FAIL" otherwise.
bechdel <- bechdel %>% mutate(bechdel_test = ifelse(rating==3, "PASS", "FAIL"),
                              Adj_Revenue = Adj_Revenue/10^6,
                              Adj_Budget = Adj_Budget/10^6)

# Q: Why do we divide revenue and budget by 10^6? Does it change our results and how?

# Let's run some models

lm_simple <- lm(Adj_Revenue ~ bechdel_test, data = bechdel)

summary(lm_simple) # Q: Recover the coefficient and interpret it

# Now include other covariates (like budget, metascore, and imdb rating)

lm_multi <- lm()#... complete

# Q: Show the results of your new model. Interpret the coefficients.



################################################################################
### Additional code (if you want to check it at home)
################################################################################

# Load advertising data from ISLR
d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/data/advertising.csv")


# Let's run a simple linear model
# - Use lm() to run a linear model
# - The function `summary()` provides additional information (like SE and R2)
summary(lm(Sales ~ TV, data = d))

# Obtain fitted values and residuals
d <- d %>% mutate(Sales_hat = predict(lm(Sales ~ TV, data = .)), 
                  residual = Sales - Sales_hat)


# Scatter plot (base plot)
adv_base <- ggplot(data = d, aes(x = TV, y = Sales)) +
  # pch: changes the shape/type of marker
  # color and fill: define the outline and fill color of the marker
  geom_point(size = 4, color="dark grey", pch=21, fill=alpha("dark grey",0.4)) +
  # Clean theme (removes grey background)
  theme_bw()+
  xlab("TV") + ylab("Sales")+ggtitle("Simple regression")

# Add regression line and error terms
adv_with_residual <- adv_base +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  geom_segment(aes(xend = TV, yend = Sales_hat), color = alpha("#BF3984",0.5), size = 0.8)

adv_with_residual


# Multiple regression
# Let's run the same model, but let's include Newspaper
summary(lm(Sales ~ TV + Newspaper, data = d))

## Q: How does the model change with respect to the simple linear model?

# Now let's build a 3D plot

# We will use the plotly package. If you don't have it installed, run the following line:
# install.packages("plotly)
library(plotly)

# Create a grid for the values of TV and Newspaper, from their min to their max
x_grid <- seq(from = min(d$TV), to = max(d$TV), length = 50)
y_grid <- seq(from = min(d$Newspaper), to = max(d$Newspaper), length = 50)

# Recover the estimates of beta from the previous model:
beta_hat <- d %>% lm(Sales ~ TV + Newspaper, data = .) %>% coef()

# Now for each value of x and y, generate the fitted Sales value:
fitted_values <- crossing(y_grid, x_grid) %>% 
  mutate(z_grid = beta_hat[1] + beta_hat[2]*x_grid + beta_hat[3]*y_grid)

# Finally, generate the grid for the plane from the fitted values (it's a matrix!)
z_grid <- fitted_values %>% 
  pull(z_grid) %>%
  matrix(nrow = length(x_grid)) %>%
  t()

# Plot the 3D scatter plot + regression plane (this is an interactive plot!):
plot_ly(data = d, z = ~Sales, x = ~TV, y = ~Newspaper, opacity = 1,
        showlegend = FALSE) %>%
  add_markers() %>%
  add_surface(x = x_grid, y = y_grid, z = z_grid, showscale = FALSE, opacity = 0.5) %>%
  layout(
    scene = list(
      xaxis = list(title = "TV"),
      yaxis = list(title = "Newspaper"),
      zaxis = list(title = "Sales")
    ))
