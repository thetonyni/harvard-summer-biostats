DM "log; clear; ";
DM "odsresults; clear; ";

*********************************************************************
*  Assignment:    HSP_FP    
*                                                                    
*  Description:   Harvard Summer Program 2020 Project    
*
*  Name:          Antonella Basso, Jose Lopez, Tony Ni
*
*  Date:          6/26/2020                              
*------------------------------------------------------------------- 
*  Job name:      HSP_FP_05_jsljr.sas
*
*  Purpose:       Create contaminant data structures that do not
*                 observations above the health based thresholds.
*                                         
*  Language:      SAS, VERSION 9.4
*
*  Input:         illinois_contaminant_averages.sas
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

data illinois_avgs;
   set sp.illinois_contaminant_averages;
run;

proc print data=illinois_avgs (obs=10);
run;

/*****************************************************************************
  Creating separate datasets for contaminanted upgradient wells and upgradient
  wells that are not contaminated
*****************************************************************************/

data IL_AVGS_INDIC_UPGRADIENT;
   set sp.illinois_avgs_indicator;
   SUM_HBT = sum(of ANTIMONY_HBT, ARSENIC_HBT, BARIUM_HBT, BERYLLIUM_HBT, CADMIUM_HBT,
                    CHROMIUM_HBT, COBALT_HBT, FLUORIDE_HBT, LEAD_HBT, LITHIUM_HBT, 
                    MERCURY_HBT, MOLYBDENUM_HBT, SELENIUM_HBT, THALLIUM_HBT, RADIUM_HBT);

   if gradient="Upgradient";
run;

proc print data = IL_AVGS_INDIC_UPGRADIENT;
run;

data sp.IL_AVGS_INDIC_UP_CONT;
   set IL_AVGS_INDIC_UPGRADIENT;
   if SUM_HBT>=1;
run;

title "Illinois: Contaminated Upgradient Wells";
proc print data = IL_AVGS_INDIC_UP_CONT;
run;
title;

data sp.IL_AVGS_INDIC_UP_NCONT;
   set IL_AVGS_INDIC_UPGRADIENT;
   if SUM_HBT=0;
run;

title "Illinois: Non-contaminated Upgradient Wells";
proc print data = IL_AVGS_INDIC_UP_NCONT;
run;
title;

/*****************************************************************************
                 Creating HISTOGRAMS for contaminant averages
*****************************************************************************/
/* 1 */
title1 "1: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of ANTIMONY amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and ANTIMONY<= 0.006));
   histogram ANTIMONY / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.006 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 2 */
title1 "2: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of ARSENIC amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and ARSENIC<= 0.01));
   histogram ARSENIC / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.01 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 3 */
title1 "3: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of BARIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and BARIUM<=2));
   histogram BARIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 2 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 4 */
title1 "4: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of BERYLLIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and BERYLLIU<=0.004));
   histogram BERYLLIU / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.004 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 5 */
title1 "5: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of BORON amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and BORON<=3));
   histogram BORON / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 3 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 6 */
title1 "6: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of CADMIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and CADMIUM<=0.005));
   histogram CADMIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.005 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 7 */
title1 "7: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of CALCIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram CALCIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   *refline 250 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
footnote3 "This is not different from the original histogram";
title;
footnote;

/* 8 */
title1 "8: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of CHLORIDE amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram CHLORIDE / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   *refline 250 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
footnote3 "This is not different from the original histogram";
title;
footnote;

/* 9 */
title1 "9: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of CHROMIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and CHROMIUM<=0.1));
   histogram CHROMIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.1 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 10 */
title1 "10: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of COBALT amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and COBALT<=0.006));
   histogram COBALT / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.006 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 11 */
title1 "11: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of FLUORIDE amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and FLUORIDE<=4));
   histogram FLUORIDE / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 4 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 12 */
title1 "12: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of LEAD amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and LEAD<=0.015));
   histogram LEAD / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.015 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 13 */
title1 "13: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "RevisedDistribution of LITHIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and LITHIUM<=0.04));
   histogram LITHIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.04 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 14 */
title1 "14: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of MERCURY amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and MERCURY<=0.002));
   histogram MERCURY / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.002 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 15 */
title1 "15: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of MOLYBDENUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and MOLYBDEN<=0.04));
   histogram MOLYBDEN / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.04 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 16 */
title1 "16: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of pH amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram PH / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 6.5 9 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 17 */
title1 "17: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of RADIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and RADIUM<=5));
   histogram RADIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 5 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 18 */
title1 "18: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of SELENIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and SELENIUM<=0.04));
   histogram SELENIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.04 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 19 */
title1 "19: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Revised Distribution of SULFATE amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and SULFATE<=500));
   histogram SULFATE / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 500 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;

/* 20 */
title1 "20: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of TDS amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient"));
   histogram TDS / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   *refline 250 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
footnote3 "This is not different from the original histogram";
title;
footnote;

/* 21*/
title1 "21: Illinois: Upgradient Wells (HISTOGRAM) - illinois_avgs";
title2 "Distribution of THALLIUM amongst all Upgradient Wells";
proc sgplot data=illinois_avgs(where=(gradient="Upgradient" and THALLIUM<=0.002));
   histogram THALLIUM / fillattrs=(color=midnightblue) scale=count datalabel nbins=20;
   refline 0.002 / axis=x lineattrs=(thickness=3 color=tan);
   xaxis label="Concentration mg/l";
run;
title;




