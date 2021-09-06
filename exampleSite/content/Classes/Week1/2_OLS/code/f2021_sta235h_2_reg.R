##########################################################
### Title: "Week 1 and 2 - Multiple Regression"
### Course: STA 235H
### Semester: Fall 2021
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
#install.packages("vtable")
library(vtable)

################################################################################
### In-class exercises
################################################################################

# Load data
rawData <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/data/bechdel.csv")

# Select movies post 1990
rawData <- rawData %>% filter(Year>1989)

# Create return on Investment (ROI) measures
# Passes Bechdel test:
rawData <- rawData %>% mutate(ROI = Revenue/Budget, #  Total ROI
                              pass_bechdel = ifelse(rating==3, "PASS", "FAIL"))

vtable(rawData) # Q: What do you see? Which variables would you pay the most attention to? What else would you explore?

# We will use `Adj_Revenue` as the outcome. Why adjusted?
# Plot the outcome: How would you do it? (Hint: Histograms can be useful)

ggplot(data = rawData, aes(x = Adj_Revenue/1000000)) +
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5) + # color: line color, fill: fill color, lwd: line width.
  theme_bw()+
  xlab("Adj. Revenue (MM $)") + ylab("Count") +
  # These are options to make the plot look nicer
  theme(axis.title.x = element_text(size=18), # This changes size of the x-axis title
        axis.text.x = element_text(size=14), # This changes size of the x-axis text
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),
        legend.position="none", # With this I can eliminate a legend (don't need it). If you do need one, you can position it e.g. c(0.9,0.9)  <-- this would be top-right
        title = element_text(size=18), # If I had a title, this would be the size of the text.
        plot.margin=unit(c(1,1,1.5,1.2),"cm"), # I can also adjust margins
        panel.grid = element_blank(), # I want to eliminate grid lines (you can also use panel.grid.major.x or panel.grid.minor.y, etc. depending the grid lines you want to incorporate)
        axis.line = element_line(colour = "dark grey"))


# Let's transform our outcome with a logarithm. What do we get?
ggplot(data = rawData, aes(x = log(Adj_Revenue/1000000))) +
  geom_histogram(color = "#BF3984", fill = "white", lwd = 1.5) +
  theme_bw()+
  xlab("Adj. Revenue (MM $)") + ylab("Count") +
  theme(axis.title.x = element_text(size=18),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),
        axis.text.y = element_text(size=14),
        legend.position="none",
        title = element_text(size=18),
        plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid = element_blank(),
        axis.line = element_line(colour = "dark grey"))


# Let's only look only a the movies with positive revenue (we're optimistic)

bechdel <- rawData %>% #....complete the code here
  
bechdel <- bechdel %>% rename(imdb = imdbRating) %>%
  mutate(log_Adj_Revenue = log(Adj_Revenue),
         log_Adj_Budget = log(Adj_Budget),
         bechdel_test = ifelse(pass_bechdel=="PASS",1,0))


# Let's run some models

lm_simple <- lm(log(Adj_Revenue) ~ bechdel_test, data = bechdel)

summary(lm_simple) # Question: Recover the coefficient and interpret it as a % change.

# Now include other covariates (like budget, metascore, and imdb rating)

lm_multi <- lm()#... complete


# Standardize the variables:

# The function `scale2()` takes two arguments: a variable x and a logical value
# (which says whether we include missing values or not in the calculations)

scale2 <- function(x, na.rm = FALSE){
  # Anything that's between return() parenthesis is what the function will return.
  # In this case, it substracts the mean and divides by the SD of x
  return((x - mean(x, na.rm = na.rm)) / sd(x, na.rm))
} 

# Create a new dataset with standardized variables:
bechdel_std <- bechdel %>% select(log_Adj_Revenue,log_Adj_Budget, 
                                  bechdel_test, Metascore, imdbRating) %>%
  mutate_all(.,~scale2(.,na.rm=TRUE))

summary(lm(log_Adj_Revenue ~ bechdel_test + log_Adj_Budget + Metascore + imdbRating, 
           data=bechdel_std))

## Q: How do the effects compare?





################################################################################
### Additional code (if you want to check it at home)
################################################################################

# Load advertising data from ISLR (and read it as a tibble)
d <- as.tibble(read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week1/2_OLS/data/advertising.csv"))


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

# Plot the 3D scatter plot + regression plane:
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
