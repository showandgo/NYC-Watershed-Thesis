global outpath "C:\Users\lc932\Downloads\output"
global timestamp = "${S_DATE}_${S_TIME}"
cap log close
global timestamp = subinstr(" $timestamp",":","_",.)
log using "$logpath\out_yr$timestamp.log", replace

set more off

*** Correct pre_fad to b4 1993 ***
drop pre_fad
gen pre_fad = 1 if year <=1993
replace pre_fad = 0 if year >1993

*** Change labels for var ***
label var qty_final "Turbidity"
label var year "Year"
label var fed_green "Fed Green"
label var fed_grey "Fed Grey"
label var loc_green "Local Green"
label var loc_grey "Local Grey"

label var dev_cover "Developed"
label var semi_cover "Semi-developed"
label var prod_cover "Production"

label var pre_cwa "pre-1972"
label var pre_fad "pre-1993"


ssc install estout

*** Controls; funding; landuse***
global fund_cont fed_green fed_grey loc_green loc_grey
global lu_cont dev_cover semi_cover prod_cover

eststo clear

*** Regress with year ***
eststo: quietly xtreg qty_final year, fe

*** Regress with funding ***
eststo: quietly xtreg qty_final year $fund_cont $lu_cont, fe
eststo: quietly xtreg qty_final year $fund_cont dev_cover semi_cover, fe
eststo: quietly xtreg qty_final year $fund_cont prod_cover, fe

*** Regress with funding & pre-72***
eststo: quietly xtreg qty_final year $fund_cont $lu_cont pre_cwa, fe
eststo: quietly xtreg qty_final year $fund_cont dev_cover semi_cover pre_cwa, fe
eststo: quietly xtreg qty_final year $fund_cont prod_cover pre_cwa, fe

*** Regress with funding & pre-93***
eststo: quietly xtreg qty_final year $fund_cont $lu_cont pre_fad, fe


esttab using "$outpath\turbid_lu_w.tex", se r2 noconstant star(* 0.10 ** 0.05 *** 0.01) label replace booktabs title(Turbidity NTU \label{tab 1})

*** Regress with funding only for WOH ***
xtreg qty_final $fund_cont, fe



***  Regress with funding & LU without production ***


***  Regress with funding & production LU only ***


*** Visualise Correlation funding and land-use ***
pwcorr fed_green fed_grey loc_green loc_grey dev_cover semi_cover prod_cover

*** Takes the output from pwcorr and creates the corresponding matrices ***
matpwcorr fed_green fed_grey loc_green loc_grey dev_cover semi_cover prod_cover lowuse_cover
mat list corr 

mat rownames corr = FGreen FGrey LGrey LGreen Dev Semi Prod LowU
mat colnames corr = FGreen FGrey LGrey LGreen Dev Semi Prod LowU
 
plotmatrix, mat(corr) lower nodiag ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) legend(size(small))

*** Output Correlation Table in Latex***
corrtex fed_green fed_grey loc_green loc_grey dev_cover semi_cover prod_cover, file(corr_fund_lu)