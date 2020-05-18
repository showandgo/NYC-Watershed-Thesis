


global logpath "C:\Users\lc932\Downloads\logs"
global outpath "C:\Users\lc932\Downloads\output"
global timestamp = "${S_DATE}_${S_TIME}"
cap log close
global timestamp = subinstr(" $timestamp",":","_",.)
log using "$logpath\out_yr$timestamp.log", replace

set more off

label variable ln_resultvalue "ln(Turbidity)"

xtreg ln_resultvalue year, fe

predict xhatu, xbu

scatter ln_resultvalue year, title("Annual Trend (Fixed Effects)", span size(8pt)) ytitle("Turbidity") xtitle("Year") scheme(economist) name("pic", replace) mcolor(red) msize(0.2) || lfit xhatu year

graph export "C:\Users\lc932\Downloads\output\turbid_yr.png", replace     