********************************************************************************
* UNICEF Consultancy Assessment
* Purpose of Do File: Population-weighted Coverage of Health Services
* Created by: Meenakshi Alagusundaram
* Created on: July 27, 2025
* Modified by: 
* Modified on:
********************************************************************************

clear all 
set more off 

// Load user-specific settings and global paths
do "$dofiles/user_profile.do"

// Run the main analysis file (all steps in one)
do "$dofiles/run_project.do"

* Completion message
display in green "Project completed. Output saved in $output"

********************************************************************************
*							
*				Part 1: Cleaning & Harmonizing the Datasets              	   *
*						
********************************************************************************

// Health Coverage Indicators from 2018-2022 Dataset

import excel using "$raw/GLOBAL_DATAFLOW_2018-2022_region_wide.xlsx", cellrange(A2) firstrow clear

rename Geographicarea geo_area
rename Indicator indicator 
rename D year_2018
rename E year_2019
rename F year_2020
rename G year_2021
rename H year_2022

drop if inlist(_n, 1, 18, 19, 20, 21, 22, 23, 24, 25)

replace indicator = "ANC4" if indicator == "Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider"
replace indicator = "SBA" if indicator == "Skilled birth attendant - percentage of deliveries attended by skilled health personnel"

// Keeping the most recent estimate for each indicator

gen most_recent = .
replace most_recent = 2022 if year_2022 != "-"
replace most_recent = 2021 if missing(most_recent) & year_2021 != "-"
replace most_recent = 2020 if missing(most_recent) & year_2020 != "-"
replace most_recent = 2019 if missing(most_recent) & year_2019 != "-"
replace most_recent = 2018 if missing(most_recent) & year_2018 != "-"

gen obs_value = ""
replace obs_value = year_2022 if most_recent == 2022
replace obs_value = year_2021 if most_recent == 2021
replace obs_value = year_2020 if most_recent == 2020
replace obs_value = year_2019 if most_recent == 2019
replace obs_value = year_2018 if most_recent == 2018

drop Sex year_* most_recent

save "$cleaned/global_dataflow_cleaned.dta", replace 

// Under-Five Mortality Rate Classification Dataset 

import excel using "$raw/On-track and off-track countries.xlsx", firstrow clear

rename OfficialName country

// Assigning Regions to the countries

gen geo_area = ""

* East Asia and Pacific 
replace geo_area = "East Asia and Pacific" if country == "Australia" | country == "Brunei Darussalam" | country == "Cambodia" | country == "China" | country == "Fiji" | country == "Indonesia" | country == "Japan" | country == "Kiribati" | country == "Lao People's Democratic Republic" | country == "Malaysia" | country == "Micronesia (Federated States of)" | country == "Mongolia" | country == "Myanmar" | country == "New Zealand" | country == "Papua New Guinea" | country == "Philippines" | country == "Republic of Korea" | country == "Samoa" | country == "Singapore" | country == "Solomon Islands" | country == "Thailand" | country == "Timor-Leste" | country == "Tonga" | country == "Tuvalu" | country == "Vanuatu" | country == "Viet Nam" | country == "Cook Islands" | country == "Marshall Islands" | country == "Niue" | country == "Palau" | country == "Democratic People's Republic of Korea" | country == "Nauru"

* Europe and Central Asia
replace geo_area = "Europe and Central Asia" if country == "Albania" | country == "Andorra" | country == "Armenia" | country == "Austria" | country == "Azerbaijan" | country == "Belarus" | country == "Belgium" | country == "Bosnia and Herzegovina" | country == "Bulgaria" | country == "Croatia" | country == "Czechia" | country == "Denmark" | country == "Estonia" | country == "Finland" | country == "France" | country == "Georgia" | country == "Germany" | country == "Greece" | country == "Hungary" | country == "Iceland" | country == "Ireland" | country == "Italy" | country == "Kazakhstan" | country == "Kosovo (UNSCR 1244)" | country == "Kyrgyzstan" | country == "Latvia" | country == "Lithuania" | country == "Luxembourg" | country == "Malta" | country == "Monaco" | country == "Montenegro" | country == "Netherlands (Kingdom of the)" | country == "North Macedonia" | country == "Norway" | country == "Poland" | country == "Portugal" | country == "Republic of Moldova" | country == "Romania" | country == "Russian Federation" | country == "San Marino" | country == "Serbia" | country == "Slovakia" | country == "Slovenia" | country == "Spain" | country == "Sweden" | country == "Switzerland" | country == "Tajikistan" | country == "Turkey" | country == "Turkmenistan" | country == "Ukraine" | country == "United Kingdom" | country == "Uzbekistan" | country == "Türkiye" | country == "Cyprus"

