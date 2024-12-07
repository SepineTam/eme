cd /Users/sepinetam/Documents/Stata/projs/eme/src/xx

use 04_gdp.dta, clear

// * 2019 年数据
// reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2019m12)
// eststo m201901201912
//
// * 2020 年数据
// reg log_IM_P log_IM_Q if time >= tm(2020m1) & time <= tm(2020m12)
// eststo m202001202012
//
// * 2021 年数据
// reg log_IM_P log_IM_Q if time >= tm(2021m1) & time <= tm(2021m12)
// eststo m202101202112
//
// * 2022 年数据
// reg log_IM_P log_IM_Q if time >= tm(2022m1) & time <= tm(2022m12)
// eststo m202201202212
//
// * 2023 年数据
// reg log_IM_P log_IM_Q if time >= tm(2023m1) & time <= tm(2023m12)
// eststo m202301202312
//
// * 2019-2022 年数据
// reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2022m12)
// eststo m201901202212
//
// * 2019-2023 年数据
// reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2023m12)
// eststo m201901202312
gen log_IV = log(gdp)

gen im = .
gen ex = .

gen im_std = .
gen ex_std = . 

reg log_IM_P log_IV
local beta_im_value = _b[log_IV]
local beta_im_std = _se[log_IV]

reg log_EX_P log_IV
local beta_ex_value = _b[log_IV]
local beta_ex_std = _se[log_IV]

file open myfile using eee.txt, write append
file write myfile `"20192023, 01 ' `=string(_b[log_IV], "%10.4f")' ' `=string(_se[log_IV], "%10.4f")' \n"'
file close myfile


