clear
set more off
cap log close

global root="/Users/sundemiao/Library/CloudStorage/OneDrive-Personal/本科学习内容/北大/final作业"
global Raw_data="$root/Raw_data"
global Tables="$root/Tables"
global Figures="$root/Figures"
global Working_data="$root/Working_data"
global Logfiles="$root/Logfiles"

global y="rgoodh rdepressym rglobals"
global x="rretired"  //主要解释变量
global z="ifaboveage"
global sc="rAge raedu rmarried rrural2 mi_rrural2 rdrinkl mi_rdrinkl rsmoken mi_rsmoken rsocwk mi_rsocwk rsleepless mi_rsleepless rbcare mi_rbcare hgkcare" //用于描述的其他变量
global co="rAge rAge_square_100 raedu rmarried rrural2 mi_rrural2 i.wave" //用于回归的协变量
global controls = "rAge rAge_square_100 raedu rmarried rrural2"
global channel="rdrinkl mi_rdrinkl rsmoken mi_rsmoken rsocwk mi_rsocwk rsleepless mi_rsleepless rbcare mi_rbcare hgkcare" //渠道变量


/*CHARLS_2013*/
cd "$Raw_data/2013"
use Health_Status_and_Functioning.dta, clear

tab dc003,m
gen r2season=.
replace r2season=1 if dc003==1
replace r2season=0 if dc003==2

tab da049, m
gen r2sleep=da049*60

tab da050, m
gen r2nap=da050

gen r2da049=da049
gen r2da050=da050

gen r2sleep_nap=r2sleep+r2nap
gen r2sleep_h=da049
gen r2nap_b=.
replace r2nap_b=1 if r2nap>0 & r2nap~=.
replace r2nap_b=0 if r2nap==0

su r2da049 r2da050 r2sleep r2sleep_h r2nap r2sleep_nap r2nap_b

keep ID r2season r2da049 r2da050 r2sleep r2sleep_h r2nap r2sleep_nap r2nap_b
sort ID
save "$Working_data/2013_season&sleep.dta",replace
clear


cd "$Raw_data/2013"
use Work_Retirement_and_Pension.dta, clear
gen r2pension=.
replace r2pension=0 if fn002_w2s4==4 | fn001_w2s13==13 | fn006_w2==4 | fn022_w2==4
replace r2pension=1 if fn002_w2s1==1 | fn002_w2s2==2 | fn002_w2s3==3 | fn001_w2s1==1 | fn001_w2s2==2 | fn006_w2==1 | fn006_w2==2 | fn006_w2==3 | fn022_w2==1 | fn022_w2==2 | fn022_w2==3
tab r2pension,m

keep ID r2pension
sort ID
save "$Working_data/2013_pension.dta",replace
clear

/*CHARLS_2015*/
cd "$Raw_data/2015"
use Health_Status_and_Functioning.dta, clear

tab dc003,m
gen r3season=.
replace r3season=1 if dc003==1
replace r3season=0 if dc003==2

tab da049, m
gen r3sleep=da049*60

tab da050, m
gen r3nap=da050

gen r3da049=da049
gen r3da050=da050

gen r3sleep_nap=r3sleep+r3nap
gen r3sleep_h=r3sleep/60
gen r3nap_b=.
replace r3nap_b=1 if r3nap>0 & r3nap~=.
replace r3nap_b=0 if r3nap==0

su r3da049 r3da050 r3sleep r3sleep_h r3nap r3sleep_nap r3nap_b

keep ID r3season r3da049 r3da050 r3sleep r3sleep_h r3nap r3sleep_nap r3nap_b
sort ID
save "$Working_data/2015_season&sleep.dta",replace
clear


cd "$Raw_data/2015"
use Work_Retirement_and_Pension.dta, clear
gen r3pension=.
replace r3pension=0 if fn002_w3==3 | fn006_w2==4 | fn022_w3==2
replace r3pension=1 if fn002_w3==1 | fn002_w3==2 | fn002_w2s1==1 | fn002_w2s2==2 |  fn002_w2s3==3 | fn006_w2==1 | fn006_w2==2 | fn006_w2==3 | fn022_w3==1
tab r3pension,m

keep ID r3pension
sort ID
save "$Working_data/2015_pension.dta",replace
clear

/*CHARLS_2018*/
cd "$Raw_data/2018"
use Cognition.dta, clear

tab dc002_w4,m
gen r4season=.
replace r4season=1 if dc002_w4==1
replace r4season=0 if dc002_w4==5

keep ID r4season
sort ID
save "$Working_data/2018_season.dta",replace

use "$Raw_data/2018/Health_Status_and_Functioning.dta",clear

tab da049, m
gen r4sleep=da049*60

tab da050, m
gen r4nap=da050

gen r4da049=da049
gen r4da050=da050

gen r4sleep_nap=r4sleep+r4nap
gen r4sleep_h=r4sleep/60
gen r4nap_b=.
replace r4nap_b=1 if r4nap>0 & r4nap~=.
replace r4nap_b=0 if r4nap==0

su r4da049 r4da050 r4sleep r4sleep_h r4nap r4sleep_nap r4nap_b

merge 1:1 ID using "$Working_data/2018_season.dta"
drop _merge

