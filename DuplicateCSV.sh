#!/bin/sh

# To create duplicates rows in csv file
echo started at:`date +%T:%N`
file=/home/pradeep/Desktop/sample.csv
i=1;
while [ $i -lt 1000000 ]
do
    i=`expr $i + 1`
    # -q supresses the headers that normally get printed, -n 1 prints only the first line
    head -q -n 3000 $file >> output.csv
done
echo ended at:`date +%T:%N`


# To add serial number as  first column of csv file
awk -F, '{$1=++i FS $1;}1' OFS=, /home/pradeep/Desktop/sample.csv > output.csv