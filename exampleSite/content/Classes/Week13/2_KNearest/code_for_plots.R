---
  title: "STA 235 - Causal Inference: K-nearest neighbors"
subtitle: "Spring 2021"
author: "McCombs School of Business, UT Austin"
output:
  xaringan::moon_reader:
  css: ["xaringan-themer.css", "custom.css"]
lib_dir: libs
nature:
  highlightStyle: github
highlightLines: true
countIncrementalSlides: false
ratio: "16:9"
beforeInit: ["macros.js","cols_macro.js"]
includes:
  in_header: header.html
---
  
  ```{r setup, include=FALSE}
options(htmltools.dir.version = FALSE)
knitr::opts_chunk$set(fig.showtext = TRUE)
```

```{r xaringan-themer, include=FALSE, warning=FALSE}
library(xaringanthemer)

theme_xaringan(
  text_color = "#333f48",
  background_color = "#FFFFFF",
  accent_color = "#900DA4",
  text_font = "Fira Mono",
  text_font_use_google = TRUE,
  title_font = "Yanone Kaffeesatz",
  title_font_use_google = TRUE
)

style_mono_accent(
  #base_color = "#bf5700",
  extra_fonts = list(google_font("Fira Sans","200","300","400","500","600"),
                     google_font("Fira Sans Condensed","200","300","400","500","600")),
  base_color = "#333f48",
  header_font_google = google_font("Yanone Kaffeesatz","200","300","400","500","600","700"),
  text_font_google   = google_font("Roboto Condensed", "300", "300i","400","500"),
  code_font_google   = google_font("Fira Mono"),
  text_bold_color = "#333f48",
  text_font_size = "125%",
  colors = c(
    lightgrey = "#C0C0C0",
    red = "#f34213",
    purple = "#900DA4",
    darkpurple = "#61077a",
    darkorange = "#db5f12",
    orange = "#ff8811",
    green = "#136f63",
    white = "#FFFFFF"),
  extra_css = list(
    ".remark-slide table" = list("display" = "table",
                                 "width" = "80%",
                                 "text-align" = "left"),
    ".remark-slide-number" = list("display" = "none"),
    ".strong" = list("font-weight" = "400"),
    ".big" = list("font-size" = "350%",
                  "font-family" = "Yanone Kaffeesatz",
                  "font-weight"="400"),
    ".small" = list("font-size" = "80%"),
    ".tiny" = list("font-size" = "50%"),
    ".large" = list("font-size" = "150%"),
    ".source" = list("color" = "#8c8c8c",
                     "font-size" = "80%"),
    ".remark-slide table td#highlight" = list("background-color" = "#eee1f0",
                                              "color" = "#900DA4",
                                              "font-weight" = "500"),
    # ".remark-slide table thead th" = list(),
    ".title-slide h1" = list("font-weight" = "500"),
    ".title-slide h2" = list("font-weight" = "400",
                             "font-size" =  "170%"),
    ".title-slide h3" = list("font-family" = "Roboto COndensed",
                             "font-size" = "100%",
                             "font-weight" = "200"),
    ".center2" = list("margin" = "0",
                      "position" = "absolute",
                      "top" = "50%",
                      "left" = "50%",
                      "-ms-transform" = "translate(-50%, -50%)",
                      "transform" = "translate(-50%, -50%)"),
    ".bottom2" = list("margin" = "0",
                      "position" = "absolute",
                      "top" = "90%",
                      "left" = "10%",
                      "-ms-transform" = "translate(-10%, -90%)",
                      "transform" = "translate(-10%, -90%)"),
    ".section-title h1" = list("color" = "#FFFFFF",
                               "font-size" = "2.3em",
                               "line-height" = "1.3"),
    ".medium" = list("font-size" = "1.4em"),
    ".sp-after-half" = list("margin-bottom" = "0.7em !important"),
    ".box-1,.box-1a,.box-1s,.box-1b,.box-1l,.box-1LA,.section-title-1" = list("background-color" = "#0D0887"),
    ".box-2,.box-2a,.box-2s,.box-2b,.box-2l,.box-2LA,.section-title-2" = list("background-color" = "#5601A4"),
    ".box-3,.box-3a,.box-3s,.box-3b,.box-3l,.box-3LA,.section-title-3" = list("background-color" = "#900DA4"),
    ".box-4,.box-4a,.box-4s,.box-4b,.box-4l,.box-4LA,.section-title-4" = list("background-color" = "#BF3984"),
    ".box-5,.box-5a,.box-5s,.box-5b,.box-5l,.box-5LA,.section-title-5" = list("background-color" = "#E16462"),
    ".box-6,.box-6a,.box-6s,.box-6b,.box-6l,.box-6LA,.section-title-6" = list("background-color" = "#F89441"),
    ".box-7,.box-7a,.box-7s,.box-7b,.box-7l,.box-7LA,.section-title-7" = list("background-color" = "#FCCE25"),
    
    ".box-1t,.box-1tL,.section-title-1t" = list("background-color" = "rgba(13, 8, 135,0.3)",
                                                "color"="rgba(13, 8, 135,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    ".box-2t,.box-2tL,.section-title-2t" = list("background-color" = "rgba(86, 1, 164,0.3)",
                                                "color" = "rgba(86, 1, 164,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    ".box-3t,.box-3tL,.section-title-3t" = list("background-color" = "rgba(144, 13, 164,0.3)",
                                                "color" = "rgba(144, 13, 164,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    ".box-4t,.box-4tL,.section-title-4t" = list("background-color" = "rgba(191, 57, 132,0.3)",
                                                "color" = "rgba(191, 57, 132,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    ".box-5t,.box-5tL,.section-title-5t" = list("background-color" = "rgba(225, 100, 98,0.3)",
                                                "color" = "rgba(225, 100, 98,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    ".box-6t,.box-6tL,.section-title-6t" = list("background-color" = "rgba(248, 148, 65,0.3)",
                                                "color" = "rgba(248, 148, 65,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    ".box-7t,.box-7tL,.section-title-7t" = list("background-color" = "rgba(252, 206, 37,0.3)",
                                                "color" = "rgba(252, 206, 37,1)",
                                                "font-family" = "Yanone Kaffeesatz",
                                                "border-radius" = "15px"),
    
    ".box-7t, .box-6t, .box-5t, .box-4t, .box-3t, .box-2t, .box-1t" = list("margin" = "0em auto",
                                                                           "overflow" = "hidden",
                                                                           "padding" = "0.4em 0.4em",
                                                                           "font-weight" = "600",
                                                                           "font-size" = "31px",
                                                                           "display" = "table",
                                                                           "text-align" = "center",
                                                                           "border-radius" = "15px"),
    
    ".box-7tL, .box-6tL, .box-5tL, .box-4tL, .box-3tL, .box-2tL, .box-1tL" = list("margin" = "0em auto",
                                                                                  "overflow" = "hidden",
                                                                                  "padding" = "0.4em 0.4em",
                                                                                  "font-weight" = "600",
                                                                                  "font-size" = "50px",
                                                                                  "display" = "table",
                                                                                  "text-align" = "center",
                                                                                  "border-radius" = "15px"),
    
    ".box-7, .box-6, .box-5, .box-4, .box-3, .box-2, .box-1" = list("color" = "#FFFFFF",
                                                                    "margin" = "0em auto",
                                                                    "overflow" = "hidden",
                                                                    "padding" = "0.4em 0.4em",
                                                                    "font-weight" = "600",
                                                                    "font-size" = "31px",
                                                                    "display" = "table",
                                                                    "text-align" = "center",
                                                                    "font-family" = "Fira Sans",
                                                                    "border-radius" = "15px"),
    ".box-7a, .box-6a, .box-5a, .box-4a, .box-3a, .box-2a, .box-1a" = list("color" = "#FFFFFF",
                                                                           "left" = "0px",
                                                                           "overflow" = "hidden",
                                                                           "padding" = "0.4em 0.4em",
                                                                           "font-weight" = "600",
                                                                           "font-size" = "25px",
                                                                           "display" = "table",
                                                                           "text-align" = "center",
                                                                           "font-family" = "Fira Sans",
                                                                           "border-radius" = "15px"),
    ".box-7s, .box-6s, .box-5s, .box-4s, .box-3s, .box-2s, .box-1s" = list("color" = "#FFFFFF",
                                                                           "left" = "0px",
                                                                           "overflow" = "hidden",
                                                                           "padding" = "0.2em 0.2em",
                                                                           "font-weight" = "400",
                                                                           "font-size" = "100%",
                                                                           "display" = "inline",
                                                                           "text-align" = "center",
                                                                           "font-family" = "Fira Sans",
                                                                           "border-radius" = "15px"),
    ".box-7b, .box-6b, .box-5b, .box-4b, .box-3b, .box-2b, .box-1b" = list("color" = "#FFFFFF",
                                                                           "left" = "0px",
                                                                           "overflow" = "hidden",
                                                                           "padding" = "0.4em 0.4em",
                                                                           "font-weight" = "600",
                                                                           "font-size" = "25px",
                                                                           "display" = "table",
                                                                           "text-align" = "left",
                                                                           "font-family" = "Fira Sans",
                                                                           "border-radius" = "15px"),
    ".box-7l, .box-6l, .box-5l, .box-4l, .box-3l, .box-2l, .box-1l" = list("color" = "#FFFFFF",
                                                                           "margin" = "0em auto",
                                                                           "overflow" = "hidden",
                                                                           "padding" = "0.4em 0.4em",
                                                                           "font-weight" = "600",
                                                                           "font-size" = "45px",
                                                                           "display" = "table",
                                                                           "text-align" = "center",
                                                                           "font-family" = "Yanone Kaffeesatz",
                                                                           "border-radius" = "15px"),
    ".box-7LA, .box-6LA, .box-5LA, .box-4LA, .box-3LA, .box-2LA, .box-1LA" = list("color" = "#FFFFFF",
                                                                                  "margin" = "0em auto",
                                                                                  "overflow" = "hidden",
                                                                                  "padding" = "0.4em 0.4em",
                                                                                  "font-weight" = "600",
                                                                                  "font-size" = "55px",
                                                                                  "display" = "table",
                                                                                  "text-align" = "center",
                                                                                  "font-family" = "Yanone Kaffeesatz",
                                                                                  "border-radius" = "15px"),
    ".image-80 img" = list("scale" = "80%"),
    ".pull-left-little_l" = list("float" = "left",
                                 "width" = "67%"),
    ".pull-right-little_l" = list("float" = "right",
                                  "width" = "27%"),
    ".pull-left-little_r" = list("float" = "left",
                                 "width" = "27%"),
    ".pull-right-little_r" = list("float" = "right",
                                  "width" = "67%")
    
    
  )
)

#,"li" = list("font-size" = "150%")
#    "li" = list("font-size" = "110%"),
#    "ul" = list("font-size" = "110%"),
#color palette
#5601A4
#900DA4
#F89441
#FCCE25

knitr::opts_chunk$set(message = FALSE)

```
```{css, echo = FALSE}

.small .remark-code { /*Change made here*/
    font-size: 80% !important;
}

.tiny .remark-code { /*Change made here*/
    font-size: 90% !important;
}
```

