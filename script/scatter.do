import delimited "/Users/sepinetam/Documents/Stata/projs/eme/src/dta/0101t.csv", encoding("gbk") clear

gen time = monthly(时间, "MY")
format time %tm

gen IM_PQ = .
gen EX_PQ = .
gen IM_Q = .
gen EX_Q = .

replace IM_PQ = 数值 if 指标 == "进口金额（美元）"
replace EX_PQ = 数值 if 指标 == "出口金额（美元）"
replace IM_Q = 数值 if 指标 == "进口数量（第一数量）"
replace EX_Q = 数值 if 指标 == "出口数量（第一数量）"

collapse (sum) IM_PQ EX_PQ IM_Q EX_Q, by(time)

sort t

gen IM_P = IM_PQ / IM_Q
gen EX_P = EX_PQ / EX_Q

replace IM_Q = . if IM_Q == 0
replace EX_Q = . if EX_Q == 0
replace IM_PQ = . if IM_PQ == 0
replace EX_PQ = . if EX_PQ == 0

gen log_IM_Q = log(IM_Q)
gen log_EX_Q = log(EX_Q)

// scatter IM_P IM_Q
// scatter EX_P EX_Q

// replace EX_P = log(EX_P)
// replace EX_Q = log(EX_Q)

* 保留 2019 和 2020 年的数据
keep if time >= tm(2019m1) & time <= tm(2023m12)
// keep if EX_Q >= 5000000 & EX_Q <= 15000000
// keep if IM_P <= 60
// keep if IM_Q < 600000

* 创建一个标志变量，区分年份
gen year = year(dofm(time))

* 绘制混合散点图，分别为 2019、2020、2021 和 2022 年设定颜色
twoway (scatter EX_P EX_Q if year == 2019, ///
            msymbol(circle) mcolor(blue) ///
            legend(label(1 "2019"))) ///
       (scatter EX_P EX_Q if year == 2020, ///
            msymbol(circle) mcolor(red) ////
            legend(label(2 "2020"))) ///
       (scatter EX_P EX_Q if year == 2021, ///
            msymbol(circle) mcolor(green) ///
            legend(label(3 "2021"))) ///
       (scatter EX_P EX_Q if year == 2022, ///
            msymbol(circle) mcolor(purple) ///
            legend(label(4 "2022"))) ///
	   (scatter EX_P EX_Q if year == 2023, ///
            msymbol(circle) mcolor(black) ///
            legend(label(5 "2023"))), ///
    title("Scatter Plot of EX_P vs EX_Q (2019-2023)") ///
    xlabel(, angle(45)) ylabel(, angle(45)) ///
    xtitle("Export Quantity (EX_Q)") ytitle("Export Price (EX_P)") ///
    legend(order(1 "2019" 2 "2020" 3 "2021" 4 "2022" 5 "2023") cols(5))

	