keep ID r4season r4da049 r4da050 r4sleep r4sleep_h r4nap r4sleep_nap r4nap_b r4season
sort ID
save "$Working_data/2018_season&sleep.dta",replace
clear

cd "$Raw_data/2018"
use Pension.dta, clear
gen r4pension=.
replace r4pension=0 if fn002_w4==2
replace r4pension=1 if fn002_w4==1
tab r4pension,m

keep ID r4pension
sort ID
save "$Working_data/2018_pension.dta",replace
clear


/*H_CHARLS_D*/
cd $Raw_data
use H_CHARLS_D_Data.dta, clear

*Self-report of health
forvalues i=2/4{
gen r`i'goodh=.
replace r`i'goodh=1 if r`i'shlta==1 | r`i'shlta==2
replace r`i'goodh=0 if r`i'shlta==3 | r`i'shlta==4 | r`i'shlta==5
}

*depression
forvalues i=2/4{
gen r`i'depressym=.
replace r`i'depressym=1 if r`i'cesd10>=10 & r`i'cesd10<=30
replace r`i'depressym=0 if r`i'cesd10>=0 & r`i'cesd10<=9
}

*cognition score
/*tab r`i'tr`i'0
tab r`i'ser7
tab r`i'orient
tab r`i'draw*/

*chronic disease
forvalues i=2/4{
gen r`i'chronic_b=.
replace r`i'chronic_b=1 if r`i'hibpe==1
replace r`i'chronic_b=1 if r`i'diabe==1
replace r`i'chronic_b=1 if r`i'cancre==1
replace r`i'chronic_b=1 if r`i'lunge==1
replace r`i'chronic_b=1 if r`i'hearte==1
replace r`i'chronic_b=1 if r`i'stroke==1
replace r`i'chronic_b=1 if r`i'arthre==1
replace r`i'chronic_b=1 if r`i'dyslipe==1
replace r`i'chronic_b=1 if r`i'livere==1
replace r`i'chronic_b=1 if r`i'kidneye==1
replace r`i'chronic_b=1 if r`i'digeste==1
replace r`i'chronic_b=1 if r`i'asthmae==1
replace r`i'chronic_b=0 if r`i'hibpe==0 & r`i'diabe==0 & r`i'cancre==0 & r`i'lunge==0 & r`i'hearte==0 & r`i'stroke==0 & r`i'arthre==0 & r`i'dyslipe==0 & r`i'livere==0 & r`i'kidneye==0 & r`i'digeste==0 & r`i'asthmae==0
tab r`i'chronic_b,m

gen r`i'chronic_n=r`i'hibpe + r`i'diabe + r`i'cancre + r`i'lunge + r`i'hearte + r`i'stroke + r`i'arthre + r`i'dyslipe + r`i'livere + r`i'kidneye + r`i'digeste + r`i'asthmae
}

*work status
tab r2lbrf_c, m
tab r2retemp, m
tab r2fret_c, m
tab r2retemp r2fret_c

gen r2retage=r2agey-(2013-r2retyr)
gen r3retage=r3agey-(2015-r3retyr)
gen r4retage=r4agey-(2018-r4retyr)

*gender
gen ramale=.
replace ramale=1 if ragender==1
replace ramale=0 if ragender==2

*education
tab raeduc_c,m
gen raedu=.
replace raedu=0 if raeduc_c>=1 & raeduc_c<=7
replace raedu=1 if raeduc_c>=8 & raeduc_c<=10
la de edu 0 "0.High school & below" 1 "1.College & above",replace
la value raedu edu

gen mi_raedu=mi(raeduc_c)
replace raedu=0 if mi_raedu==1


*married
la de married 0 "0.not-married" 1 "1.married",replace

forvalues i=2/4{
tab r`i'mstat, m
gen r`i'married=2
replace r`i'married=1 if r`i'mstat==1 | r`i'mstat==3
replace r`i'married=0 if r`i'mstat>=4 & r`i'mstat<=8
gen mi_r`i'married=mi(r`i'mstat)
replace r`i'married=0 if mi_r`i'married==1
}

*others
forvalues i=2/4{
gen mi_r`i'rural2=mi(r`i'rural2)
replace r`i'rural2=0 if mi_r`i'rural2==1

gen mi_r`i'drinkl=mi(r`i'drinkl)
replace r`i'drinkl=0 if mi_r`i'drinkl==1

gen mi_r`i'smoken=mi(r`i'smoken)
replace r`i'smoken=0 if mi_r`i'smoken==1

gen mi_r`i'vgact_c=mi(r`i'vgact_c)
replace r`i'vgact_c=0 if mi_r`i'vgact_c==1

gen mi_r`i'socwk=mi(r`i'socwk)
replace r`i'socwk=0 if mi_r`i'socwk==1

gen mi_h`i'gkcare=mi(h`i'gkcare)
replace h`i'gkcare=0 if mi_h`i'gkcare==1

gen mi_r`i'work=mi(r`i'work)
replace r`i'work=0 if mi_r`i'work==1
}

sort ID
save "$Working_data/HD.dta", replace