```{r setup2, echo=FALSE, message=FALSE}
library(knitr)
library(showtext)
library(xaringanExtra)

xaringanExtra::use_scribble()

htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i>",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i>",
    error_text = "<i class=\"fa fa-times-circle\" style=\"color: #F94144\"></i>"
  ),
  rmarkdown::html_dependency_font_awesome()
)
```

```{r fonts, message=FALSE, echo=FALSE}
font.add.google("Fira Sans Condensed", "Fira Sans Condensed")
font.add.google("Fira Sans", "Fira Sans")
```

```{r, echo=FALSE, message=FALSE, warning=FALSE}
library(tidyverse)
library(ggplot2)
library(firasans)
library(hrbrthemes)
library(extrafont)
library("RColorBrewer")
library(viridis)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("firasans")
library(hrbrthemes)
library(extrafont)
library(patchwork)
library(scales)
library(glmnet)
library(caret)
library(emo)
library(rvest)
library(ggtext)

options(scipen = 0)
```

# Prediction tasks

- We have seen the main issue with **.darkorange[bias vs variance trade-off]**
  
  - Beyond regression, **.darkorange[what methods can we use for prediction?]**
  --
  
  .box-3[K-nearest neighbor]

---
  # KNN as a classification problem
  
  - Again: Window shoppers vs high rollers

