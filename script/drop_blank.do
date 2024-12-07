* 删除所有列均为空的行
gen all_missing = .
foreach var of varlist _all {
    replace all_missing = 0 if !missing(`var')
}
drop if all_missing == .
drop all_missing