/*merge*/
cd "$Working_data"
use HD.dta, clear
merge 1:1 ID using 2013_season&sleep.dta
drop _merge
merge 1:1 ID using 2015_season&sleep.dta
drop _merge
merge 1:1 ID using 2018_season&sleep.dta
drop _merge
merge 1:1 ID using 2013_pension.dta
drop _merge
merge 1:1 ID using 2015_pension.dta
drop _merge
merge 1:1 ID using 2018_pension.dta
drop _merge


forvalues i=2/4{
gen r`i'retired=.
replace r`i'retired=0 if r`i'fret_c==0
replace r`i'retired=1 if r`i'fret_c==1 | (r`i'lbrf_c==7 & r`i'pension==1)
}
replace r3retired=1 if r2retired==1
replace r4retired=1 if r3retired==1

la de sleep_level 1 "1.7-9h" 2 "2.<7h" 3 "3.>9h"
la de sleep_less 1 "1.<7h" 0 "0.>=7h"


forvalues i=2/4{
gen r`i'epimemo=r`i'tr20/2
gen r`i'intact=r`i'ser7+r`i'orient+r`i'draw+r`i'season
gen r`i'globals=r`i'epimemo+r`i'intact

gen r`i'sleepl=.
replace r`i'sleepl=2 if r`i'sleep_h<7
replace r`i'sleepl=1 if r`i'sleep_h>=7 & r`i'sleep_h<=9
replace r`i'sleepl=3 if r`i'sleep_h>9 & !mi(r`i'sleep_h)
gen mi_r`i'sleepl=mi(r`i'sleepl)
replace r`i'sleepl=0 if mi(r`i'sleepl)==1
la var r`i'sleepl "wave`i' sleep level"
la value r`i'sleepl sleep_level

gen r`i'sleepless=.
replace r`i'sleepless=1 if r`i'sleep_h<7
replace r`i'sleepless=0 if r`i'sleep_h>=7 & !mi(r`i'sleep_h)
gen mi_r`i'sleepless=mi(r`i'sleepless)
replace r`i'sleepless=0 if mi(r`i'sleepless)==1
la var r`i'sleepless "wave`i' night-time sleep less than 7 hours"
la value r`i'sleepless sleep_less


gen r`i'Age=r`i'agey
gen r`i'Age_square=r`i'Age*r`i'Age
gen r`i'Age_square_100=r`i'Age_square/100

egen r`i'age_cut = cut(r`i'Age), at(45,50,55,60,200)
egen r`i'age_group = group(r`i'age_cut)
}

*hgkcare

*bcare
forvalues i=2/4{
gen r`i'bcare=.
replace r`i'bcare=1 if h`i'lvnear==1 | h`i'coresd==1
replace r`i'bcare=0 if h`i'lvnear==0 & h`i'coresd==0
gen mi_r`i'bcare=mi(r`i'bcare)
replace r`i'bcare=0 if mi_r`i'bcare==1
}

*chronic
forvalues i=2/4{
gen mi_r`i'chronic_b=mi(r`i'chronic_b)
replace r`i'chronic_b=0 if mi_r`i'chronic_b==1
}

*dadliv momliv
forvalues i=2/4{
gen  mi_r`i'dadliv = mi(r`i'dadliv)
replace r`i'dadliv = 0 if mi_r`i'dadliv == 1
gen  mi_r`i'momliv = mi(r`i'momliv)
replace r`i'momliv = 0 if mi_r`i'momliv == 1
}

*pension
su r*pension

destring ID, gen(ID_num)
sort ID

save "$Working_data/merge.dta", replace


/*reshape*/
use "$Working_data/merge.dta", clear

keep ID r*work mi_r*work r*retage r*pension mi_r*dadliv mi_r*momliv r*goodh r*depressym r*globals r*retired ramale r*Age raedu mi_raedu r*married mi_r*married r*rural2 mi_r*rural2 r*chronic_b mi_r*chronic_b r*drinkl mi_r*drinkl r*smoken mi_r*smoken r*socwk mi_r*socwk r*sleepless mi_r*sleepless h*gkcare r*bcare mi_r*bcare h*child r*higov r*dadliv r*momliv r*wthh r*wthha r*wtresp r*wtrespb r*cesd10 r*epimemo r*intact r*lbrf_c r*retemp r*fret_c r*Age_square r*Age_square_100
drop r1work r1wthh r1wthha r1wtresp r1wtrespb r1drinkl r1smoken r1higov r1momliv r1fmomliv r1dadliv r1fdadliv r1socwk r1cesd10 r1rural2 h1child h1dchild h2dchild h3dchild h4dchild

drop if r2pension==0 & r3pension==0 & r4pension==0
drop if r2pension==. & r3pension==0 & r4pension==0
drop if r2pension==0 & r3pension==. & r4pension==0
drop if r2pension==0 & r3pension==0 & r4pension==.
drop if r2pension==. & r3pension==. & r4pension==0
drop if r2pension==. & r3pension==0 & r4pension==.
drop if r2pension==0 & r3pension==. & r4pension==.
drop if r2pension==. & r3pension==. & r4pension==.

