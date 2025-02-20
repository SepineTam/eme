cd /Users/sepinetam/Documents/Stata/projs/eme/src/09xxxx
use 09cn.dta, clear

keep if len == 6
keep if tea

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

* 先生成每个code的唯一ID
gen code_ID = code

* 计算每个 ID 的 IV 回归弹性（工具变量 lgdp）
gen e_im_iv = .

levelsof code_ID, local(code_ids)

foreach i of local code_ids {
    quietly count if code_ID == `i' & !missing(lgdp) & !missing(limq) & !missing(limp)
    if r(N) > 2 {
        quietly ivregress 2sls limp (limq = lgdp) year if code_ID == `i'
        quietly replace e_im_iv = _b[limq] if code_ID == `i'
    }
}

gen e_im_ave = .
foreach i of local code_ids {
	quietly reg limp limq if code_ID == `i'
	quietly replace e_im_ave = _b[limq] if code_ID == `i'
}

bysort code: keep if _n == 1


* 4. 导出为 Excel 文件
export excel using "../docs/elasticity_results.xlsx", firstrow(varlabels) replace
