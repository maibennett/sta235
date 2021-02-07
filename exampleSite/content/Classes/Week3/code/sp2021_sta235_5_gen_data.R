


set.seed(102)

n_A <- 1500

n_B <- 550

y_A <- rep(0, n_A)
y1_A <- sample(seq(1:n_A),290)
y_A[y1_A] <- 1 

y_B <- rep(0, n_B)
y1_B <- sample(seq(1:n_B),88)
y_B[y1_B] <- 1


# Confounding:

# probability of registering depending on whether you've visited the website or not (and are reminded of it)
prob_nv <- 0.20
prob_v <- 0.14

y1_nv <- sample(c(0,1),1436,replace = TRUE, prob = c(1-prob_nv,prob_nv))
y1_v <- sample(c(0,1),614,replace = TRUE, prob = c(1-prob_v,prob_v))

treat_nv <- sample(c("m","e"), 1436, replace = TRUE, prob = c(0.065,0.935))
treat_v <- sample(c("e","m"), 614, replace = TRUE, prob = c(0.065,0.935))

confound <- data.frame("id" = seq(1,2050),
                       "visit" = c(rep(0,1436),rep(1,614)),
                       "treat" = c(treat_nv,treat_v),
                       "y" = c(y1_nv, y1_v))

summary(lm(y ~ factor(treat), data = confound))

summary(lm(y ~ factor(treat) + visit, data = confound))


# Collider

set.seed(14)

treat <- sample(c("m","e"), 2050, replace = TRUE, prob = c(1-0.732,0.732))

visit_m <- sample(c(0,1), sum(treat=="m"), replace = TRUE, prob = c(1-0.9345,0.9345))

visit_e <- sample(c(0,1), sum(treat=="e"), replace = TRUE, prob = c(1-0.0667,0.0667))

visit <- 0
visit[which(treat=="m")] <- visit_m
visit[which(treat=="e")] <- visit_e

y1_m_nv <- sample(c(0,1),sum(treat=="m" & visit==0),replace = TRUE, prob = c(1-0.31,0.31))
y1_m_v <- sample(c(0,1),sum(treat=="m" & visit==1),replace = TRUE, prob = c(1-0.15,0.15))

y1_e_nv <- sample(c(0,1),sum(treat=="e" & visit==0),replace = TRUE, prob = c(1-0.2,0.2))
y1_e_v <- sample(c(0,1),sum(treat=="e" & visit==1),replace = TRUE, prob = c(1-0.1,0.1))

y1 <- rep(0,2050)
y1[which(treat=="m" & visit==0)] <- y1_m_nv
y1[which(treat=="m" & visit==1)] <- y1_m_v

y1[which(treat=="e" & visit==0)] <- y1_e_nv
y1[which(treat=="e" & visit==1)] <- y1_e_v

collider <- data.frame("id" = seq(1,2050),
                       "visit" = visit,
                       "treat" = treat,
                       "y" = y1)

summary(lm(y ~ factor(treat), data = collider))

summary(lm(y ~ factor(treat) + visit, data = collider))
