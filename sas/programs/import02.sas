PROC IMPORT OUT= SP.illinois 
            DATAFILE= "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data\ill
inois.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