* Latin America and the Caribbean
replace geo_area = "Latin America and the Caribbean" if country == "Antigua and Barbuda" | country == "Argentina" | country == "Bahamas" | country == "Barbados" | country == "Belize" | country == "Bolivia (Plurinational State of)" | country == "Brazil" | country == "Chile" | country == "Colombia" | country == "Costa Rica" | country == "Cuba" | country == "Dominica" | country == "Dominican Republic" | country == "Ecuador" | country == "El Salvador" | country == "Grenada" | country == "Guatemala" | country == "Guyana" | country == "Haiti" | country == "Honduras" | country == "Jamaica" | country == "Mexico" | country == "Nicaragua" | country == "Panama" | country == "Paraguay" | country == "Peru" | country == "Saint Kitts and Nevis" | country == "Saint Lucia" | country == "Saint Vincent and the Grenadines" | country == "Suriname" | country == "Trinidad and Tobago" | country == "Uruguay" | country == "Venezuela (Bolivarian Republic of)" | country == "Montserrat" | country == "Turks and Caicos Islands" | country == "British Virgin Islands" | country == "Anguilla" 

* Middle East and North Africa
replace geo_area = "Middle East and North Africa" if country == "Algeria" | country == "Bahrain" | country == "Djibouti" | country == "Egypt" | country == "Iran (Islamic Republic of)" | country == "Iraq" | country == "Israel" | country == "Jordan" | country == "Kuwait" | country == "Lebanon" | country == "Libya" | country == "Morocco" | country == "Oman" | country == "Qatar" | country == "Saudi Arabia" | country == "State of Palestine" | country == "Syrian Arab Republic" | country == "Tunisia" | country == "United Arab Emirates" | country == "Yemen"

* North America
replace geo_area = "North America" if country == "Canada" | country == "United States"

* South Asia
replace geo_area = "South Asia" if country == "Afghanistan" | country == "Bangladesh" | country == "Bhutan" | country == "India" | country == "Maldives" | country == "Nepal" | country == "Pakistan" | country == "Sri Lanka"

* Sub-Saharan Africa
replace geo_area = "Sub-Saharan Africa" if country == "Angola" | country == "Benin" | country == "Botswana" | country == "Burkina Faso" | country == "Burundi" | country == "Cabo Verde" | country == "Cameroon" | country == "Central African Republic" | country == "Chad" | country == "Comoros" | country == "Congo" | country == "Côte d'Ivoire" | country == "Democratic Republic of the Congo" | country == "Equatorial Guinea" | country == "Eritrea" | country == "Eswatini" | country == "Ethiopia" | country == "Gabon" | country == "Gambia" | country == "Ghana" | country == "Guinea" | country == "Guinea-Bissau" | country == "Kenya" | country == "Lesotho" | country == "Liberia" | country == "Madagascar" | country == "Malawi" | country == "Mali" | country == "Mauritania" | country == "Mauritius" | country == "Mozambique" | country == "Namibia" | country == "Niger" | country == "Nigeria" | country == "Rwanda" | country == "Sao Tome and Principe" | country == "Senegal" | country == "Seychelles" | country == "Sierra Leone" | country == "Somalia" | country == "South Africa" | country == "South Sudan" | country == "Sudan" | country == "Togo" | country == "Uganda" | country == "United Republic of Tanzania" | country == "Zambia" | country == "Zimbabwe"

merge m:m geo_area using "$cleaned/global_dataflow_cleaned.dta" 

keep if _merge == 3
drop _merge 

save "$cleaned/global_dataflow_classification.dta", replace

// UN World Population Prospects 2022 Dataset  

import excel using "$raw/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", ///
    sheet("Projections") cellrange(A17) firstrow clear

keep Regionsubregioncountryorar ISO3Alphacode Year Birthsthousands

rename Regionsubregioncountryorar country 
rename ISO3Alphacode ISO3Code
rename Year year
rename Birthsthousands births_thousands

keep if year == 2022
drop year

gen geo_area = ""

* East Asia and Pacific 
replace geo_area = "East Asia and Pacific" if country == "Australia" | country == "Brunei Darussalam" | country == "Cambodia" | country == "China" | country == "Fiji" | country == "Indonesia" | country == "Japan" | country == "Kiribati" | country == "Lao People's Democratic Republic" | country == "Malaysia" | country == "Micronesia (Federated States of)" | country == "Mongolia" | country == "Myanmar" | country == "New Zealand" | country == "Papua New Guinea" | country == "Philippines" | country == "Republic of Korea" | country == "Samoa" | country == "Singapore" | country == "Solomon Islands" | country == "Thailand" | country == "Timor-Leste" | country == "Tonga" | country == "Tuvalu" | country == "Vanuatu" | country == "Viet Nam" | country == "Cook Islands" | country == "Marshall Islands" | country == "Niue" | country == "Palau" | country == "Democratic People's Republic of Korea" | country == "Nauru"

