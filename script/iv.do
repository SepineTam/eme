cd /Users/sepinetam/Documents/Stata/projs/eme/src/xx/
use combined.dta, clear

gen datevar = monthly(time, "MY")
drop time
gen time = datevar
format datevar %tm
drop datevar


* keep if code == "01"
scatter lexp lexq
reg ex_p gdp population
reg lexp lgdp lpopu


