---
title: "STA 235 - Wrapping up"
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




<style type="text/css">

.small .remark-code { /*Change made here*/
  font-size: 80% !important;
}

.tiny .remark-code { /*Change made here*/
  font-size: 90% !important;
}
</style>







.box-4LA[We have seen a lot of topics this semester]

---

.pull-left[
.box-1[Regression]
]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]
]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]

<br>

.box-3[Randomized Controlled Trials]
]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]

<br>

.box-3[Randomized Controlled Trials]

<br>

.box-4[Observational studies]
]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]

<br>

.box-3[Randomized Controlled Trials]

<br>

.box-4[Observational studies]
]

.pull-right[
.box-5[Model selection]

]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]

<br>

.box-3[Randomized Controlled Trials]

<br>

.box-4[Observational studies]
]

.pull-right[
.box-5[Model selection]

<br>

.box-6[Regularization]
]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]

<br>

.box-3[Randomized Controlled Trials]

<br>

.box-4[Observational studies]
]

.pull-right[
.box-5[Model selection]

<br>

.box-6[Regularization]

<br>

.box-6[Prediction]
]

---

.pull-left[
.box-1[Regression]

<br>

.box-2[Potential Outcomes framework]

<br>

.box-3[Randomized Controlled Trials]

<br>

.box-4[Observational studies]
]

.pull-right[
.box-5[Model selection]

<br>

.box-6[Regularization]

<br>

.box-6[Prediction]

<br>

.box-6t[KNN, Bagging, Boosting, Random Forests,
Decision Trees...]
]

---

.box-2LA[How do we bring everything together?]

---
# Case Study

.pull-left[
**.darkorange[The use of shared bikes]**

- Q1: How to predict demand?

- Q2: How to incentivize use?

]

.pull-right[
.center[
![:scale 100%](https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week14/1_Twitter/images/bikeshare.jpg)]
]

---
# Q1: How to predict demand?

- What type of problem is it?

--

- How would you approach this problem?

--

- What is your outcome variable?

--

- What data would you ask for?

  - Think about granularity (level), time scope, variables, other data sources.


---
# Let's look at the data


```r
bikedc <- read.csv("https://raw.githubusercontent.com/maibennett/sta235/main/exampleSite/content/Classes/Week14/2_Wrapup/data/bikesharedc.csv")

head(bikedc)
```

```
##              datetime season holiday workingday weather temp  atemp humidity
## 1 2011-01-01 00:00:00      1       0          0       1 9.84 14.395       81
## 2 2011-01-01 01:00:00      1       0          0       1 9.02 13.635       80
## 3 2011-01-01 02:00:00      1       0          0       1 9.02 13.635       80
## 4 2011-01-01 03:00:00      1       0          0       1 9.84 14.395       75
## 5 2011-01-01 04:00:00      1       0          0       1 9.84 14.395       75
## 6 2011-01-01 05:00:00      1       0          0       2 9.84 12.880       75
##   windspeed casual registered count
## 1    0.0000      3         13    16
## 2    0.0000      8         32    40
## 3    0.0000      5         27    32
## 4    0.0000      3         10    13
## 5    0.0000      0          1     1
## 6    6.0032      0          1     1
```

---
# Q2: How to incentivize use?

- What type of problem is it?

--

- How would you approach this problem?

--

- What is your outcome variable?

--

- What data would you ask for?

  - Think about granularity (level), time scope, variables, other data sources.
  
---
# Let's look at the data



