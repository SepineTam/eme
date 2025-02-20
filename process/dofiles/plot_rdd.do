cd "/Users/sepinetam/Desktop/Class/经济贸易问题的测算与分析/process/data"
use "out/4e.dta", clear

// * 计算 3-sigma 上下界
// egen mean_e = mean(e_im), by(year)
// egen sd_e = sd(e_im), by(year)
// gen upper = mean_e + 3 * sd_e
// gen lower = mean_e - 3 * sd_e
//
// * 删除超出 3-sigma 范围的离群点
// drop if e_im > upper | e_im < lower

* 按年份计算第25百分位数和第75百分位数
bysort year: egen q1 = pctile(e_im), p(25)
bysort year: egen q3 = pctile(e_im), p(75)

* 计算四分位差 IQR
gen iqr = q3 - q1

* 计算箱线图法下的异常值边界
gen lower = q1 - 1.5 * iqr
gen upper = q3 + 1.5 * iqr

* 删除超出边界的异常值
drop if e_im < lower | e_im > upper

* 绘制箱线图（剔除离群点用）
graph box e_im, over(year) title("Boxplot of Elasticity by Year")
graph export "../figs/box.pdf", as(pdf) replace
graph export "../figs/box.png", replace

* 绘制散点图
twoway ///
    (scatter e_im year, msize(small)) ///
    (lfit e_im year if year >= 2017 & year <= 2019, lpattern(dash) lcolor(blue)) ///
    (lfit e_im year if year >= 2019 & year <= 2022, lpattern(dash) lcolor(green)) ///
    (lfit e_im year if year >= 2022 & year <= 2024, lpattern(dash) lcolor(orange)), ///
    xlabel(2017(1)2024) ylabel(, grid) xtitle("Year") ytitle("Elasticity") ///
    title("Elasticity Scatter Plot with Fitted Trends") legend(off) ///
    xline(2019, lcolor(red) lpattern(dash)) ///
    xline(2022, lcolor(red) lpattern(dash))

* 导出图像
graph export "../figs/elasticity_trend.pdf", as(pdf) replace
graph export "../figs/elasticity_trend.png", replace

* 创建断点指示变量：2019年及以后视为受影响期
gen post2019 = (year >= 2019)
* 2019断点后的"距离"：从2019年开始计算，如果在断点之前则置为0
gen x2019 = year - 2019 if year >= 2019
replace x2019 = 0 if year < 2019

* 创建第二个断点指示变量：2022年及以后视为第二阶段
gen post2022 = (year >= 2022)
* 2022断点后的距离变量
gen x2022 = year - 2022 if year >= 2022
replace x2022 = 0 if year < 2022

regress e_im c.year post2019 x2019 post2022 x2022


reg e_im year
outreg2 using "../docs/reg/rdd.docx", replace
reg e_im year if year <= 2019
outreg2 using "../docs/reg/rdd.docx"
reg e_im year if year >= 2019 & year <= 2022
outreg2 using "../docs/reg/rdd.docx"
reg e_im year if year >= 2022
outreg2 using "../docs/reg/rdd.docx"

outreg2 clear


