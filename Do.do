log using "Ejercicio 1 STATA para presentar.smcl"
import excel "Base1.xls", sheet("base1") firstrow
save "Base 1.dta"
import delimited "Base2.csv", encoding(ISO-8859-1)clear
save "Base 2.dta"
use "Base 3.dta"
use "Base3.dta"
use "Base 1.dta"
append using "Base 2.dta"
browse
save "Base 1 y 2.dta"
use "Base 1 y 2.dta"
merge 1:1 var1 using "Base3.dta", assert(match) keep(match)
label variable var1 "id number"
rename var1 patientsidentification
label variable var2 "sex"
rename var2 patientsex
label define sex 0 "female" 1 "male"
label variable var3 "chest pain type"
rename var3 chestpaintype
label define chestpaintype 1 "typical angina" 2 "atypical angina" 3 "non-anginal pain" 4 "asymptomatic"
label variable var4 "systolic blood pressure in mmHg"
rename var4 systolicbloodpressure
label variable var5 "serum cholesterol in mg/dl"
rename var5 serumcholesterol
label variable var6 "Resting Electrocardiographic results"
rename var6 restingEKGresults
label define restingEKGresults 0 "normal" 1 "having ST-T wave abnormality" 2 "showing probable or definite left ventricular hypertrophy"
label variable var7 "Date of birth (mm/dd/yyyy)"
rename var7 dateofbirth
label variable var8 "angiographic disease status"
rename var8 diagnosisofheartdisease
label define diagnosisofheartdisease 0 "< 50% diameter narrowing" 1 "> 50% diameter narrowing"
label variable var9 "Coronary angiography date (dd/mm/yyyy)"
rename var9 coronaryangiographydate
codebook systolicbloodpressure,d
browse
browse systolicbloodpressure
destring systolicbloodpressure, generate(systolicbloodpressure2) force
codebook systolicbloodpressure2,d
egen float systolicbloodprescat = cut(systolicbloodpressure2), at( 50 90 130 140 160 180) label
tab systolicbloodprescat
label variable systolicbloodprescat "systolic blood pressure categorized"
notes systolicbloodprescat: 0= hipotension 1=deseada/normal 2= prehipertension 3=hipert g1 4= hipert g2 5= crisis hipertensiva
tabulate systolicbloodprescat, nolabel
destring serumcholesterol, generate (serumcholesterol2) force
browse dateofbirth coronaryangiographydate
gen birthday = date(dateofbirth, "MDY")
gen datangio = date(coronaryangiographydate, "DMY")
browse age datangio
format birthday %td
format datangio %td
browse dateofbirth birthday coronaryangiographydate datangio
gen ageangio= ((datangio-birthday)/365.25)
browse ageangio
browse ageangio birthday datangio
save "Ejercicio 1.dta"
summarize ageangio
histogram ageangio, bin(10) percent normal ytitle(Porcentaje por edad) xtitle(Edad en años) title(Distribución de la edad en años al momento de la angiografía) scheme(s2mono)
graph pie, over(patientsex) plabel(_all name, format(%9.0g)) title(Distribución del sexo en los pacientes) legend(off) scheme(s2mono)
tab patientsex
graph use "Torta Sexo .gph"
tabulate chestpaintype diagnosisofheartdisease, chi2 column row
tab systolicbloodprescat
sum serumcholesterol2