* Europe and Central Asia
replace geo_area = "Europe and Central Asia" if country == "Albania" | country == "Andorra" | country == "Armenia" | country == "Austria" | country == "Azerbaijan" | country == "Belarus" | country == "Belgium" | country == "Bosnia and Herzegovina" | country == "Bulgaria" | country == "Croatia" | country == "Czechia" | country == "Denmark" | country == "Estonia" | country == "Finland" | country == "France" | country == "Georgia" | country == "Germany" | country == "Greece" | country == "Hungary" | country == "Iceland" | country == "Ireland" | country == "Italy" | country == "Kazakhstan" | country == "Kosovo (UNSCR 1244)" | country == "Kyrgyzstan" | country == "Latvia" | country == "Lithuania" | country == "Luxembourg" | country == "Malta" | country == "Monaco" | country == "Montenegro" | country == "Netherlands (Kingdom of the)" | country == "North Macedonia" | country == "Norway" | country == "Poland" | country == "Portugal" | country == "Republic of Moldova" | country == "Romania" | country == "Russian Federation" | country == "San Marino" | country == "Serbia" | country == "Slovakia" | country == "Slovenia" | country == "Spain" | country == "Sweden" | country == "Switzerland" | country == "Tajikistan" | country == "Turkey" | country == "Turkmenistan" | country == "Ukraine" | country == "United Kingdom" | country == "Uzbekistan" | country == "Türkiye" | country == "Cyprus"

* Latin America and the Caribbean
replace geo_area = "Latin America and the Caribbean" if country == "Antigua and Barbuda" | country == "Argentina" | country == "Bahamas" | country == "Barbados" | country == "Belize" | country == "Bolivia (Plurinational State of)" | country == "Brazil" | country == "Chile" | country == "Colombia" | country == "Costa Rica" | country == "Cuba" | country == "Dominica" | country == "Dominican Republic" | country == "Ecuador" | country == "El Salvador" | country == "Grenada" | country == "Guatemala" | country == "Guyana" | country == "Haiti" | country == "Honduras" | country == "Jamaica" | country == "Mexico" | country == "Nicaragua" | country == "Panama" | country == "Paraguay" | country == "Peru" | country == "Saint Kitts and Nevis" | country == "Saint Lucia" | country == "Saint Vincent and the Grenadines" | country == "Suriname" | country == "Trinidad and Tobago" | country == "Uruguay" | country == "Venezuela (Bolivarian Republic of)" | country == "Montserrat" | country == "Turks and Caicos Islands" | country == "British Virgin Islands" | country == "Anguilla" 

* Middle East and North Africa
replace geo_area = "Middle East and North Africa" if country == "Algeria" | country == "Bahrain" | country == "Djibouti" | country == "Egypt" | country == "Iran (Islamic Republic of)" | country == "Iraq" | country == "Israel" | country == "Jordan" | country == "Kuwait" | country == "Lebanon" | country == "Libya" | country == "Morocco" | country == "Oman" | country == "Qatar" | country == "Saudi Arabia" | country == "State of Palestine" | country == "Syrian Arab Republic" | country == "Tunisia" | country == "United Arab Emirates" | country == "Yemen"

* North America
replace geo_area = "North America" if country == "Canada" | country == "United States"

* South Asia
replace geo_area = "South Asia" if country == "Afghanistan" | country == "Bangladesh" | country == "Bhutan" | country == "India" | country == "Maldives" | country == "Nepal" | country == "Pakistan" | country == "Sri Lanka"

* Sub-Saharan Africa
replace geo_area = "Sub-Saharan Africa" if country == "Angola" | country == "Benin" | country == "Botswana" | country == "Burkina Faso" | country == "Burundi" | country == "Cabo Verde" | country == "Cameroon" | country == "Central African Republic" | country == "Chad" | country == "Comoros" | country == "Congo" | country == "Côte d'Ivoire" | country == "Democratic Republic of the Congo" | country == "Equatorial Guinea" | country == "Eritrea" | country == "Eswatini" | country == "Ethiopia" | country == "Gabon" | country == "Gambia" | country == "Ghana" | country == "Guinea" | country == "Guinea-Bissau" | country == "Kenya" | country == "Lesotho" | country == "Liberia" | country == "Madagascar" | country == "Malawi" | country == "Mali" | country == "Mauritania" | country == "Mauritius" | country == "Mozambique" | country == "Namibia" | country == "Niger" | country == "Nigeria" | country == "Rwanda" | country == "Sao Tome and Principe" | country == "Senegal" | country == "Seychelles" | country == "Sierra Leone" | country == "Somalia" | country == "South Africa" | country == "South Sudan" | country == "Sudan" | country == "Togo" | country == "Uganda" | country == "United Republic of Tanzania" | country == "Zambia" | country == "Zimbabwe"

