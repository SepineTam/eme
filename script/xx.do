// 两位
cd ~/Documents/Stata/projs/eme/src/xx
log using "../log/xx.log", append
// log using "../log/xx.log", replace
import delimited "./10_.csv", clear

quietly {
	gen time = monthly(时间, "MY")
	format time %tm

	gen code = substr(商品, 1, 2)

	gen IM_PQ = .
	gen EX_PQ = .
	gen IM_Q = .
	gen EX_Q = .

	replace IM_PQ = 数值 if 指标 == "进口金额（美元）"
	replace EX_PQ = 数值 if 指标 == "出口金额（美元）"
	replace IM_Q = 数值 if 指标 == "进口数量（第一数量）"
	replace EX_Q = 数值 if 指标 == "出口数量（第一数量）"

	collapse (sum) IM_PQ EX_PQ IM_Q EX_Q, by(time code)

	gen IM_P = IM_PQ / IM_Q
	gen EX_P = EX_PQ / EX_Q

	replace IM_Q = . if IM_Q == 0
	replace EX_Q = . if EX_Q == 0
	replace IM_PQ = . if IM_PQ == 0
	replace EX_PQ = . if EX_PQ == 0

	gen log_IM_Q = log(IM_Q)
	gen log_IM_P = log(IM_P)
	gen log_EX_Q = log(EX_Q)
	gen log_EX_P = log(EX_P)

	gen year = year(dofm(time))

	* 2019 年数据
	reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2019m12)
	eststo m201901201912

	* 2020 年数据
	reg log_IM_P log_IM_Q if time >= tm(2020m1) & time <= tm(2020m12)
	eststo m202001202012

	* 2021 年数据
	reg log_IM_P log_IM_Q if time >= tm(2021m1) & time <= tm(2021m12)
	eststo m202101202112

	* 2022 年数据
	reg log_IM_P log_IM_Q if time >= tm(2022m1) & time <= tm(2022m12)
	eststo m202201202212

	* 2023 年数据
	reg log_IM_P log_IM_Q if time >= tm(2023m1) & time <= tm(2023m12)
	eststo m202301202312

	* 2019-2022 年数据
	reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2022m12)
	eststo m201901202212

	* 2019-2023 年数据
	reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2023m12)
	eststo m201901202312
}

esttab m201901201912 m202001202012 m202101202112 m202201202212 m202301202312 m201901202212 m201901202312

log close