sort ID
reshape long r@work mi_r@work r@retage r@pension mi_r@dadliv mi_r@momliv r@goodh r@depressym r@globals r@retired r@Age r@married mi_r@married r@rural2 mi_r@rural2 r@chronic_b mi_r@chronic_b r@drinkl mi_r@drinkl r@smoken mi_r@smoken r@socwk mi_r@socwk r@sleepless mi_r@sleepless h@gkcare r@bcare mi_r@bcare h@child r@higov r@dadliv r@momliv r@wthh r@wthha r@wtresp r@wtrespb r@cesd10 r@epimemo r@intact r@retemp r@fret_c r@lbrf_c r@Age_square r@Age_square_100, i(ID) j(wave)
la var wave wave
la de wave 2 "wave2" 3 "wave3" 4 "wave4"
la value wave wave

save "$Working_data/reshape.dta",replace

/*drop observations*/
use "$Working_data/reshape.dta",clear
keep if (rAge>=50 & rAge<=70 & ramale==1)|(rAge>=45 & rAge<=65 & ramale==0)
drop if rretage<45
tab rlbrf_c rpension,m
drop if rlbrf_c==1 | rlbrf_c==2
drop if rlbrf_c==6 | rlbrf_c==8
drop if rretired==.

gen rAgec=.
replace rAgec=rAge-60 if ramale==1
replace rAgec=rAge-55 if ramale==0 & raedu==1
replace rAgec=rAge-50 if ramale==0 & raedu==0

gen ifaboveage=.
replace ifaboveage=1 if rAgec>=0 & !mi(rAgec)
replace ifaboveage=0 if rAgec<0

sort ID wave
order ID wave rpension rretired rlbrf_c rfret_c

egen rage_cut = cut(rAge), at(45,50,55,60,200)
egen rage_group = group(rage_cut)
la de age_group 1 "45-49" 2 "50-54" 3"55-59" 4 "60-65"
la values rage_group age_group

egen rcesd10_cut = cut(rcesd10), at(0,5,10,15,20,25,200)
egen rcesd10_group = group(rcesd10_cut)
la de cesd10_group 1 "0-4" 2 "5-9" 3 "10-14" 4"15-19" 5 "20-24" 6 "25-30"
la values rcesd10_group cesd10_group

la de gender 1 "male" 0 "female",replace
la values ramale gender

gen rnonretired=.
replace rnonretired=1 if rretired==0
replace rnonretired=0 if rretired==1

bys rAgec ramale: egen rretired_ratio_agec=mean(rretired)
bys rAgec ramale: egen rgoodh_ratio_agec=mean(rgoodh)
bys rAgec ramale: egen rdepressym_ratio_agec=mean(rdepressym)

save "$Working_data/sample.dta", replace

/*output*/
cd $Working_data
use sample.dta,clear

su mi_raedu mi_rmarried mi_rrural2 mi_rdrinkl mi_rsmoken mi_rsocwk mi_rsleepless mi_rbcare mi_rchronic_b mi_rdadliv mi_rmomliv
drop mi_raedu mi_rmarried

cd "$Tables/合并数据"

svyset [pw=rwtrespb]
svy: mean $y $x $sc if ramale==1 & rretired==1
estat sd
outreg2 using table_1.xls, replace excel dec(3) ctitle("retirees male")

svyset [pw=rwtrespb]
svy: mean $y $x $sc if ramale==1 & rretired==0
estat sd
outreg2 using table_1.xls, append excel dec(3) ctitle("non-retirees male")

svyset [pw=rwtrespb]
svy: mean $y $x $sc if ramale==0 & rretired==1
estat sd
outreg2 using table_1.xls,  append excel dec(3) ctitle("retirees female")

svyset [pw=rwtrespb]
svy: mean $y $x $sc if ramale==0 & rretired==0
estat sd
outreg2 using table_1.xls,  append excel dec(3) ctitle("non-retirees female")

/*ttest*/
cd $Working_data
use sample.dta,clear

estpost ttest $y $x $sc if ramale==1, by (rnonretired)
esttab . using "$Tables/合并数据/comparison_by_retired.rtf",b(3) se(3) wide starlevels(* 0.1 ** 0.05 *** 0.01) replace

estpost ttest $y $x $sc if ramale==0, by (rnonretired)
esttab . using "$Tables/合并数据/comparison_by_retired.rtf",b(3) se(3) wide starlevels(* 0.1 ** 0.05 *** 0.01) append



cd "$Figures/合并数据"

hist rgoodh, discrete percent addl title("self-reported health") xtitle("") ytitle("percent") width(0.2) color(navy) xlabel(0 "fair, bad, very bad" 1 "god, very good")
graph save "Graph" "Fig_goodh_hist.gph",replace
graph export Fig_goodh_hist.png, as (png) width(5400) height(4000) replace

graph pie, over(rgoodh) sort plabel(_all percent,format("%5.2f") gap(-10) color(white) size(middle)) title("self-reported health") legend(label(1 "good, very good") label(2 "fair, bad, very bad") size(middle))
graph save "Graph" "Fig_goodh_pie.gph",replace
graph export Fig_goodh_pie.png, as (png) width(5400) height(4000) replace

hist rcesd10_group, discrete percent title("CES-D-10") xtitle("CES-D-10") ytitle("percent") color(navy) addl xlabel(1 "0-4" 2 "5-9" 3 "10-14" 4"15-19" 5 "20-24" 6 "25-30") width(0.5)
graph save "Graph" "Fig_cesd10_hist.gph",replace
graph export Fig_cesd10_hist.png, as (png) width(5400) height(4000) replace

