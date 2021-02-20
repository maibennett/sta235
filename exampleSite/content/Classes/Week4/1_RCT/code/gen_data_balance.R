##############################################################
### Title: "Week 4 - Randomized Controlled Trials"
### Course: STA 235
### Semester: Spring 2021
### Professor: Magdalena Bennett
##############################################################

# Clears memory
rm(list = ls())
# Clears console
cat("\014")

### Load libraries
# If you don't have one of these packages installed already, you will need to run install.packages() line
library(tidyverse)
library(ggplot2)
library(generics)
library(estimatr)
library(designmatch)

## Generating random assignment

N = 1000 #Sample size
p = 0.5 #proportion assigned to treatment

#Assign treatment:

id <- seq(1,N) #Generate a vector of uniques id's (from 1 to N)

set.seed(100) #We set a seed so our assignment is replicable

treat_id <- sample(id, N*p) #Out of the id vector, we randomly choose half (N*p)
control_id <- id[!(id %in% treat_id)] #Units in the control group are all of those that DON'T belong to the treatment group.

z <- rep(0, length(id)) #Generate a vector of treatment assignment, first all with 0s
z[treat_id] <- 1 #Now I change z=1 for those that are in the treatment group

d <- data.frame("id" = id,"z" = z) #I create a dataframe

## Question: Can you adapt the previous code to treat only 20% of the units?

## Question: Can you adapt this code for 4 different treatment levels (3 treaments + 1 control)? Tip: Check the slides to get some help!

####################################

## Now, we are randomly going to generate covariates:

n_covs = 20 #We will generate 20 covariates

X = matrix(NA, ncol = n_covs, nrow = N) #X will be our matrix of covariates, where each column will be a covariate and each row an observation!


for(j in 1:n_covs){ #This just generates a loop, starting from 1 until n_covs
  
  set.seed(j) #I set a seed to make this realization replicable
  
  X[,j] = rnorm(N) #Each covariate is going to have the same distribution: random samples (N units) from a normal distribution of mean 0 and SD 1 (which is the default for rnorm) --> If you ever have questions about a function, you can type ?rnorm() in the console!

}

d <- as.data.frame(cbind(d,X)) #I now append the covariates to my previous dataframe that had the ids and treatment assignment z.

names(d) <- c("id","z",paste0("x",seq(1,20))) #I give appropriate names to the variables so I can identify them.

write.csv(d, file="covariates_example.csv") #This is the file that is up in github! you can actually read it staight from there.

# Check balance:

library(designmatch) #I'll load the package design match to use the very useful function it has: meantab

meantab(X, d$z, which(d$z==1), which(d$z==0)) #meantab creates a balance table, where the first argument is the matrix (or dataframe) of covariates (ONLY COVARIATES! AND THEY NEED TO BE NUMERIC!)
                                              #The second argument is the vector of treatment assignment. Finally, the third and fourth arguments are the index for the treatment and control units, respectively.

#Question: How would you construct X if you only had the dataframe? (hint: you can use the function `select()` from the tidyverse, or find other ways to select only the columns for covariates). Try it!

###################################################

#### Balance in expectation

sim = 100 #First, we are just going to run 100 simulations

# Diff for x1:

diff = rep(NA,sim) #We create an empty vector to store the difference between the T and C group for each simulation (that's why its length is sim)

for (s in 1:sim){ #Another loop, which will go through each simulation (so it'll go around 100 times)
  
  set.seed(s) #set a seed for replicability
  
  # Same as before, we generate a vector for treatment assignment.
  treat_id <- sample(id, N*p)
  control_id <- id[!(id %in% treat_id)]
  
  z <- rep(0, length(id))
  z[treat_id] <- 1
  
  #For element s of the diff vector, we store the difference in sample means between the treatment and the control group.
  diff[s] = mean(d$x1[z==1]) - mean(d$x1[z==0])
  
  ## Question: What would you have to do if the covariate x1 had missing values? Write it down!
  
}

# Now a plot the density of the differences for each simulation. What can you see?

data.frame("diff" = diff) %>% ggplot(aes(x = diff)) +
  geom_density(color = "darkorange", lwd=2) +
  theme_bw() + xlab("Diff T-C by simulation") + ylab("Density") +
  geom_vline(aes(xintercept = 0), lty = 2, color = "dark grey", lwd = 1.5)

