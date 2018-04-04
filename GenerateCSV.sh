#!/bin/bash

if [ $# -eq 2 ]; then
    LIMIT=40  # to generate 40KB file
    for((i=0;i<$2;i++))
    {
        FILE_NAME="$1$i.csv"
        echo "id,date,start time,end time,distance,amount,no of persons,longitude,latitude" >> "$FILE_NAME"
        while [ $(du -k $FILE_NAME | cut -f 1) -le $LIMIT ]
        do
            start_time=`date -d "$(date +%H:%M:%S) + $(shuf -i 0-24 -n 1) hours $(shuf -i 0-60 -n 1) minutes $(shuf -i 0-60 -n 1) seconds" +'%H:%M:%S'`
            echo "`shuf -i 1-10 -n 1`,`date -d "2011-01-01 + $(shuf -i 1-2557 -n 1) days" +'%m-%d-%Y'`,$start_time,`date -d "$start_time + $(shuf -i 1-6 -n 1) hours $(shuf -i 0-60 -n 1) minutes $(shuf -i 0-60 -n 1) seconds" +'%H:%M:%S'`,`shuf -i 1-60 -n 1`,`shuf -i 100-1500 -n 1`,`shuf -i 1-6 -n 1`,`shuf -i 10-99 -n 1`.`shuf -i 100000-999999 -n 1`,`shuf -i 10-99 -n 1`.`shuf -i 100000-999999 -n 1`" >> "$FILE_NAME"
        done
    }
else
    printf "Usage: sh GenerateCSV.sh <filename without extension> <No of files to generate> \nThe files will be generated with .csv extension\n" 
fi 