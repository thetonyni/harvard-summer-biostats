PROC EXPORT DATA= SP.IL_AVGS_INDIC_UP_CONT 
            OUTFILE= "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data\illi
nois_up_contaminated.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
