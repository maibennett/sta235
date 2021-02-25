
******************
*Balance table
******************

cap program drop oregon_balance
program define oregon_balance

	syntax varlist [if] [pw] [,condition(string) table(string) preperiodvars(string) listvars(string)]
	
	gen constant = 1
	local rows: word count `varlist'
	
	matrix define `table'=J(`rows'*2 + 8, 3,.)
	
	******************************************************
	*Balance of list variables and preperiod variables
	******************************************************
	
	local temp "" 
	local row=1
	
	foreach var in `varlist' {
	
	*Control mean
		if regexm("`if'"," ")==1 { 
			
			di "reg `var' `if' & treatment==0 [`weight'`exp']"
			reg `var' `if' & treatment==0 [`weight'`exp']
			
			matrix `table'[`row',1]=_b[_cons]
			matrix `table'[`row'+1, 1]=e(rmse)
			
		} 
		
		else {
			di "reg `var' if treatment==0 [`weight'`exp']"
			reg `var' if treatment==0 [`weight'`exp']
			
			matrix `table'[`row',1]=_b[_cons]
			matrix `table'[`row'+1, 1]=e(rmse)
		}
			
		*Balance
		di "reg `var' treatment nnn* `if' [`weight'`exp'], cluster(household_id)"
		reg `var' treatment nnn* `if' [`weight'`exp'], cluster(household_id)
		
		matrix `table'[`row',2]=_b[treatment]
		matrix `table'[`row'+1,2]=_se[treatment]
		
		matrix postest=r(table)
		*local p_val=postest[4,1]
	
		matrix `table'[`row',3]=postest[4,1]
	
		local temp "`temp' `var' se"
		local row=`row'+2
	
	} // end of list vars loop
			
	local temp "`temp' listvar_f listvar_p prelot_f prelot_p joint_f pval"
	
	matrix rownames `table'=`temp'
	//matrix list `table'

	*
	*************************
		*F-stats for joint test 
			
		local numtest : word count `varlist'

		 *Expanding dataset for stacked regressions
      compress
		expand `numtest'
		bys person_id: gen order = _n
		
		gen outcome = .				

		* Creating variables for stacked regressions

      local i = 0
	  
		foreach var in `varlist' {
		
			local i = `i'+1
			di "`i' `var'"
			replace outcome = `var' if (order == `i')
			gen treatment_`i' = treatment *(order == `i')
			
			local ftest_string "`ftest_string' treatment_`i'"
					di "`ftest_string'"
				
				foreach control of varlist nnnnumhh_li_2 nnnnumhh_li_3 constant { 
						gen X`i'`control' = `control' *(order == `i')
				}
		
				foreach word in `listvars' {
					if "`var'"=="`word'" {
						local listvar_string "`ftest_string' treatment_`i'"
						di "`listvar_string'"
					}
				}
				if regexm("`preperiodvars'"," ")==1 {
					foreach word in `preperiodvars' {
							if "`word'"=="`var'"{
								local prelottery_string "`prelottery_string' treatment_`i'"
								di "`prelottery_string'"
							}		
					}
				} 
		
		}

* Running stacked regressions and f-tests
reg outcome treatment_* X* `if' [`weight'`exp'], cluster(household_id) nocons

local i = 0
foreach var of local varlist { 
	local i = `i'+1
	di "`i' `var'"
	}

	*F-stat balance on list vars
	di "`listvar_string'"
	testparm `listvar_string'
	
	local listvar_fstat= round(r(F),.00001)
	local listvar_pval= round(r(p),.00001)
	
	matrix `table'[`row',3]=`listvar_fstat'
	matrix `table'[`row'+1,3]=`listvar_pval'

	di "`preperiodvars'"
	if regexm("`preperiodvars'"," ") == 1 {
		di "`prelottery_string'"
		testparm `prelottery_string'
		local prelottery_fstat = round(r(F),.00001)
		local prelottery_pval = round(r(p),.00001)
		
		matrix `table'[`row'+2,3]=`prelottery_fstat'
		matrix `table'[`row'+3,3]=`prelottery_pval'
	}
	
	//matrix list `table'
	
testparm treatment_* 

local joint_fstat = round(r(F),.00001) 
local joint_pval = round(r(p),.00001)

* test
assert round(Ftail(r(df), r(df_r), r(F)), .001)==round(r(p),.001)

	matrix `table'[`row'+4,3] = `joint_fstat'
	matrix `table'[`row'+5,3] = `joint_pval'
	
	matrix list `table'

end
