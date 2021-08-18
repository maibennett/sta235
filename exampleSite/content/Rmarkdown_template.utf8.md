---
title: "RMarkdown Template" # You can put the title of your document here
author: 
  - Nina West  # You can include names here
  - Trixie Mattel
  - Chi Chi Devayne
date: "August 16th, 2021"
output: 
  pdf_document: 
    latex_engine: xelatex  # More modern PDF typesetting engine
    fig_width: 5
    fig_height: 4
    fig_caption: true # If you want to include captions for your figures (usually you do)
    toc: no #Do you want a Table of Contents?
header-includes:
   - \usepackage{float} #This is just a useful LaTeX package for positioning tables and figures
urlcolor: blue #This is so links are highlighted (and more visible)
mainfont: Roboto # Change the font (this is not necessary, you can eliminate this option if you're having compiling issues)
---


<!-- Usually, you should load all your packages at the beginning. If you don't have a package installed, you'll need to do that first! -->


# RMarkdown is awesome

It make take a bit more time, but the flexibility that Rmarkdown gives you (and the aesthetics **\*chef's kiss\***) is unbeatable. This file is meant to act as a template and it includes some basic comments (both here and in the accompanying .css file, if you want to go to the HTML dark side), so it can be easily customized. 

Don't despair! You might start like this:

![Dog is knitting angrily](./Rmarkdown/images/knits2.png){width=3in}


But you will end up like this^[Note how we are changing the size of these figures (you can use different measures!)]:

![Cool beans!](./Rmarkdown/images/cool_beans.jpeg){width=40%}

You can see the knitted version (PDF) of this file [here](https://www.magdalenabennett.com/files/Rmarkdown_template.pdf)

# Let's see some examples

## How does \LaTeX work in RMarkdown?

Well, it works pretty much the same as \LaTeX on its own (if you are familiar with it). Include inline equations like: $y_i = \beta_0 + \beta_1\cdot x_i + \varepsilon_i$, or equations on their own line:

$$y_i = \beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2} + \beta_3 x_{i3} + \beta_4 x_{i4} + ... + \varepsilon_{i}$$

In this case `\beta` basically compiles as $\beta$, and the underscore creates a subindex, just like this: $\beta_0$. How can we do a superscript? Easy! `\theta^{ATE}`, which knits as $\theta^{ATE}$ (Note: Why do we use curly braces for this superscript? Try out what happens when you don't use those braces...)

The previous equation looks good, but sometimes they are too long to be included in one line. What to do? use `\\` to break lines within an equation. At the same time, you might want lines to be aligned at the equal sign. Here is how you do that:

$$\begin{aligned}
y_i =& \beta_0 + \beta_1 x_{i1} + \beta_2 x_{i2} + \beta_3 x_{i3} +\\
    &\beta_4 x_{i4} + ... + \varepsilon_{i}
\end{aligned}$$

(Note: Notice that the `&` sign denotes how the lines should be aligned).

---

## Let's code

We can write some simple code, if we want to show it (*Tip: Include `message=FALSE` and `warning=FALSE` so you don't get that extra stuff when you run the code*):


```r
data(cars)

lm(speed ~ dist, data = cars)
```

```
## 
## Call:
## lm(formula = speed ~ dist, data = cars)
## 
## Coefficients:
## (Intercept)         dist  
##      8.2839       0.1656
```

Meh, but that output looks ugly. Can we make it prettier? Let's try `stargazer` (you will need to include the `results='asis'` argument).


\begin{table}[H] \centering 
  \caption{Regression of Speed on Distance} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
 & \multicolumn{1}{c}{Dependent Variable: Speed} \\ 
\cline{2-2} 
\\[-1.8ex] &  \\ 
 & Model 1 \\ 
\hline \\[-1.8ex] 
 dist & 0.166$^{***}$ \\ 
  & (0.017) \\ 
  & \\ 
 Constant & 8.284$^{***}$ \\ 
  & (0.874) \\ 
  & \\ 
\hline \\[-1.8ex] 
Observations & 50 \\ 
R$^{2}$ & 0.651 \\ 
Adjusted R$^{2}$ & 0.644 \\ 
Residual Std. Error & 3.156 (df = 48) \\ 
F Statistic & 89.567$^{***}$ (df = 1; 48) \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{1}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table} 

You can also compare more than one model:


\begin{table}[H] \centering 
  \caption{Two Regressions of Speed on Distance} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lcc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
 & \multicolumn{2}{c}{Dependent Variable: Speed} \\ 
\cline{2-3} 
\\[-1.8ex] & \multicolumn{2}{c}{} \\ 
 & Model 1 & Model 2 \\ 
\\[-1.8ex] & (1) & (2)\\ 
\hline \\[-1.8ex] 
 distance & 0.166$^{***}$ & 0.327$^{***}$ \\ 
  & (0.017) & (0.055) \\ 
  & & \\ 
 distance$^2$ &  & $-$0.002$^{***}$ \\ 
  &  & (0.0005) \\ 
  & & \\ 
 Constant & 8.284$^{***}$ & 5.144$^{***}$ \\ 
  & (0.874) & (1.295) \\ 
  & & \\ 
\hline \\[-1.8ex] 
Observations & 50 & 50 \\ 
R$^{2}$ & 0.651 & 0.710 \\ 
Adjusted R$^{2}$ & 0.644 & 0.698 \\ 
Residual Std. Error & 3.156 (df = 48) & 2.907 (df = 47) \\ 
F Statistic & 89.567$^{***}$ (df = 1; 48) & 57.573$^{***}$ (df = 2; 47) \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{2}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table} 

---

# Let's plot

Finally, let's briefly look into plots. Play around with this syntax to customize it however you want!


\begin{figure}[H]

{\centering \includegraphics[width=0.7\linewidth]{Rmarkdown_template_files/figure-latex/speed1-1} 

}

\caption{This is my first plot}\label{fig:speed1}
\end{figure}

... and for Andrew Baker's sake, we can also rotate the y-axis label (remember to rename your code chunk!)

\begin{figure}[H]

{\centering \includegraphics{Rmarkdown_template_files/figure-latex/speed2-1} 

}

\caption{This is my second plot}\label{fig:speed2}
\end{figure}

---

# Come to the dark [HTML] side...

If you want to see how this would look as HTML, just change your YAML (i.e. the header of this document, between --- and ---) for the following:

```
---
title: "RMarkdown Template" # You can put the title of your document here
author: 
  - Nina West  # You can include names here
  - Trixie Mattel
  - Chi Chi Devayne
date: "August 16th, 2021"
output: 
  html_document:
    css: style.css 
    toc: no
---
```

I've included a separate [R markdown file](https://raw.githubusercontent.com/maibennett/website_github/master/exampleSite/content/files/Rmarkdown_template.Rmd) with this^[Note that if you want to use CSS styles, you'll need to include the [style.css](https://raw.githubusercontent.com/maibennett/website_github/master/exampleSite/content/files/style.css) file in the same directory as your .Rmd file], that you can knit and see how the HTML file looks. I've also uploaded it [here](https://www.magdalenabennett.com/files/Rmarkdown_template.html) just for fun.

If you want to share your HTML files, a super quick way is [Grant McDermottt's](https://twitter.com/grant_mcdermott) suggestion using Github:

![Twitter is great](./Rmarkdown/images/host_html.png){width=50%}
