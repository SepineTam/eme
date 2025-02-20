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
outreg2 using "../docs/09iv.doc", replace addstat(F-statistic, e(F))
eststo model1

reg limp tea if i0902 == 1
outreg2 using "../docs/09iv.doc", addstat(F-statistic, e(F))
eststo model2

reg limp tea if i0902 == 1 | i0901 == 1
outreg2 using "../docs/09iv.doc", addstat(F-statistic, e(F))
eststo model3

ivregress 2sls limq (limp = tea) if i0901 == 1, first robust
outreg2 using "../docs/09iv.doc"
eststo model1_2sls

* 第一阶段：子样本 i0902 == 1
ivregress 2sls limq (limp = tea) if i0902 == 1, first robust
outreg2 using "../docs/09iv.doc"
eststo model2_2sls

ivregress 2sls limq (limp = tea) if i0902 == 1 | i0901 == 1, first robust
outreg2 using "../docs/09iv.doc"
eststo model3_2sls

esttab model1 model2 model1_2sls model2_2sls using "../tex/09iv.tex", replace booktabs b(3) stats(F p) 
// esttab using "09iv.tex", replace booktabs
esttab model1 model2 model1_2sls model2_2sls, b(3) stats(F p) 

keep if i0901 == 1
reg limp tea
outreg2 using "../docs/09ivB.doc", replace addstat(F-statistic, e(F))
reg limp lgdp
outreg2 using "../docs/09ivB.doc", addstat(F-statistic, e(F))
reg limp lpop
outreg2 using "../docs/09ivB.doc", addstat(F-statistic, e(F))
reg limp rate
outreg2 using "../docs/09ivB.doc", addstat(F-statistic, e(F))


// use 09cn.rdta, clear
// keep if len == 6
// tabstat im_p im_q limp limq tea, ///
//         c(stat) stat(sum mean sd min max n)



