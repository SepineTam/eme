cd "/Users/sepinetam/Documents/Stata/projs/eme"

import delimited "./src/dta/01f4_processed.csv", clear

* 筛选国家为美国的数据
// gen is_us = 国家 == "美国"

* 筛选 goods_code = 209 的数据
keep if is_us == 1 & goods_code == 209

* 创建 export_volume 变量，假设 XQ 代表出口量
gen export_volume = .
replace export_volume = 数值 if XQ == 1

* 删除 export_volume 中为空的数据
drop if missing(export_volume)

* 绘制散点图，横轴为出口量，纵轴为时间索引
scatter export_volume time_index, title("Export Volume vs Time Index") ///
    xlabel(, format(%ty)) ylabel(, angle(horizontal)) ///
    xtitle("Export Volume") ytitle("Time Index")
