cd /Users/sepinetam/Documents/Stata/projs/eme/src/09xxxx
// import delimited "09.cn.csv", stringcols(2), clear
import delimited "/Users/sepinetam/Documents/Stata/projs/eme/src/09xxxx/09.cn.csv" stringcols(2) numericcols(19), clear

save 09cn.dta, replace
use 09cn.dta, clear

gen datevar = monthly(time, "MY")
drop time
gen time = datevar
drop datevar
format time %tm

drop if dropped == 1
// drop if missing1 == 1
drop dropped
save 09cn.dta, replace
