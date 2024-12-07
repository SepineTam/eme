use trade2.dta, clear

gen double start_2020 = ym(2020, 1)
gen double end_2022 = ym(2022, 12)
gen double start_2023 = ym(2023, 1)

gen byte color_red = (time >= start_2020 & time <= end_2022)
gen byte color_blue = (time < start_2020)
gen byte color_gray = (time >= start_2023)

// keep if code == "06"

twoway (scatter log_EX_P log_EX_Q if color_red, mcolor(red) msymbol(O)) ///
       (scatter log_EX_P log_EX_Q if color_blue, mcolor(blue) msymbol(O)) ///
       (scatter log_EX_P log_EX_Q if color_gray, mcolor(gray) msymbol(O)), ///
       legend(order(1 "2020-2022" 2 "2019及以前" 3 "2023及以后"))

scatter log_EX_P log_EX_Q
