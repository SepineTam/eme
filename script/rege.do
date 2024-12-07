cd ~/Documents/Stata/projs/eme
// import excel "./src/dta/02xxxx_t.xlsx", clear firstrow
import delimited "./src/dta/03xxxx_us.csv", clear

gen time = monthly(时间, "MY")
format time %tm

gen code = substr(商品, 1, 6)

gen IM_PQ = .
gen EX_PQ = .
gen IM_Q = .
gen EX_Q = .

// replace 数值 = real(数值)
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

// keep if time >= tm(2019m1) & time <= tm(2023m12)
// keep if code == "020120"

quietly {
reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2023m12)
eststo model1
reg log_IM_P log_IM_Q if time >= tm(2019m1) & time <= tm(2019m12)
eststo model2
reg log_IM_P log_IM_Q if time >= tm(2020m1) & time <= tm(2022m12)
eststo model3
reg log_IM_P log_IM_Q if time >= tm(2023m1) & time <= tm(2023m12)
eststo model4
}


esttab model1 model2 model3 model4

// scatter log_IM_P log_IM_Q if time >= tm(2020m1) & time <= tm(2022m12)
quietly {
reg log_EX_P log_EX_Q if time >= tm(2019m1) & time <= tm(2023m12)
eststo model5
reg log_EX_P log_EX_Q if time >= tm(2019m1) & time <= tm(2019m12)
eststo model6
reg log_EX_P log_EX_Q if time >= tm(2020m1) & time <= tm(2022m12)
eststo model7
reg log_EX_P log_EX_Q if time >= tm(2023m1) & time <= tm(2023m12)
eststo model8
}

esttab model5 model6 model7 model8

// esttab model1 model2 model3 model4 model5 model6 model7 model8
