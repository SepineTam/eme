cd /Users/sepinetam/Documents/Stata/projs/eme/src/xx/
import delimited "./combined.csv", clear

drop v1
save combined.dta, replace
use combined.dta, clear

gen datevar = monthly(time, "MY")
drop time
gen time = datevar
drop datevar
format time %tm

save combined.dta, replace