```{r emoji_intro, fig.height=5, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}
data <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week11/1_Shrinkage/data/purchases.csv")

data$id <- seq(1,nrow(data))

set.seed(100)

sample.id1 <- sample(data$id[data$freq>=5],8)
sample.id2 <- sample(data$id[data$freq<5],8)

sample <- data[c(sample.id1, sample.id2),]

sample$freq[sample$spend==117] <- 3
sample$freq[sample$spend==99 & sample$freq==2] <- 5

sample$type <- NA

emoji_to_link <- function(x) {
  paste0("https://emojipedia.org/emoji/",x) %>%
    read_html() %>%
    html_nodes("tr td a") %>%
    .[1] %>%
    html_attr("href") %>%
    paste0("https://emojipedia.org/", .) %>%
    read_html() %>%
    html_node('div[class="vendor-image"] img') %>%
    html_attr("src")
}

link_to_img <- function(x, size = 25) {
  paste0("<img src='", x, "' width='", size, "'/>")
}

# https://emojipedia.org/emoji/

sample$type[sample$freq>5] <- emoji_to_link("????%EF%B8%8F/")

sample$type[sample$freq<=5] <- emoji_to_link("????/")

sample$type[sample$freq==6] <- emoji_to_link("????/")

sample$type[sample$freq==4 & sample$spend<100] <- emoji_to_link("????%EF%B8%8F/")

sample$label <- link_to_img(sample$type)


sample %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))

```


