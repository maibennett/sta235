
cap program drop oregon_var_sum
program define oregon_var_sum

syntax varlist [if] [in] [aw], stat_list(string) table(string)


	di "sum `varlist' `if' `in', det "
	sum `varlist' `if' `in' , det

	local rows: word count `varlist'
	local columns: word count `stat_list'

	matrix define `table'=J(`rows', `columns',.)
	local col=1
	local row=1
	local temp " " 
	
foreach var in `varlist' {

	foreach stat in `stat_list' { 
		matrix `table'[`row',`col'] = `stat'
		local col=`col'+1
	}
	
	local row=`row'+1
	local col=1
	local temp= "`temp' `var' " 
	
	}
	
	matrix rownames `table' = `temp'
	
end