replace births_thousands = "" if births_thousands == "..."
destring births_thousands, replace
collapse (sum) births_thousands, by(geo_area)

merge 1:m geo_area using "$cleaned/global_dataflow_classification.dta"

keep if _merge == 3
drop _merge

save "$cleaned/global_dataflow_classification_projections_long.dta", replace

********************************************************************************
*							
*			 Part 2: Calculating Population-Weighted Averages              	   *
*						
********************************************************************************

replace StatusU5MR = "On-track" if StatusU5MR == "Achieved" | StatusU5MR == "On Track"
replace StatusU5MR = "Off-track" if StatusU5MR == "Acceleration Needed"

reshape wide obs_value, i(StatusU5MR births_thousands) j(indicator) string

destring obs_valueANC4, replace
destring obs_valueSBA, replace
destring births_thousands, replace

gen anc4_weighted = obs_valueANC4 * births_thousands
gen sba_weighted  = obs_valueSBA  * births_thousands

reg anc4_weighted check, cluster(StatusU5MR) // Add standard error of the mean 

collapse (sum) anc4_weighted sba_weighted births_thousands, by(StatusU5MR)

gen pw_ANC4 = anc4_weighted / births_thousands
gen pw_SBA  = sba_weighted  / births_thousands

save "$cleaned/global_popweighted_averages_wide.dta", replace 

********************************************************************************
*							
*			 			Part 3: Data Visualization              	   		   *
*						
********************************************************************************

graph bar pw_ANC4 pw_SBA, over(StatusU5MR, label(angle(45))) ///
    blabel(bar, format(%9.1f)) ///
    bargap(30) ///
    bar(1, color(gray)) bar(2, color(maroon)) ///
    title("Population-Weighted Coverage of Health Services", size(medium) style(bold)) ///
    subtitle("By Under-Five Mortality Classification", size(small) style(italic)) ///
    legend(label(1 "ANC4") label(2 "SBA")) ///
    ylabel(, angle(0))

graph export "$output/popweightedavg_graph.png", replace

********************************************************************************
*							
*			 			Part 3: Generating the Report              	   		   *
*						
********************************************************************************

putpdf clear
putpdf begin, font("Times New Roman", 9) pagesize(A4)

// Adding the title
putpdf paragraph, font("Times New Roman", 14) halign(center)
putpdf text ("Population-Weighted Coverage of Health Services"), bold linebreak 

putpdf paragraph, font("Times New Roman", 12) halign(center)
putpdf text ("Test for Consultancy with the D&A Education Team"), bold linebreak
putpdf text ("Generated on: `c(current_date)'") 
putpdf text (""), linebreak

putpdf paragraph, font("Times New Roman", 12) halign(left)
putpdf text ("The following analysis shows the population-weighted coverages of two healthcare service variables: "), linebreak
putpdf text ("• Antenatal care (ANC4) which depicts the percentage of women (aged 15–49) with at least 4 antenatal care visits"), linebreak 
putpdf text ("• Skilled birth attendance (SBA) which shows the percentage of deliveries attended by skilled health workers"), linebreak

putpdf paragraph, font("Times New Roman", 12) halign(left)
putpdf text ("The dataset includes 151 countries with information on ANC4, SBA or both indicators from 2018 to 2022. Countries are also grouped according to the under-five mortality (U5MR) classification which depicts how well they are progressing towards reducing the mortality rates of children under five years of age. Based on the U5MR status for the year 2022, the countries are classified as: "), linebreak
putpdf text ("• On-track: countries that have already met their U5MR target or are progressing at a sufficient pace"), linebreak 
putpdf text ("• Off-track: countries where progress is insufficient and accelerated action is needed to meet the target"), linebreak 

putpdf image "$output/popweightedavg_graph.png", width(5)

putpdf paragraph, font("Times New Roman", 12) halign(left)
putpdf text ("Within each group, we calculate the population-weighted averages for ANC4 and SBA using projected births in 2022 as weights, which allows us to give more weight to observations from larger populations, resulting in more accurate estimates. As shown in the above graph, the  coverage of antenatal care (ANC4) averages 52.5 % for off-track countries and 56.7 % for on-track countries, resulting in a 4.2 percentage point difference. Alternatively, the gap is more pronounced for the skilled birth attendance (SBA) indicator with on-track countries averaging 77.4 % and off-track countries averaging 65.9 %, which shows a 11.5 percentage point difference between the two groups. This graph suggests that on-track countries generally have better maternal health coverage, especially for skilled birth attendance. Antenatal care services might be more evenly distributed across both on-track and off-track countries.") 

putpdf save "$output/unicef_consultancy_analysis.pdf", replace








