


global logpath "C:\Users\lc932\Downloads\logs"
global outpath "C:\Users\lc932\Downloads\output"
global timestamp = "${S_DATE}_${S_TIME}"
cap log close
global timestamp = subinstr(" $timestamp",":","_",.)
log using "$logpath\out_yr$timestamp.log", replace

set more off


xtreg resultvalue year, fe
predict err, e
predict rs, xb

scatter err rs, title("Turbidity", span) ytitle("Error by Watershed") xtitle("Predictor") scheme(economist) name("pic", replace) mcolor(red) msize(0.2)
	
	
	
xtreg ln_resultvalue year, fe
predict err2, e
predict rs2, xb

scatter err2 rs2, title("ln(Turbidity)", span) ytitle("Error by Watershed") xtitle("Predictor") scheme(economist) name("lnpic", replace) mcolor(red) msize(0.2)



graph combine pic lnpic, name("hetero", replace) 
graph export "C:\Users\lc932\Downloads\output\hetero.png", replace     