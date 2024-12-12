cd /Users/sepinetam/Documents/Stata/projs/eme/src/09xxxx
import delimited "09_edf.csv", stringcols(1) clear

save edf.dta, replace

import delimited "wide.csv", stringcols(1) clear

save wide.dta, replace

import delimited "event.csv", stringcols(1) clear

save event.dta, replace