graph box rcesd10, over(ramale) title("CES-D-10(group by gender)") ytitle("CES-D-10")
graph save "Graph" "Fig_cesd10_box.gph",replace
graph export Fig_cesd10_box.png, as (png) width(5400) height(4000) replace

hist rdepressym, discrete percent addl title("depression") xtitle("") ytitle("percent") width(0.2) color(navy) xlabel(0 "no depression" 1 "depression")
graph save "Graph" "Fig_depressym_hist.gph",replace
graph export Fig_depressym_hist.png, as (png) width(5400) height(4000) replace

graph pie, over(rdepressym) plabel(_all percent,format("%5.2f") gap(-10) color(white) size(middle)) title("depression") legend(label(1 "no depression") label(2 "depression") size(middle))
graph save "Graph" "Fig_depressym_pie.gph",replace
graph export Fig_depressym_pie.png, as (png) width(5400) height(4000) replace

hist rglobals, percent title("cognition") xtitle("cognition") ytitle("percent") color(navy) width(0.5) normal normopts(lpattern(dash) lwidth(thick) lcolor(red))
graph save "Graph" "Fig_globals_hist.gph",replace
graph export Fig_globals_hist.png, as (png) width(5400) height(4000) replace

graph box rglobals, over(ramale) title("cognition(group by gender)") ytitle("cognition")
graph save "Graph" "Fig_globals_box.gph",replace
graph export Fig_globals_box.png, as (png) width(5400) height(4000) replace

hist rretired, discrete percent addl title("if retired") xtitle("") ytitle("percent") width(0.2) color(navy) xlabel(0 "not-retired" 1 "retired")
graph save "Graph" "Fig_retired_hist.gph",replace
graph export Fig_retired_hist.png, as (png) width(5400) height(4000) replace

graph pie, over(rretired) plabel(_all percent,format("%5.2f") gap(-10) color(white) size(middle)) title("if retired") legend(label(1 "not-retired") label(2 "retired") size(middle))
graph save "Graph" "Fig_retired_pie.gph",replace
graph export Fig_retired_pie.png, as (png) width(5400) height(4000) replace

hist rage_group, discrete percent title("age") xtitle("age") ytitle("percent") color(navy) addl xlabel(1 "45-49" 2 "50-54" 3"55-59" 4 "60-65") width(0.5)
graph save "Graph" "Fig_age_hist.gph",replace
graph export Fig_age_hist.png, as (png) width(5400) height(4000) replace

graph pie, over(rage_group) sort descend plabel(_all percent,format("%5.2f") gap(0) color(white) size(middle)) title("age")
graph save "Graph" "Fig_age_pie.gph",replace
graph export Fig_age_pie.png, as (png) width(5400) height(4000) replace

graph combine Fig_goodh_hist.gph Fig_goodh_pie.gph Fig_cesd10_hist.gph Fig_cesd10_box.gph Fig_depressym_hist.gph Fig_depressym_pie.gph Fig_globals_hist.gph Fig_globals_box.gph Fig_retired_hist.gph Fig_retired_pie.gph Fig_age_hist.gph Fig_age_pie.gph,row(6) altshrink iscale(1.5)
graph display, xsize(15) ysize(20) scheme(s2color)
graph save "Graph" "Fig_y_combine.gph",replace
graph export Fig_combine.pdf, as (pdf) replace

graph combine Fig_goodh_pie.gph Fig_cesd10_hist.gph Fig_depressym_pie.gph Fig_globals_hist.gph Fig_retired_pie.gph Fig_age_pie.gph,row(2) altshrink iscale(1.5)
graph display, xsize(20) ysize(10) scheme(s2color)
graph save "Graph" "Fig_y_combine_2.gph",replace
graph export Fig_combine_2.pdf, as (pdf) replace


rdplot rretired_ratio_agec rAgec if ramale==1,  c(0) graph_options(title("male") legend(off) xtitle("distance to retirement age") ytitle("retired ratio"))
graph save "Graph" "Fig_retiredratio_male.gph",replace
graph export Fig_retiredratio_male.png, as (png) width(5400) height(4000) replace

rdplot rretired_ratio_agec rAgec if ramale==0 & rAgec<=10,  c(0) graph_options(title("female") legend(off) xtitle("distance to retirement age") ytitle("retired ratio"))
graph save "Graph" "Fig_retiredratio_female.gph",replace
graph export Fig_retiredratio_female.png, as (png) width(5400) height(4000) replace

graph combine Fig_retiredratio_male.gph Fig_retiredratio_female.gph,row(1) altshrink iscale(1.5)
graph display, xsize(20) ysize(8) scheme(s2color)
graph save "Graph" "Fig_rdcom_retiredratio.gph",replace
graph export Fig_com_retiredratio.png, as (png) replace

*/

/*iv*/
cd $Working_data
use sample.dta,clear

destring ID,replace
xtset ID wave

cd "$Tables/合并数据"

*first-stage

xtreg rretired ifaboveage $co if ramale==1,fe vce(cl ID)
eststo first1
outreg2 using table_2_iv_first.xls, se cttop(male all) bdec(3) tdec(2) replace

