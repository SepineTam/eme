capture program drop batch_csv_to_dta

program define batch_csv_to_dta
    // 参数：文件列表, substr 的起始位置和长度
    args file_list start_pos length

    * 设置数据目录
    local dir "/Users/sepinetam/Documents/Stata/projs/eme/src/xx/"

    * 分隔文件列表
    local nfiles : word count `file_list'

    * 循环处理每个文件
    forval i = 1/`nfiles' {
        // 取出当前文件名
        local file : word `i' of `file_list'
        local csv_file = "`dir'`file'.csv"
        local dta_file = "`dir'`file'.dta"

        // 打印进度
        di as text "Processing `csv_file' -> `dta_file' with substr(`start_pos', `length')..."

        // 导入CSV文件
        import delimited "`csv_file'", clear

        // 数据处理步骤
        gen time = monthly(时间, "MY")
        format time %tm

        // 动态生成 code
        gen code = substr(商品, `start_pos', `length')

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

        // 保存为DTA文件
        save "`dta_file'", replace
    }
    di as text "All files processed successfully!"
end

batch_csv_to_dta "01_ 02_ 03_ 04_ 05_ 06_ 07_ 08_ 09_ 10_" 1 2