## Question: Create two other vectors (diff10k and diff100k, for 10k and 100k simulations respectively). Plot the three densities together. What can you see?


#####################################################################

## Get out the vote example

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week4/1_RCT/data/voters_covariates.csv") #This might take a while (it's a lot of data!)

# Drop variables with unlisted phone numbers
d_s1 <- d[!is.na(d$treat_real),]

# View balance without using meantab()
tab <- d_s1 %>%
  group_by(state, competiv, treat_real) %>% #group the data by state, whether it's a competitive district or not, and by treatment status
  relocate(state, competiv, treat_real, female2, fem_miss, age, newreg, persons, contact, vote98, vote00) %>% #relocate just reorders/shuffles the position of the variables in a dataframe, so they make more sense when I generate the table (this step is not necessary)
  dplyr::select(-c(treat_pseudo, vote02)) %>% #I exclude the variables that I don't want to show in the balance table (like the outcome!)
  summarize_all(mean) #The I summarize the data (by the groups I previously mentioned).

tab # What can you see? Describe this table! Hint: What does each row represent?

rnames <- colnames(tab) #I save the columns names

tab <- round(t(tab),3) #Now, I round up the number (too many digits never looks pretty), and transpose the matrix, so each row is a covariate

tab #See?

rownames(tab) <- rnames
colnames(tab) <- paste0("V",seq(1,8))

write.csv(tab, file="balance_gotv.csv") #I can save this table in a csv so I can format it later if I want (if you don't specify a path, it will store it in whatever your default working directory is)

tab <- as.data.frame(tab)

library(reactable) #This is a neat little package to generate interactive tables. It's not necessary for you to use it.


tbl <- tab[4:11,] %>% #I leave out the state, competitive, and treatment status (meaning, I only keep the covariates!)
  reactable(
    # ALL one page (no scrolling or page swapping)
    pagination = TRUE,
    rownames = TRUE,
    # compact for an overall smaller table width wise
    compact = FALSE,
    # borderless - TRUE or FALSE
    borderless = FALSE,
    # Stripes - TRUE or FALSE
    striped = TRUE,
    # fullWidth - either fit to width or not
    fullWidth = TRUE,
    # apply defaults
    # 100 px and align to center of column
    defaultColDef = colDef(
      align = "center"),
    style = list(fontFamily = "Fira Sans, sans-serif"), #You can specify any font you want
    
    columns = list(#Here I'm just saying that the columns go treat, control, treat, control, etc.. for each stratum
      V1 = colDef(name = "Treat"),
      V2 = colDef(name = "Control",
                  style = list(borderRight = "1px solid rgba(0, 0, 0, 0.1)")),
      V3 = colDef(name = "Treat"),
      V4 = colDef(name = "Control",
                  style = list(borderRight = "3px solid rgba(0, 0, 0, 0.1)")),
      V5 = colDef(name = "Treat"),
      V6 = colDef(name = "Control",
                  style = list(borderRight = "1px solid rgba(0, 0, 0, 0.1)")),
      V7 = colDef(name = "Treat"),
      V8 = colDef(name = "Control")
    ),
    columnGroups = list(#This will group columns according to their competitiveness... Unfortunately, we can't group them by state, but the first four columns are state 1, and the last four are state 2.
      colGroup(name = "Non-competitive", columns = c("V1", "V2")),
      colGroup(name = "Competitive", columns = c("V3", "V4")),
      colGroup(name = "Non-competitive", columns = c("V5", "V6")),
      colGroup(name = "Competitive", columns = c("V7", "V8")),
      colGroup(name = "State 1", columns = c("V1","V2","V3", "V4"))
      
    ),
    highlight = TRUE
    
  )

tbl



## Analyze the results of the RCT

#First, I generate a variable for each stratum
d_s1$strata <- interaction(d_s1$state, d_s1$competiv)

is.factor(d_s1$strata) #Check whether it's a factor or not.

#It's always advised to use robust SE to account for heteroskedasticity (homoskedastic errors are rare!)
summary(estimatr::lm_robust(vote02 ~ treat_real + strata, dat = d_s1))

#See that not every person that was assigned to treatment was actually contacted.
table(d_s1$treat_real, d_s1$contact)

#Question: What happen that instead of using treatment assignment you regressed vote02 on `contact`? What's the estimate for that regression? Is that a treatment effect, under what assumptions, and for what population?