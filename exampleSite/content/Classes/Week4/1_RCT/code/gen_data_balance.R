

N = 1000 #Sample size
p = 0.5 #proportion assigned to treatment

#Assign treatment:

id <- seq(1,N)

set.seed(100)

treat_id <- sample(id, N*p)
control_id <- id[!(id %in% treat_id)]

z <- rep(0, length(id)) #<<
z[treat_id] <- 1 #<<

d <- data.frame("id" = id,"z" = z)

# Generate covariates:
n_covs = 20

X = matrix(NA, ncol = n_covs, nrow = N)

for(j in 1:n_covs){
  
  set.seed(j)
  
  X[,j] = rnorm(N)

}

d <- as.data.frame(cbind(d,X))

names(d) <- c("id","z",paste0("x",seq(1,20)))