xtreg rretired ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo first2
outreg2 using table_2_iv_first.xls, se cttop(male low edu) bdec(3) tdec(2) append

xtreg rretired ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo first3
outreg2 using table_2_iv_first.xls, se cttop(male high edu) bdec(3) tdec(2) append

xtreg rretired ifaboveage $co if ramale==0,fe vce(cl ID)
eststo first4
outreg2 using table_2_iv_first.xls, se cttop(female all) bdec(3) tdec(2) append

xtreg rretired ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo first5
outreg2 using table_2_iv_first.xls, se cttop(female low edu) bdec(3) tdec(2) append

xtreg rretired ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo first6
outreg2 using table_2_iv_first.xls, se cttop(female high edu) bdec(3) tdec(2) append


*second-stage

cd $Working_data
use sample.dta,clear

destring ID,replace
xtset ID wave

cd "$Tables/合并数据"

xtivreg rgoodh $co (rretired=ifaboveage) if ramale==1, first fe vce(cl ID)
eststo ivp1
outreg2 using table_3_iv_second_by_gender.xls, cttop(male) bdec(3) tdec(2) replace se
xtivreg rdepressym $co (rretired=ifaboveage) if ramale==1, first fe vce(cl ID)
eststo ivp2
outreg2 using table_3_iv_second_by_gender.xls, cttop(male) bdec(3) tdec(2) append se
xtivreg rglobals $co (rretired=ifaboveage) if ramale==1,first fe vce(cl ID)
eststo ivp3
outreg2 using table_3_iv_second_by_gender.xls, cttop(male) bdec(3) tdec(2) append se

xtivreg rgoodh $co (rretired=ifaboveage) if ramale==0, first fe vce(cl ID)
eststo ivp1
outreg2 using table_3_iv_second_by_gender.xls, cttop(female) bdec(3) tdec(2) append se
xtivreg rdepressym $co (rretired=ifaboveage) if ramale==0, first fe vce(cl ID)
eststo ivp2
outreg2 using table_3_iv_second_by_gender.xls, cttop(female) bdec(3) tdec(2) append se
xtivreg rglobals $co (rretired=ifaboveage) if ramale==0,first fe vce(cl ID)
eststo ivp3
outreg2 using table_3_iv_second_by_gender.xls, cttop(female) bdec(3) tdec(2) append se


cd $Working_data
use sample.dta,clear

destring ID,replace
xtset ID wave

cd "$Tables/合并数据"

xtivreg rgoodh $co (rretired=ifaboveage) if ramale==1 & raedu==0, first fe vce(cl ID)
eststo ivp1
outreg2 using table_4_iv_second_by_edu.xls, cttop(male low edu) bdec(3) tdec(2) replace se
xtivreg rdepressym $co (rretired=ifaboveage) if ramale==1 & raedu==0, first fe vce(cl ID)
eststo ivp2
outreg2 using table_4_iv_second_by_edu.xls, cttop(male low edu) bdec(3) tdec(2) append se
xtivreg rglobals $co (rretired=ifaboveage) if ramale==1 & raedu==0,first fe vce(cl ID)
eststo ivp3
outreg2 using table_4_iv_second_by_edu.xls, cttop(male low edu) bdec(3) tdec(2) append se

xtivreg rgoodh $co (rretired=ifaboveage) if ramale==1 & raedu==1, first fe vce(cl ID)
eststo ivp1
outreg2 using table_4_iv_second_by_edu.xls, cttop(male high edu) bdec(3) tdec(2) append se
xtivreg rdepressym $co (rretired=ifaboveage) if ramale==1 & raedu==1, first fe vce(cl ID)
eststo ivp2
outreg2 using table_4_iv_second_by_edu.xls, cttop(male high edu) bdec(3) tdec(2) append se
xtivreg rglobals $co (rretired=ifaboveage) if ramale==1 & raedu==1,first fe vce(cl ID)
eststo ivp3
outreg2 using table_4_iv_second_by_edu.xls, cttop(male high edu) bdec(3) tdec(2) append se


xtivreg rgoodh $co (rretired=ifaboveage) if ramale==0 & raedu==0, first fe vce(cl ID)
eststo ivp1
outreg2 using table_4_iv_second_by_edu.xls, cttop(female low edu) bdec(3) tdec(2) append se
xtivreg rdepressym $co (rretired=ifaboveage) if ramale==0 & raedu==0, first fe vce(cl ID)
eststo ivp2
outreg2 using table_4_iv_second_by_edu.xls, cttop(female low edu) bdec(3) tdec(2) append se
xtivreg rglobals $co (rretired=ifaboveage) if ramale==0 & raedu==0,first fe vce(cl ID)
eststo ivp3
outreg2 using table_4_iv_second_by_edu.xls, cttop(female low edu) bdec(3) tdec(2) append se

