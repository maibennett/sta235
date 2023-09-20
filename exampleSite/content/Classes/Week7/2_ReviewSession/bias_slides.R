---
  # What happens if the ignorability assumption doesn't hold?
  
  - Now, let's assume $(Y(0), Y(1)) \not\!\perp\!\!\!\perp Z$

$$\tau = E[Y_i(1)] - E[Y_i(0)] \neq E[Y_i| Z=1] - E[Y_i| Z=0]$$
.box-4LA[Correlation does not imply causation]

---
# What happens if the ignorability assumption doesn't hold?
  
  - Now, let's assume $(Y(0), Y(1)) \not\!\perp\!\!\!\perp Z$

$$\tau = E[Y_i(1) - Y_i(0)] = $$
$$=E[Y_i(1) - Y_i(0)|Z=1]Pr(Z=1) + E[Y_i(1) - Y_i(0)|Z=1](1-Pr(Z=1))$$
---
# What happens if the ignorability assumption doesn't hold?
  
  - Now, let's assume $(Y(0), Y(1)) \not\!\perp\!\!\!\perp Z$

$$\tau = E[Y_i(1) - Y_i(0)] = $$

$$=\color{#900DA4}{\underbrace{E[Y_i(1) - Y_i(0)|Z=1]}_\text{ATT}}Pr(Z=1) + \color{#F89441}{\overbrace{E[Y_i(1) - Y_i(0)|Z=0]}^\text{ATC}}(1-Pr(Z=1))$$
- Weighted average of the ATT and ATC.

---
# What happens if the ignorability assumption doesn't hold?
  
  - After some simple math, you can get to:
  
  $$\tau = E[Y_i(1) - Y_i(0)] = ATE$$
    
    $$\begin{aligned}
  ATE &=E[Y_i|Z=1] - E[Y_i|Z=0] \\
  \\
  & - (E[Y_i(0)|Z=1]-E[Y_i(0)|Z=0]) \\
  \\
  & - (1-Pr(Z=1))(ATT - ATC)
  \end{aligned}$$
    <br>
    <br>
    <br>
    <br>
    .source[Check out [Scott Cunningham's "Causal Inference: The Mixtape" (Ch. 4.1.3)](https://mixtape.scunning.com/ch3.html) for the decomposition]

---
# What happens if the ignorability assumption doesn't hold?
                         
                         - After some simple math, you can get to:
                         
                         $$\tau = E[Y_i(1) - Y_i(0)] = ATE$$
                         
                         $$\begin{aligned}
                       ATE &=\color{#900DA4}{\underbrace{E[Y_i|Z=1] - E[Y_i|Z=0]}_\text{Obs diff in means}} \\
                         & - \color{#E16462}{\underbrace{(E[Y_i(0)|Z=1]-E[Y_i(0)|Z=0])}_\text{Selection bias}} \\
                           & - \color{#FCCE25}{\underbrace{(1-Pr(Z=1))(ATT - ATC)}_\text{Heterogeneous treat. effect bias}}
                             \end{aligned}$$
                               - **.darkorange[Selection Bias:]** Difference between groups if they both were under control.
                             - **.darkorange[Heterogeneous Treatment Effect Bias:]** Difference in returns to treatment for the two groups (weighted by the control population).
                             <br>
                               .source[Check out [Scott Cunningham's "Causal Inference: The Mixtape" (Ch. 4.1.3)](https://mixtape.scunning.com/ch3.html) for the decomposition]
---
# How would bias look like?

```{r PO1, fig.height=5.5, fig.width=7.5, fig.align='center', dev='svg', echo=FALSE, warning=FALSE, message = FALSE}
periods = 10
n = 100

for(p in 1:periods){
  set.seed(p)
  
  t_aux = rep(p,n)
  y0_0_aux = rnorm(100, 0, 0.5)
  y1_0_aux = 0.5 + 0.01*p + rnorm(100, 0, 0.5)
  
  y0_1_bias_aux = -0.3 - 0.01*p + rnorm(100, 0, 0.5)
  
  y1_1_hetero_aux = 1 + 0.02*p + rnorm(100, 0, 0.5)
 
  if(p==1){
    t = t_aux
    y0_0 = y0_0_aux
    y1_0 = y1_0_aux
    
    y0_1_bias = y0_1_bias_aux
    y1_1_hetero = y1_1_hetero_aux
  } 
  
    if(p>1){
    t = c(t,t_aux)
    y0_0 = c(y0_0,y0_0_aux)
    y1_0 = c(y1_0,y1_0_aux)
    
    y0_1_bias = c(y0_1_bias,y0_1_bias_aux)
    y1_1_hetero = c(y1_1_hetero,y1_1_hetero_aux)
  } 
}

d = data.frame("t" = t,
               "y0_0" = y0_0,
               "y1_0" = y1_0,
               "y0_1_bias" = y0_1_bias,
               "y1_1_hetero" = y1_1_hetero)

ggplot(data = d, aes(x = t, y = y0_0)) +
  geom_smooth(method = "gam", se=FALSE, lty=1, color = "#900DA4", lwd=1.4) +
  #geom_smooth(aes(x = t, y = y1_0), method = "gam", se=FALSE, lty=2, color = "#F89441", lwd=1.4) +
  geom_smooth(aes(x = t, y = y1_1_hetero), method = "gam", se=FALSE, lty=1, color = "#FCCE25", lwd=1.4) +
  ylim(-0.5,1.5)+
  #ggplot2::annotate("text", x = 9, y = 0.5, label = "Y(1)|Z=0", size = 6, colour = "#F89441", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = 1.1, label = "Y(1)|Z=1", size = 6, colour = "#FCCE25", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = 0.05, label = "Y(0)|Z=0", size = 6, colour = "#900DA4", hjust=0,family="Fira Sans Condensed") +
  theme_bw()+
  theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  xlab("Time") + ylab("Potential Outcome")+#ggtitle("How comfortable are you with R?")+
  theme(plot.margin=unit(c(0.5,1,1,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_blank(),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_blank(),legend.position="none",
        legend.title = element_blank(),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

```

---
# How would bias look like?

```{r PO2, fig.height=5.5, fig.width=7.5, fig.align='center', dev='svg', echo=FALSE, warning=FALSE, message = FALSE}

ggplot(data = d, aes(x = t, y = y0_0)) +
  geom_smooth(method = "gam", se=FALSE, lty=1, color = "#900DA4", lwd=1.4) +
  #geom_smooth(aes(x = t, y = y1_0), method = "gam", se=FALSE, lty=2, color = "#F89441", lwd=1.4) +
  geom_smooth(aes(x = t, y = y0_1_bias), method = "gam", se=FALSE, lty=2, color = "#5601A4", lwd=1.4) +
  geom_smooth(aes(x = t, y = y1_1_hetero), method = "gam", se=FALSE, lty=1, color = "#FCCE25", lwd=1.4) +
  ylim(-0.5,1.5)+
  #ggplot2::annotate("text", x = 9, y = 0.5, label = "Y(1)|Z=0", size = 6, colour = "#F89441", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = 0.05, label = "Y(0)|Z=0", size = 6, colour = "#900DA4", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = 1.1, label = "Y(1)|Z=1", size = 6, colour = "#FCCE25", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = -0.15, label = "Y(0)|Z=1", size = 6, colour = "#5601A4", hjust=0,family="Fira Sans Condensed") +
  theme_bw()+
  theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  xlab("Time") + ylab("Potential Outcome")+#ggtitle("How comfortable are you with R?")+
  theme(plot.margin=unit(c(0.5,1,1,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_blank(),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_blank(),legend.position="none",
        legend.title = element_blank(),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

```

---
# How would bias look like?

```{r PO3, fig.height=5.5, fig.width=7.5, fig.align='center', dev='svg', echo=FALSE, warning=FALSE, message = FALSE}

ggplot(data = d, aes(x = t, y = y0_0)) +
  geom_smooth(method = "gam", se=FALSE, lty=1, color = "#900DA4", lwd=1.4) +
  geom_smooth(aes(x = t, y = y1_0), method = "gam", se=FALSE, lty=2, color = "#F89441", lwd=1.4) +
  geom_smooth(aes(x = t, y = y0_1_bias), method = "gam", se=FALSE, lty=2, color = "#5601A4", lwd=1.4) +
  geom_smooth(aes(x = t, y = y1_1_hetero), method = "gam", se=FALSE, lty=1, color = "#FCCE25", lwd=1.4) +
  ylim(-0.5,1.5)+
  ggplot2::annotate("text", x = 9, y = 0.5, label = "Y(1)|Z=0", size = 6, colour = "#F89441", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = 0.05, label = "Y(0)|Z=0", size = 6, colour = "#900DA4", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = -0.15, label = "Y(0)|Z=1", size = 6, colour = "#5601A4", hjust=0,family="Fira Sans Condensed") +
  ggplot2::annotate("text", x = 9, y = 1.1, label = "Y(1)|Z=1", size = 6, colour = "#FCCE25", hjust=0,family="Fira Sans Condensed") +
  theme_bw()+
  theme_ipsum_fsc(plot_title_face = "bold",plot_title_size = 24) + #plain 
  xlab("Time") + ylab("Potential Outcome")+#ggtitle("How comfortable are you with R?")+
  theme(plot.margin=unit(c(0.5,1,1,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_blank(),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_blank(),legend.position="none",
        legend.title = element_blank(),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="white"),
        title = element_text(size=14))

```
