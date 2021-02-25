
cap program drop voting_main_analysis
program define voting_main_analysis
	
	syntax varlist [if] [pw] [, controls(string) insurance(string) table(string) fake(string)]
	
	local numvar : word count `varlist'

	matrix define `table'= J(`numvar'*2,6, .)
	
	local temp " " 
	local row=1
	
	foreach var of local varlist {

	if regexm("`if'"," ")==1 { // If an "if" option is specified, the program will do this

    *Sample size
    di "count `if'"
        count `if'
    matrix `table'[`row',1]=r(N)	

	*Control mean
	di "reg `var' `if' & treatment==0 [`weight'`exp']"
		reg `var' `if' & treatment==0 [`weight'`exp']
		
	matrix `table'[`row',2]= _b[_cons]*100
	matrix `table'[`row'+1,2]= e(rmse)*100
	
			} // end regexm loop
		
	else {

    *Sample size
    di "count"
        count
    matrix `table'[`row',1]=r(N)

	*Control mean
	di "reg `var' if treatment==0 [`weight'`exp']"
		reg `var' if treatment==0 [`weight'`exp']
		
	matrix `table'[`row',2]= _b[_cons]*100
	matrix `table'[`row'+1,2]= e(rmse)*100
	
			} 
	
	*ITT
	di "reg `fake'`var' treatment `controls' `if' [`weight'`exp'], cluster(household_id)"
		reg `fake'`var' treatment `controls' `if' [`weight'`exp'], cluster(household_id)
		
	matrix `table'[`row',3]= _b[treatment]*100
	matrix `table'[`row'+1,3]=  _se[treatment]*100

    *First stage
    di "reg `insurance' treatment nnn* `if' [`weight'`exp'], cluster(household_id)"
        reg `insurance' treatment nnn* `if' [`weight'`exp'], cluster(household_id)
    matrix `table'[`row',4]=_b[treatment]
    matrix `table'[`row'+1,4]=_se[treatment]

	*LATE
	di "ivregress 2sls `fake'`var' (`insurance'=treatment) `controls' `if' [`weight'`exp'], cluster(household_id)"
		ivregress 2sls `fake'`var' (`insurance'=treatment) `controls' `if' [`weight'`exp'], cluster(household_id)
	
	matrix `table'[`row',5]= _b[`insurance']*100
	matrix `table'[`row'+1,5]= _se[`insurance']*100
		
    matrix postest=r(table)
    local tot_p = postest[4,1]
    matrix `table'[`row',6]= `tot_p'
		
    local row=`row'+2
    local temp "`temp' `var' "se" "
		
	}

    matrix rownames `table'= `temp'
    matrix colnames `table'= "N" "cmean" "ITT" "FirstStage" "LATE" "p_val"
	
end

