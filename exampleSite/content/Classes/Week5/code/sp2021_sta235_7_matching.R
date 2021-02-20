##############################################################
### Title: "Week 5 - Introduction to Observational Studies"
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
library(MatchIt)


#####################################################################

## Get out the vote example

d <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week4/1_RCT/data/voters_covariates.csv") #This might take a while (it's a lot of data!)

## Show balance by stratum (we saw this the previous class! Same code)

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


########################################

# So this runs faster, we will take a random sample of 20% of the data (if you want to run it for the whole sample, just change it from 0.2 to 1)

###
p = 0.2

#I'll take out p of the sample from each stratum and treatment (to keep it balanced)
d_s1$strata <- interaction(d_s1$state, d_s1$competiv)
d_s1$slice <- interaction(d_s1$treat_real, d_s1$strata)
slice <- unique(d_s1$slice)

for(i in 1:length(slice)){
  set.seed(i)
  
  d_aux <- d_s1[d_s1$slice==slice[i],]
  
  sample <- sample(seq(1,nrow(d_aux)), nrow(d_aux)*p)
  
  d_sample_aux <- d_aux[sample,]
  
  if(i==1){
    d_sample <- d_sample_aux
  }
  if(i>1){
    d_sample <- d_sample %>% add_row(d_sample_aux)
  }
}


## Analyze the results of the RCT

#It's always advised to use robust SE to account for heteroskedasticity (homoskedastic errors are rare!)
summary(estimatr::lm_robust(vote02 ~ treat_real + strata, data = d_sample))

summary(estimatr::lm_robust(vote02 ~ treat_real + strata + persons + vote00 + vote98 + newreg + age + female2, data = d_sample))

#########################################

# Let's do some matching now. We will be using the MatchIt package (it's very complete)

# We will assume this is now observational data, so we are assuming there's no random assignment:

# The formula inside matchit() is the treatment (contact, which is different to the treatment assignment) as a function of the covariates. Remember to include the strata!
# We will just use NN matching first, and exact match on strata.
# Question: We don't include state here, why? 

m1 <- matchit(contact ~ strata + persons + vote00 + vote98 + newreg + age + female2, data = d_sample,
              method = "nearest", exact = ~ strata)

#m1$match.matrix stores the indexes for the matched control units
head(m1$match.matrix)

#We will save both the treatment and control index:
t_id <- as.numeric(rownames(m1$match.matrix)) #We extract the rownames from the matrix, and convert it to numeric
c_id <- as.numeric(m1$match.matrix[,1])

# Generate a data frame only with the matched units:
d_m1 <- d_sample[t_id,] %>% add_row(d_sample[c_id,])

# Check whether it looks good:
table(d_m1$contact) #Same number of treatment and controls!

# We can run the same OLS as before (now using contact instead of treatment assignment):
summary(estimatr::lm_robust(vote02 ~ contact + strata + persons + vote00 + vote98 + newreg + age + female2, data = d_sample))

# Let's compare it to the matched sample (remember that we matched them on their covariates, so we don't adjust for anything... should we?):
summary(estimatr::lm_robust(vote02 ~ contact, data = d_m1))


#######################

# Now we run the same but using a optimal matching. (Note: Usually to run this option you need to install the optmatch package)
m1opt <- matchit(contact ~ strata + persons + vote00 + vote98 + newreg + age + female2, data = d_sample,
               method = "subclass", exact = ~ strata)

# Question: How do results change between m1 and m1opt? Complete the code with the same stuff we did before.