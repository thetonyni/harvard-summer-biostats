DM "log; clear; ";
DM "odsresults; clear; ";

*********************************************************************
*  Assignment:    HSP_FP    
*                                                                    
*  Description:   Harvard Summer Program 2020 Project    
*
*  Name:          Antonella Basso, Jose Lopez, Tony Ni
*
*  Date:          6/22/2020                              
*------------------------------------------------------------------- 
*  Job name:      HSP_FP_04_jsljr.sas
*
*  Purpose:       Create a data set of all Midwest states upgradient
*                 and downgradient wells.
*                                         
*  Language:      SAS, VERSION 9.4
*
*  Input:         chemical_data.sas
*
*  Output:        midwest.sas
*                                                                    
********************************************************************;

%LET job=HSP_FP_04;
%LET onyen=jsljr;
%LET outdir=C:\Users\jsljr\SUMMERPROGRAM2020\Project\Output;

OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN ;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME sp "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data";

/*****************************************************************************
                      Obtaining and Visualizing Data Set
*****************************************************************************/

data chemical_data;
   set sp.chemical_data;
run;

proc print data=chemical_data (obs=10);
run;

/*****************************************************************************
                      Subsetting Whole Chemical Dataset
*****************************************************************************/
data sp.midwest;
   set chemical_data;
   keep state site disposal_area type well_id gradient samp_date contaminant measurement_unit concentration;
   if state = "ND" or state = "SD" or state = "NE" or state = "KS" or 
      state = "MN" or state = "IA" or state = "MO" or state = "IL" or 
      state = "WI" or state = "MI" or state = "IN" or state = "OH";
run;

proc print data=sp.midwest (obs=10);
run;

/*****************************************************************************
                      Renaming Variable Values (Contaminants)
*****************************************************************************/

data midwest_1;
   set sp.midwest;
   length contaminant2 $100;
   if contaminant="Antimony, total" then contaminant2="ANTIMONY";
   else if contaminant="Arsenic, total" then contaminant2="ARSENIC";
   else if contaminant="Barium, total" then contaminant2="BARIUM";
   else if contaminant="Beryllium, total" then contaminant2="BERYLLIUM";
   else if contaminant="Boron, total" then contaminant2="BORON";
   else if contaminant="Cadmium, total" then contaminant2="CADMIUM";
   else if contaminant="Calcium, total" then contaminant2="CALCIUM";
   else if contaminant="Chloride" then contaminant2="CHLORIDE";
   else if contaminant="Chromium, total" then contaminant2="CHROMIUM";
   else if contaminant="Cobalt, total" then contaminant2="COBALT";
   else if contaminant="Fluoride" then contaminant2="FLUORIDE";
   else if contaminant="Lead, total" then contaminant2="LEAD";
   else if contaminant="Lithium, total" then contaminant2="LITHIUM";
   else if contaminant="Mercury, total" then contaminant2="MERCURY";
   else if contaminant="Molybdenum, total" then contaminant2="MOLYBDENUM";
   else if contaminant="Radium 226+228" then contaminant2="RADIUM";
   else if contaminant="Selenium, total" then contaminant2="SELENIUM";
   else if contaminant="Sulfate" then contaminant2="SULFATE";
   else if contaminant="Thallium, total" then contaminant2="THALLIUM";
   else if contaminant="Total Dissolved Solids" then contaminant2="TDS";
   else if contaminant="pH" then contaminant2="PH";
   else if contaminant="pH, field" then contaminant2="PH";

   else if contaminant="Magnesium, total" then contaminant2="MAGNESIUM";
   else if contaminant="Potassium, total" then contaminant2="POTASSIUM";
   else if contaminant="Sodium, total" then contaminant2="SODIUM";

   else contaminant2="OTHER";

run;

** checkin to see if 'pH' and 'pH, field" **;
data midwest_ph_check_1;
   set midwest;
   if contaminant="pH";
run;

data midwest_ph_check_2;
   set midwest;
   if contaminant="pH, field";
run;

proc print data=midwest_ph_check_1 (obs=10); run;
proc print data=midwest_ph_check_2 (obs=10); run;

** 'pH' and 'pH, field' are comparable so
   'pH, field' has been added to the subsetting
   statements above.;
*--------------------------------------------;

* visual check that new_york_1 data set looks correct;
proc print data=midwest_1 (obs=10);
run;

* this is used as a check for the variable contaminant2 having the same
  frequency as the original contaminat variable;
proc freq data=midwest_1;
   table contaminant*contaminant2 / list missing;
run;

/*****************************************************************************
             Assuring measuring units are consistent across the states
*****************************************************************************/
proc freq data=midwest_1;
   table measurement_unit / list missing;
run;

*checking the su measurement;
proc print data=midwest(where=(measurement_unit="su") obs=10); run;
*it's attributed to pH;

*checking ug/l measurement;
proc print data=midwest(where=(measurement_unit="ug/l") obs=10); run;

data midwest_2;
   set midwest_1;
   if measurement_unit="ug/l" then concentration=concentration/1000;
   if measurement_unit="ug/l" then measurement_unit="mg/l";
run;

/*****************************************************************************
                 General Statistics of Contaminant Concentrations
*****************************************************************************/
title1 "Statistics of Contaminant Concentrations by Well and Gradient";
proc means data=midwest_2 mean std min max median stackodsoutput;
   var concentration;
   class well_id contaminant2 gradient;
   ods output summary=sp.midwest_stats;
run;
title;

*proc print data=sp.midwest_stats; *run;

/*****************************************************************************
                    Restructuring new_york_stats data set
*****************************************************************************/
proc sql noprint;

   select distinct contaminant2 into :contaminant2 separated by ' '
        from midwest_2;

quit;

%put contaminant=&contaminant2;

%macro macro2;

%let i=1;
%do %until (%scan(&contaminant2, &i)= );
      %let var = %scan(&contaminant2, &i);

	  proc sql;

	  title1 "Stats for contaminant &var.";
	  create table &var._avgs as
	  select well_id as well, gradient, mean as &var
	  from sp.midwest_stats
	  where contaminant2="&var";
	  title;

	  quit;

	  %let i=%eval(&i+1);

%end;
%mend;

%macro2;

data sp.midwest_contaminant_averages;
   merge ANTIMONY_avgs ARSENIC_avgs BARIUM_avgs BERYLLIUM_avgs BORON_avgs CADMIUM_avgs CALCIUM_avgs
         CHLORIDE_avgs CHROMIUM_avgs COBALT_avgs FLUORIDE_avgs LEAD_avgs LITHIUM_avgs MERCURY_avgs
         MOLYBDENUM_avgs PH_avgs RADIUM_avgs SELENIUM_avgs SULFATE_avgs TDS_avgs THALLIUM_avgs MAGNESIUM_avgs
         POTASSIUM_avgs ;
   by well;
run;

proc print data=sp.midwest_contaminant_averages;
run;
