
**************
*Table Export
**************

cap program drop oregon_table_export
program define oregon_table_export

	args table 
	
	preserve
		clear
		svmat2 `table', names(col) rnames(rows)
		order rows, first
		export delimited using Output/`table'.csv, replace
	restore
	
end