xtivreg rgoodh $co (rretired=ifaboveage) if ramale==0 & raedu==1, first fe vce(cl ID)
eststo ivp1
outreg2 using table_4_iv_second_by_edu.xls, cttop(female high edu) bdec(3) tdec(2) append se
xtivreg rdepressym $co (rretired=ifaboveage) if ramale==0 & raedu==1, first fe vce(cl ID)
eststo ivp2
outreg2 using table_4_iv_second_by_edu.xls, cttop(female high edu) bdec(3) tdec(2) append se
xtivreg rglobals $co (rretired=ifaboveage) if ramale==0 & raedu==1,first fe vce(cl ID)
eststo ivp3
outreg2 using table_4_iv_second_by_edu.xls, cttop(female high edu) bdec(3) tdec(2) append se


*medias
cd $Working_data
use sample.dta,clear

cd "$Tables/合并数据"

destring ID,replace
xtset ID wave

xtreg rdrinkl ifaboveage $co if ramale==1,fe vce(cl ID)
eststo reg1
outreg2 using table_5_iv_medias_male.xls, cttop(male) bdec(3) tdec(2) replace se

xtreg rsmoken ifaboveage $co if ramale==1,fe vce(cl ID)
eststo reg2
outreg2 using table_5_iv_medias_male.xls, cttop(male) bdec(3) tdec(2) append se

xtreg rsocwk ifaboveage $co if ramale==1,fe vce(cl ID)
eststo reg3
outreg2 using table_5_iv_medias_male.xls, cttop(male) bdec(3) tdec(2) append se

xtreg rsleepless ifaboveage $co if ramale==1,fe vce(cl ID)
eststo reg4
outreg2 using table_5_iv_medias_male.xls, cttop(male) bdec(3) tdec(2) append se

xtreg rbcare ifaboveage $co if ramale==1,fe vce(cl ID)
eststo reg5
outreg2 using table_5_iv_medias_male.xls, cttop(male) bdec(3) tdec(2) append se

xtreg hgkcare ifaboveage $co if ramale==1,fe vce(cl ID)
eststo reg6
outreg2 using table_5_iv_medias_male.xls, cttop(male) bdec(3) tdec(2) append se



xtreg rdrinkl ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo reg1
outreg2 using table_5_iv_medias_male_low_edu.xls, cttop(male_low_edu) bdec(3) tdec(2) replace se

xtreg rsmoken ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo reg2
outreg2 using table_5_iv_medias_male_low_edu.xls, cttop(male_low_edu) bdec(3) tdec(2) append se

xtreg rsocwk ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo reg3
outreg2 using table_5_iv_medias_male_low_edu.xls, cttop(male_low_edu) bdec(3) tdec(2) append se

xtreg rsleepless ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo reg4
outreg2 using table_5_iv_medias_male_low_edu.xls, cttop(male_low_edu) bdec(3) tdec(2) append se

xtreg rbcare ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo reg5
outreg2 using table_5_iv_medias_male_low_edu.xls, cttop(male_low_edu) bdec(3) tdec(2) append se

xtreg hgkcare ifaboveage $co if ramale==1 & raedu==0,fe vce(cl ID)
eststo reg6
outreg2 using table_5_iv_medias_male_low_edu.xls, cttop(male_low_edu) bdec(3) tdec(2) append se


xtreg rdrinkl ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo reg1
outreg2 using table_5_iv_medias_male_high_edu.xls, cttop(male_high_edu) bdec(3) tdec(2) replace se

xtreg rsmoken ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo reg2
outreg2 using table_5_iv_medias_male_high_edu.xls, cttop(male_high_edu) bdec(3) tdec(2) append se

xtreg rsocwk ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo reg3
outreg2 using table_5_iv_medias_male_high_edu.xls, cttop(male_high_edu) bdec(3) tdec(2) append se

xtreg rsleepless ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo reg4
outreg2 using table_5_iv_medias_male_high_edu.xls, cttop(male_high_edu) bdec(3) tdec(2) append se

xtreg rbcare ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo reg5
outreg2 using table_5_iv_medias_male_high_edu.xls, cttop(male_high_edu) bdec(3) tdec(2) append se

xtreg hgkcare ifaboveage $co if ramale==1 & raedu==1,fe vce(cl ID)
eststo reg6
outreg2 using table_5_iv_medias_male_high_edu.xls, cttop(male_high_edu) bdec(3) tdec(2) append se



xtreg rdrinkl ifaboveage $co if ramale==0,fe vce(cl ID)
eststo reg1
outreg2 using table_5_iv_medias_female.xls, cttop(female) bdec(3) tdec(2) replace se

xtreg rsmoken ifaboveage $co if ramale==0,fe vce(cl ID)
eststo reg2
outreg2 using table_5_iv_medias_female.xls, cttop(female) bdec(3) tdec(2) append se

xtreg rsocwk ifaboveage $co if ramale==0,fe vce(cl ID)
eststo reg3
outreg2 using table_5_iv_medias_female.xls, cttop(female) bdec(3) tdec(2) append se

xtreg rsleepless ifaboveage $co if ramale==0,fe vce(cl ID)
eststo reg4
outreg2 using table_5_iv_medias_female.xls, cttop(female) bdec(3) tdec(2) append se

xtreg rbcare ifaboveage $co if ramale==0,fe vce(cl ID)
eststo reg5
outreg2 using table_5_iv_medias_female.xls, cttop(female) bdec(3) tdec(2) append se

xtreg hgkcare ifaboveage $co if ramale==0,fe vce(cl ID)
eststo reg6
outreg2 using table_5_iv_medias_female.xls, cttop(female) bdec(3) tdec(2) append se



