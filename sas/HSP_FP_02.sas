DM "log; clear; ";
DM "odsresults; clear; ";

*********************************************************************
*  Assignment:    HSP_FP    
*                                                                    
*  Description:   Harvard Summer Program 2020 Project    
*
*  Name:          Antonella Basso, Jose Lopez, Tony Ni
*
*  Date:          6/17/2020                              
*------------------------------------------------------------------- 
*  Job name:      HSP_FP_02_jsljr.sas
*
*  Purpose:       Create a data frame of contaminant averages for
*                 illinois data.
*                                         
*  Language:      SAS, VERSION 9.4
*
*  Input:         illinois.sas
*
*  Output:        RTF file
*                                                                    
********************************************************************;

%LET job=HSP_FP_02;
%LET onyen=jsljr;
%LET outdir=C:\Users\jsljr\SUMMERPROGRAM2020\Project\Output;

OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN ;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME sp "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data";

/*****************************************************************************
                      Obtaining and Visualizing Data Set
*****************************************************************************/

data illinois;
   set sp.illinois;
run;

proc print data=illinois (obs=10);
run;

/*****************************************************************************
                        List of Unique Values for Variables
*****************************************************************************/

proc sql noprint;
   
   select distinct contaminant into :contaminant separated by '*'
        from illinois;

   select distinct disposal_area into :disposal_area separated by '*'
        from illinois;

   select distinct well_id into :well_id separated by '*'
        from illinois;

quit;



%put contaminant=&contaminant;

%put disposal=&disposal_area;

%put well=&well_id;

/*****************************************************************************
                      Renaming Variable Values (Contaminants)
*****************************************************************************/

data illinois_1;
   set illinois;

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
   else contaminant2="OTHER";

run;

* visual check that new_york_1 data set looks correct;
proc print data=illinois_1 (obs=10);
run;

* this is used as a check for the variable contaminant2 having the same
  frequency as the original contaminat variable;
proc freq data=illinois_1;
   table contaminant*contaminant2 / list missing;
run;

/*****************************************************************************
                 General Statistics of Contaminant Concentrations
*****************************************************************************/

/*proc sort data=new_york_1 out=new_york_by_contaminant;
   by contaminant;
run;*/

/*title1 "Statistics of Contaminant Concentrations";
proc means data=new_york_by_contaminant mean std min max median;
   by contaminant;
   var concentration;
run;
title;*/

/*proc sort data=new_york_1 out=new_york_by_well;
   by well_id;
run;*/

/*title1 "Statistics of Contaminant Concentrations by Well and Gradient (Individual)";
proc means data=new_york_by_well mean std min max median;
   by well_id;
   var concentration;
   class contaminant gradient;
run;
title;*/

title1 "Statistics of Contanminant Concentrations by Well and Gradient (Together)";
proc means data=illinois_1 mean std min max median stackodsoutput;
   var concentration;
   class well_id contaminant2 gradient;
   ods output summary=sp.illinois_stats;
run;
title;

proc print data=sp.illinois_stats; run;

/*****************************************************************************
                    Restructuring new_york_stats data set
*****************************************************************************/
proc sql noprint;
   
   select distinct contaminant2 into :contaminant2 separated by ' '
        from illinois_1;

quit;

%put contaminant=&contaminant2;

%macro macro1;

%let i=1;
%do %until (%scan(&contaminant2, &i)= );
      %let var = %scan(&contaminant2, &i);

	  proc sql;

	  title1 "Stats for contaminant &var.";
	  create table &var._avgs as
	  select well_id as well, gradient, mean as &var
	  from sp.illinois_stats
	  where contaminant2="&var";
	  title;

	  quit;

	  %let i=%eval(&i+1);


%end;
%mend;

%macro1;

data sp.illinois_contaminant_averages;
   merge ANTIMONY_avgs ARSENIC_avgs BARIUM_avgs BERYLLIU_avgs BORON_avgs CADMIUM_avgs CALCIUM_avgs
         CHLORIDE_avgs CHROMIUM_avgs COBALT_avgs FLUORIDE_avgs LEAD_avgs LITHIUM_avgs MERCURY_avgs
         MOLYBDEN_avgs PH_avgs RADIUM_avgs SELENIUM_avgs SULFATE_avgs TDS_avgs THALLIUM_avgs;
   by well;
run;

proc print data=sp.illinois_contaminant_averages;
run;
