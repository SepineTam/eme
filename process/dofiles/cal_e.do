cd "/Users/sepinetam/Desktop/Class/经济贸易问题的测算与分析/process/data"
use "dt/4.dta", clear

* 删除所有列均为空的行
gen all_missing = .
foreach var of varlist _all {
    replace all_missing = 0 if !missing(`var')
}
drop if all_missing == .
drop all_missing

gen code_int = real(code)
drop code
gen code = code_int
drop code_int

gen date = monthly(time, "MM-YYYY")  // 把 time 变量转换为月度时间变量
format date %tm  // 设定格式为 Stata 时间变量（月度）

xtset code date

* 生成唯一ID
egen ID = group(year code)
sort year code

* 删除 limp 和 limq 均为缺失值的观测
drop if missing(limp) & missing(limq)

* 计算每个 ID 的观测数量
bysort ID (limq limp): gen obs_count = _N  
drop if obs_count < 2  // 删除少于 2 个观测值的 ID

* 初始化弹性列
gen e_im = .

* 计算每个 ID 的 log-log 回归弹性
levelsof ID, local(ids)

foreach i of local ids {
    quietly reg limp limq if ID == `i'
    quietly replace e_im = _b[limq] if ID == `i'
}

* 生成处理组
gen post = 0
replace post = 1 if year >= 2020
replace post = 2 if year >= 2023

* 计算每年的 e_im 中位数，并生成新列 median_e_im
egen median_e_im = median(e_im), by(year)

* 画图
twoway ///
    (scatter median_e_im year, msize(medium)), ///
	xline(2019, lcolor(red) lpattern(dash)) ///
	xline(2022, lcolor(red) lpattern(dash)) ///
    xlabel(2017(1)2024) ylabel(, grid) xtitle("Year") ytitle("Median Elasticity") title("Yearly Median Elasticity") legend(off)
	
graph export "../figs/elasticity_by_year_median.pdf", as(pdf) name("Graph") replace
graph export "../figs/elasticity_by_year_median.png", replace

* 描述性统计
summarize IM_P IM_Q year gdp e_im


save "out/4e.dta", replace