---
  # How would you classify this unit?
  
  ```{r emoji_class1, fig.height=5, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}

sample1 <- sample %>% add_row(freq = 8,
                              female = 0,
                              spend = 48,
                              type = emoji_to_link("???/"),
                              label = link_to_img(emoji_to_link("???/")))

sample1 %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))

```

---
  # How would you classify this unit?
  
  ```{r emoji_class2, fig.height=5, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}

sample1 <- sample %>% add_row(freq = 1,
                              female = 1,
                              spend = 100,
                              type = emoji_to_link("???/"),
                              label = link_to_img(emoji_to_link("???/")))

sample1 %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))

```

---
  # But what about this one?
  
  ```{r emoji_class3, fig.height=5, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}

sample1 <- sample %>% add_row(freq = 6,
                              female = 0,
                              spend = 90,
                              type = emoji_to_link("???/"),
                              label = link_to_img(emoji_to_link("???/")))

sample1 %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))

```

---
  # K-nearest neighbor classifier
  
  - One of the **.darkorange[simplest classifications methods]**
  
  --
  
  Algorithm:
  
  1) Choose a **.darkorange[distance measure]** (e.g. eucledian).

--
  2) Choose a **.darkorange[number of neighbors]**, $N$ (*Note: Choose an odd number!*).

--
  3) **.darkorange[Calculate the distance]** between data and other points.

--
  4) Calculate the **.darkorange[rate for each class]** according to $N$.

--
  5) **.darkorange[Assign the majority class]**.

---
  # KNN with $K=1$
  
  .box-6[Classifier: High-roller]

```{r emoji_knn1, fig.height=4, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}
xc = 6
yc = 90
r=10

sample1 %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  ggplot2::annotate("path",
                    x=xc+r/(15*1.58)*cos(seq(0,2*pi,length.out=100)),
                    y=yc+r*sin(seq(0,2*pi,length.out=100)), color = "dark grey", lwd = 2) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))

```

---
  # KNN with $K=3$
  
  .box-6[Classifier: High-roller]

```{r emoji_knn3, fig.height=5, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}
xc = 6
yc = 90
r=25

sample1 %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  ggplot2::annotate("path",
                    x=xc+r/(15*1.58)*cos(seq(0,2*pi,length.out=100)),
                    y=yc+r*sin(seq(0,2*pi,length.out=100)), color = "dark grey", lwd = 2) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))

```

---
  # KNN with $K=7$
  
  .box-6[Classifier: Window-shopper]

```{r emoji_knn9, fig.height=5, fig.width=7, fig.align='center', dev='svg', echo=FALSE, warning=FALSE}
xc = 6
yc = 90
r=47

sample1 %>%
  ggplot(aes(x = freq, y = spend, label = label)) +
  geom_richtext(aes(y = spend), fill = NA, label.color = NA, # remove background and outline
                label.padding = grid::unit(rep(0, 4), "pt") # remove padding
  ) +
  ggplot2::annotate("path",
                    x=xc+r/(15*1.58)*cos(seq(0,2*pi,length.out=100)),
                    y=yc+r*sin(seq(0,2*pi,length.out=100)), color = "dark grey", lwd = 2) +
  theme_bw()+
  theme_ipsum_fsc() + #plain 
  xlab("Frequency") + ylab("Spending ($)")+
  ylim(0,150) + xlim(0,10) +
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.line = element_line(colour = "dark grey"))+
  theme(axis.title.x = element_text(size=18),#margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = element_text(size=14),
        axis.title.y = element_text(size=18),#margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.text.y = element_text(size=14),legend.position=c(0.9,0.9),
        legend.title = element_text(size = 16),
        legend.text = element_text(size=15),
        legend.background = element_rect(fill="white",colour ="dark grey"),
        title = element_text(size=14))
```