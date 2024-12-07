capture program drop add_gdp_to_dta

program define add_gdp_to_dta
    // 参数：文件列表
    args file_list

    * 设置数据目录
    local dir "/Users/sepinetam/Documents/Stata/projs/eme/src/xx/"

    * 加载 gdp.dta 数据
    use "`dir'gdp.dta", clear
    sort year
    tempfile gdp_temp
    save `gdp_temp'

    * 分隔文件列表
    local nfiles : word count `file_list'

    * 循环处理每个文件
    forval i = 1/`nfiles' {
        // 取出当前文件名
        local file : word `i' of `file_list'
        local dta_file = "`dir'`file'.dta"
        local output_file = "`dir'`file'gdp.dta"

        // 加载目标文件
        use "`dta_file'", clear

        // 确认有 year 列
        if !missing(year) {
            // 合并 gdp 数据
            merge m:1 year using `gdp_temp'

            // 检查合并情况
            if _merge == 1 {
                di as error "Warning: GDP data not matched for some rows in `file'."
            }
            drop _merge

            // 保存新文件
            save "`output_file'", replace
            di as text "Processed `dta_file' -> `output_file' with GDP."
        } 
		else {
            di as error "Error: No 'year' column found in `file'. Skipping..."
        }
    }
end

add_gdp_to_dta "01_ 02_ 03_ 04_ 05_ 06_ 07_ 08_ 09_ 10_"
