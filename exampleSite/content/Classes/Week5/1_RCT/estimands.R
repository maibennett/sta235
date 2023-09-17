 --- 
   # Estimands vs Estimates vs Estimators 
  
   .pull-left-little_r[ 
                               .box-2[Estimand] 
                              
                               .box-2trans[A quantity we want to estimate] 
                               ] 
   .pull-right-little_l[ 
                                .box-7[Estimate] 
                               
                                .box-7trans[The result of an estimation] 
                                ] 
  
   .center[ 
                   .box-4[Estimator] 
                  
                   <span class="box-4trans">A rule for calculating<br>an  
                   estimate based on data</span> 
                   ] 
  
   --- 
   # Estimands vs Estimates vs Estimators 
  
   .pull-left-little_r[ 
                               .box-2[Estimand] 
                              
                               .box-2trans[A quantity we want to estimate] 
                              
                               .box-2trans[E.g.: Causal effect of attending<br>college on income] 
                              
                               .large[ 
                                              $$\tau$$] 
                               ] 
   .pull-right-little_l[ 
                                .box-7[Estimate] 
                               
                                .box-7trans[The result of an estimation] 
                               
                                .box-7trans[E.g.: Result of the difference in <br>means for a given sample *S*] 
                               
                                .large[ 
                                               $$\hat{\tau}$$] 
                                ] 
   .center[ 
                   .box-4[Estimator] 
                  
                   <span class="box-4trans">A rule for calculating<br>an  
                   estimate based on data</span> 
                  
                   .box-4trans[E.g.: Difference in means] 
                  
                   .large[ 
                                  $$\frac{1}{n_1}\sum_{Z=1}Y_i-\frac{1}{n_0}\sum_{Z=0}Y_i$$] 
                   ] 
  
   --- 
   # Estimands vs Estimates vs Estimators 
  
   .center[ 
                   ![:scale 35%](https://github.com/maibennett/sta235/raw/main/exampleSite/content/Classes/Week4/2_PotentialOutcomes/images/estimands.jpg) 
                   ] 
  
   .source[Source: [Deng, 2022](http://onbiostatistics.blogspot.com/2022/04/estimands-estimator-estimate-and.html)] 
   --- 
   # Estimands vs Estimates vs Estimators 
  
   - Some important **.darkorange[estimands]** that we need to keep in mind: 
  
   .box-3trans[Average Treatment Effect (ATE)] 
  
   .box-5trans[Average Treatment Effect on the Treated (ATT)] 
  
   .box-7trans[Conditional Average Treatment Effect (CATE)] 
  
   --- 
   # Estimands vs Estimates vs Estimators 
  
   - Some important **.darkorange[estimands]** that we need to keep in mind: 
  
   .box-3trans[ATE: E.g. Average Treatment Effect for all customers] 
  
   .box-5trans[ATT: E.g. Average Treatment Effect for customers that received the email] 
  
   .box-7trans[CATE: E.g. Average Treatment Effect for customer under 25 years old] 
  
   --- 
   # Estimands vs Estimates vs Estimators 
  
   - Some important **.darkorange[estimands]** that we need to keep in mind: 
  
   .box-3trans[$$ATE = E[Y(1)- Y(0)]$$] 
  
   .box-5trans[$$ATT = E[Y(1)- Y(0)| Z=1]$$] 
  
   .box-7trans[$$CATE = E[Y(1)- Y(0)| X]$$] 