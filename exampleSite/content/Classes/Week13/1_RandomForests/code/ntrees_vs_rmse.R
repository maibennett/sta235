```{r dt_vs_bag, fig.height=5, fig.width=10, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}
library(doParallel) 
library(foreach)

rmse <- RMSE(pred.mcv, carseats.test$Sales) 

# Create a parallel socket cluster
cl <- makeCluster(8) # use 8 workers
registerDoParallel(cl) # register the parallel backend

# Fit trees in parallel and compute predictions on the test set
rmse_bt <- foreach(
  i = 1:200, 
  .packages = c("rpart","ipred","caret"), 
  .combine = c
) %dopar% {
  bt <- bagging(
    Sales ~ .,
    nbagg = i,
    control = rpart.control(cp = 0),
    data = carseats.train
  ) 
  
  RMSE(predict(bt, newdata = carseats.test), carseats.test$Sales)
}

d <- data.frame(rmse_bt = rmse_bt,
                n_trees = seq(1:200))

ggplot(data = d, aes(x = n_trees, y = rmse_bt)) +
  geom_line(aes(color = "dark grey"), lwd = 1.2) +
  geom_hline(aes(yintercept = rmse, color = "#BF3984"), lty = 2, lwd = 1.3) +
  xlab('Number of trees') + ylab("RMSE") +
  scale_color_manual(values=c("#BF3984","dark grey"),labels=c("RMSE bagging", "RMSE best pruned DT")) +
  theme_bw()+ theme_ipsum_fsc()+
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        #panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank())+
  #axis.line = element_blank())+
  theme(axis.title.x = element_text(size=16),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size = 10),
        axis.title.y = element_text(size=16),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size = 10),legend.position=c(0.9,0.7),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

# Shutdown parallel cluster
stopCluster(cl)
``` 