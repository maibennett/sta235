


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
prob_nv <- 0.203
prob_v <- 0.142

y1_nv <- sample(c(0,1),1436,replace = TRUE, prob = c(1-prob_nv,prob_nv))
y1_v <- sample(c(0,1),614,replace = TRUE, prob = c(1-prob_v,prob_v))

treat_nv <- sample(c("m","e"), 1436, replace = TRUE, prob = c(36/1436,1-36/1436))
treat_v <- sample(c("m","e"), 614, replace = TRUE, prob = c(514/614,1-514/614))

confound <- data.frame("id" = seq(1,2050),
                       "visit" = c(rep(0,1436),rep(1,614)),
                       "treat" = c(treat_nv,treat_v),
                       "y" = c(y1_nv, y1_v))

summary(lm(y ~ factor(treat), data = confound))

summary(lm(y ~ factor(treat) + visit, data = confound))


# Collider

set.seed(14)

treat <- sample(c("m","e"), 2050, replace = TRUE, prob = c(1-0.732,0.732))

y1 <- sample(c(0,1), 2050, replace = TRUE, prob=c(1-0.1843,0.1843))

visit_m_0 <- sample(c(0,1),sum(treat=="m" & y1==0),replace = TRUE, prob = c(1-90/1210,90/1210))
visit_m_1 <- sample(c(0,1),sum(treat=="m" & y1==1),replace = TRUE, prob = c(1-10/290,10/290))

visit_e_0 <- sample(c(0,1),sum(treat=="m" & y1==0),replace = TRUE, prob = c(1-437/462,437/462))
visit_e_1 <- sample(c(0,1),sum(treat=="m" & y1==1),replace = TRUE, prob = c(1-77/88,77/88))

visit <- 0
visit[which(treat=="m" & y1==0)] <- visit_m_0
visit[which(treat=="m" & y1==1)] <- visit_m_1
visit[which(treat=="e" & y1==0)] <- visit_e_0
visit[which(treat=="e" & y1==1)] <- visit_e_1

collider <- data.frame("id" = seq(1,2050),
                       "visit" = visit,
                       "treat" = treat,
                       "y" = y1)

summary(lm(y ~ factor(treat), data = collider))

summary(lm(y ~ factor(treat) + visit, data = collider))
