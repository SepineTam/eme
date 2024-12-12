cd /Users/sepinetam/Documents/Stata/projs/eme/src/09xxxx

use wide.dta, clear


// keep if span == 2

gen gap = atd - btd
gen absgap = abs(gap)
gen absbtd = abs(btd)

gen line_x = btd   // 让line_x与btd一致
gen line_y = line_x // line_y = line_x, 即y=x

twoway (scatter atd btd) (line line_y line_x)

// reg gap absbtd
//
// scatter atd btd
