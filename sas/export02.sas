PROC EXPORT DATA= SP.MIDWEST_CONTAMINANT_AVERAGES 
            OUTFILE= "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data\midw
est_contaminant_averages.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
