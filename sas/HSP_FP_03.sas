DM "log; clear; ";
DM "odsresults; clear; ";

*********************************************************************
*  Assignment:    HSP_FP    
*                                                                    
*  Description:   Harvard Summer Program 2020 Project    
*
*  Name:          Antonella Basso, Jose Lopez, Tony Ni
*
*  Date:          6/18/2020                              
*------------------------------------------------------------------- 
*  Job name:      HSP_FP_03_jsljr.sas
*
*  Purpose:       Create a graphics of contaminant averages for
*                 new_york and illinois data.
*                                         
*  Language:      SAS, VERSION 9.4
*
*  Input:         new_york.sas, illinois.sas
*
*  Output:        RTF file
*                                                                    
********************************************************************;

%LET job=HSP_FP_03;
%LET onyen=jsljr;
%LET outdir=C:\Users\jsljr\SUMMERPROGRAM2020\Project\Output;

OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN ;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME sp "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data";

/*****************************************************************************
                      Obtaining and Visualizing Data Set
*****************************************************************************/

data new_york_avgs;
   set sp.new_york_contaminant_averages;
run;

proc print data=new_york_avgs (obs=10);
run;

data new_york_stats;
   set sp.new_york_stats;
run;

proc print data=new_york_stats (obs=10);
run;

data illinois_avgs;
   set sp.illinois_contaminant_averages;
run;

proc print data=new_york_avgs (obs=10);
run;

data illinois_stats;
   set sp.illinois_stats;
run;

proc print data=illinois_stats (obs=10);
run;

/*****************************************************************************
       Creating HISTOGRAMS for contaminant averages (Chloride - Mercury)
*****************************************************************************/

/***** NEW YORK *****/
title1 "New York: Upgradient Wells (HISTOGRAM) - new_york_avgs";
title2 "Distribution of CHLORIDE amongst all Upgradient Wells";
proc sgplot data=new_york_avgs(where=(gradient="Upgradient"));
   histogram CHLORIDE / scale=count datalabel;
   density CHLORIDE;
run;
title;

/***** ILLINOIS *****/
/* 1 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of CHLORIDE amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram CHLORIDE / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 250 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;

/* 2 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of CHROMIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram CHROMIUM / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 0.1 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;

/* 3 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of COBALT amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram COBALT / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 0.006 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;

/* 4 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of FLUORIDE amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram FLUORIDE / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 4 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;

/* 5 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of LEAD amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram LEAD / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 0.015 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;

/* 6 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of LITHIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram LITHIUM / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 0.04 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;

/* 7 */
title1 "Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of MERCURY amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram MERCURY / fillattrs=(color=black) scale=count datalabel nbins=20;
   refline 0.04 / axis=x lineattrs=(thickness=3 color=darkred);
   xaxis label="Concentration mg/l";
run;
title;


/*****************************************************************************
               Creating a binary health threshold indicator variable
*****************************************************************************/
data illinois_avgs_indicator;
   set illinois_avgs;
   if ANTIMONY>0.006 then ANTIMONY_HBT=1;
   else ANTIMONY_HBT=0;

   if ARSENIC>0.01 then ARSENIC_HBT=1;
   else ARSENIC_HBT=0;

   if BARIUM>2 then BARIUM_HBT=1;
   else BARIUM_HBT=0;

   if BERYLLIU>0.004 then BERYLLIUM_HBT=1;
   else BERYLLIUM_HBT=0;

   if CADMIUM>0.005 then CADMIUM_HBT=1;
   else CADMIUM_HBT=0;

   if CHROMIUM>0.1 then CHROMIUM_HBT=1;
   else CHROMIUM_HBT=0;

   if COBALT>0.006 then COBALT_HBT=1;
   else COBALT_HBT=0;

   if FLUORIDE>4 then FLUORIDE_HBT=1;
   else FLUORIDE_HBT=0;

   if LEAD>0.015 then LEAD_HBT=1;
   else LEAD_HBT=0;

   if LITHIUM>0.040 then LITHIUM_HBT=1;
   else LITHIUM_HBT=0;

   if MERCURY>0.002 then MERCURY_HBT=1;
   else MERCURY_HBT=0;

   if MOLYBDEN>0.040 then MOLYBDENUM_HBT=1;
   else MOLYBDENUM_HBT=0;

   if SELENIUM>0.050 then SELENIUM_HBT=1;
   else SELENIUM_HBT=0;

   if THALLIUM>0.002 then THALLIUM_HBT=1;
   else THALLIUM_HBT=0;

   if RADIUM>5 then RADIUM_HBT=1;
   else RADIUM_HBT=0;

run;

/*****************************************************************************
                    Binary health threshold indicator frequency
*****************************************************************************/

data illinois_avgs_indicator_1;
   set illinois_avgs_indicator;
   if (ANTIMONY_HBT=1) or (ARSENIC_HBT=1) or (BARIUM_HBT=1) or
      (BERYLLIUM_HBT=1) or (CADMIUM_HBT=1) or (CHROMIUM_HBT=1) or
	  (COBALT_HBT=1) or (FLUORIDE_HBT=1) or (LEAD_HBT=1) or 
	  (LITHIUM_HBT=1) or (MERCURY_HBT=1) or (MOLYBDENUM_HBT=1) or 
	  (SELENIUM_HBT=1) or (THALLIUM_HBT=1) or (RADIUM_HBT=1);
run;

*proc print data=illinois_avgs_indicator_reduced(where=(gradient="Upgradient"));
*run;

data illinois_avgs_indicator_2;
   set illinois_avgs_indicator_1;

   SUM_HBT = sum(of ANTIMONY_HBT, ARSENIC_HBT, BARIUM_HBT, BERYLLIUM_HBT, CADMIUM_HBT,
                    CHROMIUM_HBT, COBALT_HBT, FLUORIDE_HBT, LEAD_HBT, LITHIUM_HBT, 
                    MERCURY_HBT, MOLYBDENUM_HBT, SELENIUM_HBT, THALLIUM_HBT, RADIUM_HBT);
run;

data illinois_avgs_indicator_3;
   set illinois_avgs_indicator_2;
   keep well gradient sum_hbt;
run;

proc print data=illinois_avgs_indicator_3(where=(gradient="Upgradient"));
run;

title1 "VBAR Plot of the Frequency of Wells with One, Two, Three, Twelve, and Thirteen Contaminants above the Health Base Threshold";
proc sgplot data=illinois_avgs_indicator_2(where=(gradient="Upgradient"));
   vbar SUM_HBT / group=well datalabel groupdisplay=stack legendlabel="WELL";
   xaxis label="Number of Contaminants Above the Health Base Threshold";
run;
title;

title1 "VBAR Plot of the Frequency of Wells with One, Two, Three, Twelve, and Thirteen Contaminants above the Health Base Threshold";
proc sgplot data=illinois_avgs_indicator_2(where=(gradient="Upgradient"));
   vbar SUM_HBT / datalabel fillattrs=(color=black) legendlabel="WELL";
   xaxis label="Number of Contaminants Above the Health Base Threshold";
run;
title;