xtreg rdrinkl ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo reg1
outreg2 using table_5_iv_medias_female_low_edu.xls, cttop(female_low_edu) bdec(3) tdec(2) replace se

xtreg rsmoken ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo reg2
outreg2 using table_5_iv_medias_female_low_edu.xls, cttop(female_low_edu) bdec(3) tdec(2) append se

xtreg rsocwk ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo reg3
outreg2 using table_5_iv_medias_female_low_edu.xls, cttop(female_low_edu) bdec(3) tdec(2) append se

xtreg rsleepless ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo reg4
outreg2 using table_5_iv_medias_female_low_edu.xls, cttop(female_low_edu) bdec(3) tdec(2) append se

xtreg rbcare ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo reg5
outreg2 using table_5_iv_medias_female_low_edu.xls, cttop(female_low_edu) bdec(3) tdec(2) append se

xtreg hgkcare ifaboveage $co if ramale==0 & raedu==0,fe vce(cl ID)
eststo reg6
outreg2 using table_5_iv_medias_female_low_edu.xls, cttop(female_low_edu) bdec(3) tdec(2) append se


xtreg rdrinkl ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo reg1
outreg2 using table_5_iv_medias_female_high_edu.xls, cttop(female_high_edu) bdec(3) tdec(2) replace se

xtreg rsmoken ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo reg2
outreg2 using table_5_iv_medias_female_high_edu.xls, cttop(female_high_edu) bdec(3) tdec(2) append se

xtreg rsocwk ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo reg3
outreg2 using table_5_iv_medias_female_high_edu.xls, cttop(female_high_edu) bdec(3) tdec(2) append se

xtreg rsleepless ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo reg4
outreg2 using table_5_iv_medias_female_high_edu.xls, cttop(female_high_edu) bdec(3) tdec(2) append se

xtreg rbcare ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo reg5
outreg2 using table_5_iv_medias_female_high_edu.xls, cttop(female_high_edu) bdec(3) tdec(2) append se

xtreg hgkcare ifaboveage $co if ramale==0 & raedu==1,fe vce(cl ID)
eststo reg6
outreg2 using table_5_iv_medias_female_high_edu.xls, cttop(female_high_edu) bdec(3) tdec(2) append se


*sensitivity

*Panel A: Retired using rwork

cd $Working_data
use sample.dta,clear

*drop if rretired==1 & rwork==1
replace rretired=1 if rwork==0
replace rretired=0 if rwork==1

cd "$Tables/合并数据"

destring ID,replace
xtset ID wave

xtivreg rgoodh $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_A.xls", cttop(male) bdec(3) tdec(2) replace se

xtivreg rdepressym $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_A.xls", cttop(male) bdec(3) tdec(2) append se

xtivreg rglobals $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_A.xls", cttop(male) bdec(3) tdec(2) append se

xtivreg rgoodh $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_A.xls", cttop(female) bdec(3) tdec(2) append se

xtivreg rdepressym $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_A.xls", cttop(female) bdec(3) tdec(2) append se

xtivreg rglobals $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_A.xls", cttop(female) bdec(3) tdec(2) append se


*Panel B: Bandwidth [-9, 9]

cd $Working_data
use sample.dta,clear

drop if ramale==1 & (rAgec<=-9 | rAgec>=9)
drop if ramale==0 & raedu==1 & (rAgec<=-9 | rAgec>=9)
drop if ramale==0 & raedu==0 & (rAgec<=-4 | rAgec>=14)

*keep if rAgec>=-5 & rAgec<=5

cd "$Tables/合并数据"

destring ID,replace
xtset ID wave

xtivreg rgoodh $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_B.xls", cttop(male) bdec(3) tdec(2) replace se

xtivreg rdepressym $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_B.xls", cttop(male) bdec(3) tdec(2) append se

xtivreg rglobals $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_B.xls", cttop(male) bdec(3) tdec(2) append se

xtivreg rgoodh $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_B.xls", cttop(female) bdec(3) tdec(2) append se

xtivreg rdepressym $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_B.xls", cttop(female) bdec(3) tdec(2) append se

xtivreg rglobals $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_B.xls", cttop(female) bdec(3) tdec(2) append se


*Panel C: Dropping retirement with rural Hukou

cd $Working_data
use sample.dta,clear

drop if rrural2==1

cd "$Tables/合并数据"

destring ID,replace
xtset ID wave

xtivreg rgoodh $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_C.xls", cttop(male) bdec(3) tdec(2) replace se

xtivreg rdepressym $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_C.xls", cttop(male) bdec(3) tdec(2) append se

xtivreg rglobals $co (rretired=ifaboveage) if ramale == 1, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_C.xls", cttop(male) bdec(3) tdec(2) append se

xtivreg rgoodh $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_C.xls", cttop(female) bdec(3) tdec(2) append se

xtivreg rdepressym $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_C.xls", cttop(female) bdec(3) tdec(2) append se

xtivreg rglobals $co (rretired=ifaboveage) if ramale == 0, fe vce(cluster ID)
eststo ivregcoa1
outreg2 using "table_6_panel_C.xls", cttop(female) bdec(3) tdec(2) append se
