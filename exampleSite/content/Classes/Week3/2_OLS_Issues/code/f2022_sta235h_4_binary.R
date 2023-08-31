######################################################################
### Title: "Week 3 - Binary Responses"
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
library(estimatr)

################################################################################
### In-class exercises
################################################################################


###################### BINARY RESPONSE #########################################

data("HMDA")

# To know what the variables are, you can type ?HMDA on the console
head(HMDA)

#Let's transform the variable deny into a 0-1 variable:
HMDA <- HMDA %>% mutate(deny = as.numeric(deny) - 1)

## Linear Probability Model

# Let's run a simple model:
summary(lm(deny ~ pirat, data = HMDA))

# Let's look at the fitted regression line and the data:
ggplot(data = HMDA, aes(x = pirat, y = deny)) + 
  #"pch=21" selects a marker with a different outline (circle), "color" changes the outline of the marker, "fill" changes the fill color (alpha changes transparency)
  geom_point(color = "#5601A4", fill = alpha("#5601A4",0.4), pch=21, size = 3) +
  
  #geom_smooth (with method "lm") adds a regression line (play around with the options! what happens if se = TRUE?)
  geom_smooth(method = "lm", color = "#BF3984", se = FALSE, lty = 1, lwd = 1.3) +
  
  # Adds horizontal lines (hlines) to show where 0 and 1 are.
  geom_hline(aes(yintercept = 0), color="dark grey", lty = 2, lwd=1)+
  geom_hline(aes(yintercept = 1), color="dark grey", lty = 2, lwd=1)+
  
  theme_bw()+
  xlab("Payment/Income ratio") + ylab("Deny")

# Let's run robust standard errors now

model2 <- lm_robust(deny ~ pirat, data = HMDA)

summary(model2)

# We can add more variables too:
model3 <- estimatr::lm_robust(deny ~ pirat + factor(afam), data = HMDA)
summary(model3)

# Q: How do these standard errors compare to the same LPM WITHOUT robust standard errors? Are they larger or smaller?
