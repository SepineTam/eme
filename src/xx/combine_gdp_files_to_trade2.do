capture program drop combine_gdp_files_to_trade2

program define combine_gdp_files_to_trade2
    args file_list

    * 设置数据目录
    local dir "/Users/sepinetam/Documents/Stata/projs/eme/src/xx/"

    * 初始化空数据集
    clear
    gen time = .  // 添加占位符列
    gen code = "" // 添加占位符列
    gen dummy = 1 // 虚拟变量，确保初始数据集非空
    tempfile combined_temp
    save `combined_temp', replace

    * 分隔文件列表
    local nfiles : word count `file_list'

    * 循环处理每个文件
    forval i = 1/`nfiles' {
        // 获取当前文件名
        local file : word `i' of `file_list'
        local dta_file = "`dir'`file'_gdp.dta"

        // 检查文件是否存在
        capture confirm file `dta_file'
        if _rc {
            di as error "File `dta_file' not found. Skipping..."
            continue
        }

        // 加载当前文件
        use "`dta_file'", clear
        
        // 确保包含 time 和 code
        if missing(time) | missing(code) {
            di as error "File `dta_file' missing time or code. Skipping..."
            continue
        }

        // 删除虚拟变量
        capture drop dummy

        // 追加数据
        append using `combined_temp'
        save `combined_temp', replace
        di as text "Appended `dta_file' successfully."
    }

    * 保存最终结果为 trade2.dta
    use `combined_temp', clear
    capture drop dummy  // 删除虚拟变量
    save "`dir'trade2.dta", replace
    di as text "All files combined into trade2.dta successfully!"
end

combine_gdp_files_to_trade2 "01 02 03 04 05 06 07 08 09 10"
