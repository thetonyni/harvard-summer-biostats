PROC IMPORT OUT= SP.new_york 
            DATAFILE= "C:\Users\jsljr\SUMMERPROGRAM2020\harvard-summer-b
iostats\data\new_york.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
