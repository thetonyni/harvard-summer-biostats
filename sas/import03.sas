PROC IMPORT OUT= SP.chemical_data 
            DATAFILE= "C:\Users\jsljr\SUMMERPROGRAM2020\Project\Data\che
mical_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
