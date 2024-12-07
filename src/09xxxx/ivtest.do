cd /Users/sepinetam/Documents/Stata/projs/eme/src/09xxxx
use 09cn.dta, clear

keep if len == 6
keep if tea

// reg limp limq
//
// reg limp lgdp
// reg limp lfdi
// reg limp lpop
// reg limp rate
//
// reg limp lgdp lfdi


// keep if i0901 == 1

gen lra = log(rate)


reg limp tea if i0901 == 1

eststo model1

reg limp tea if i0902 == 1

eststo model2

ivregress 2sls limq (limp = tea) if i0901 == 1, first robust
eststo model1_2sls

* 第一阶段：子样本 i0902 == 1
ivregress 2sls limq (limp = tea) if i0902 == 1, first robust
eststo model2_2sls


rm ../tex/09iv.tex
esttab model1 model2 model1_2sls model2_2sls using "../tex/09iv.tex", replace booktabs b(3) stats(F p) 
// esttab using "09iv.tex", replace booktabs
esttab model1 model2 model1_2sls model2_2sls, b(3) stats(r2 F p) 


