
cap program drop voting_heterogeneity_analysis
program define voting_heterogeneity_analysis 

	syntax varlist [if] [pw], subpops(string) [, controls(string) insurance(string) table(string) fake(string)]

		*Interactions for heterogeneity regressions
    foreach subpop in `subpops' {

		gen treatment_`subpop'=treatment*`subpop'
		gen `insurance'_`subpop'=`insurance'*`subpop'
		gen num2_`subpop'=nnnnumhh_li_2*`subpop'
		gen num3_`subpop'=nnnnumhh_li_3*`subpop'
		
		
		foreach var of local varlist {
			gen `var'_`subpop'=`var'*`subpop'
			} // End of variable loop
					
	    } // End of subpops loop
			

	local numpops : word count `subpops'
	local numvars : word count `varlist'
	matrix define `table'=J((`numpops'*`numvars'*4),6,.)
	local temp " " 
	local row=1
	local i=0

	foreach var of local varlist {
	
	local ++i
	
	foreach subpop in `subpops' {
	
	if regexm("`subpop'", "all")==1 {
	
	    *Sample size
		*Subpop
		di "count if `subpop'==1 "
		    count if `subpop'==1 
		matrix `table'[`row',1]=r(N)

		*Control Mean
		di "reg `var' if treatment==0 & `subpop'==1 [`weight'`exp']"
		    reg `var' if treatment==0 & `subpop'==1 [`weight'`exp']
		matrix `table'[`row',2]=_b[_cons]*100
		matrix `table'[`row'+1,2]=e(rmse)*100

	    *ITT
	    di "reg `fake'`var' treatment `controls' if `subpop'==1 [`weight'`exp'], cluster(household_id)"
		    reg `fake'`var' treatment `controls' if `subpop'==1 [`weight'`exp'], cluster(household_id)
		
    	matrix `table'[`row',3]=_b[treatment]*100
	    matrix `table'[`row'+1,3]=_se[treatment]*100
		
		*First stage
		di "reg `insurance' treatment nnn* if `subpop'==1 [`weight'`exp'], cluster(household_id)"
		    reg `insurance' treatment nnn* if `subpop'==1 [`weight'`exp'], cluster(household_id)
		matrix `table'[`row',4]=_b[treatment]
        matrix `table'[`row'+1,4]=_se[treatment]
		
		*subpop
		di "ivregress 2sls `fake'`var' (`insurance'=treatment) `controls' if `subpop'==1 [`weight'`exp'], cluster(household_id)"
		    ivregress 2sls `fake'`var' (`insurance'=treatment) `controls' if `subpop'==1 [`weight'`exp'], cluster(household_id)

		matrix `table'[`row',5]=_b[`insurance']*100
		matrix `table'[`row'+1, 5]=_se[`insurance']*100
		
		matrix postest=r(table)
		local `i'_late_p = postest[4,1]
		matrix `table'[`row',6]= ``i'_late_p'
		
		local temp "`temp' `subpop'=1 " ""	
		local row=`row'+2
		
	} // End of regem all loop
	
	if regexm("`subpop'", "all")==0 {
	
		*Sample sizes
		
			*Subpop
		di "count if `subpop'==0 "
		count if `subpop'==0
		matrix `table'[`row',1]=r(N)
		
			*Complement
		di "count if `subpop'==1"
		count if `subpop'==1
		matrix `table'[`row'+2,1]=r(N)
				
		forval v=0/1 {

			
			*Control Mean
			di "reg `var' if treatment==0 & `subpop'==`v' [`weight'`exp']"
			    reg `var' if treatment==0 & `subpop'==`v' [`weight'`exp']
			matrix `table'[`row',2]=_b[_cons]*100
			matrix `table'[`row'+1,2]=e(rmse)*100

			*ITT
	        di "reg `fake'`var' treatment `controls' if `subpop'==`v' [`weight'`exp'], cluster(household_id)"
		        reg `fake'`var' treatment `controls' if `subpop'==`v' [`weight'`exp'], cluster(household_id)
        	matrix `table'[`row',3]=_b[treatment]*100
	        matrix `table'[`row'+1,3]= _se[treatment]*100

			*First stage
			di "reg `insurance' treatment nnn* if `subpop'==`v' [`weight'`exp'], cluster(household_id)"
		    	reg `insurance' treatment nnn* if `subpop'==`v' [`weight'`exp'], cluster(household_id)
			matrix `table'[`row',4]=_b[treatment]
            matrix `table'[`row'+1,4]=_se[treatment]
			
			*LATE Coefficient
			di "ivregress 2sls `fake'`var' (`insurance'=treatment) `controls' if `subpop'==`v' [`weight'`exp'], cluster(household_id)"
			    ivregress 2sls `fake'`var' (`insurance'=treatment) `controls' if `subpop'==`v' [`weight'`exp'], cluster(household_id)
			
			matrix `table'[`row',5]= _b[`insurance']*100
			matrix `table'[`row'+1, 5]=_se[`insurance']*100
			matrix postest=r(table)
			local `i'_late_p = postest[4,1]
		
			matrix `table'[`row',6]= ``i'_late_p'

			local row=`row'+2
					
			}

		local temp "`temp' `subpop'=0 " " `subpop'=1 " " "	
			
		} // End of regexm loop
		
		} // end of subpop loop
			
		} // End of var loop
			
		matrix rownames `table'=`temp'
		matrix colnames `table'= "N" "c_mean" "itt" "firststage" "late" "p_val"
		matrix list `table'

    foreach subpop in `subpops' {
        drop treatment_`subpop' `insurance'_`subpop' num2_`subpop' num3_`subpop'
		foreach var of local varlist {
			drop `var'_`subpop'
		}			
	}

	end	

