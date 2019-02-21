#!/bin/bash

# Removing files from the directory if no of files are more than 10
for i in `ls ~/textclassification/20_newsgroup`
do
    cd ~/textclassification/20_newsgroup/$i
    echo `pwd`
    x=`ls|wc -l`
    echo $x
    if [ $x -le 10 ] ;
    then
        echo "no of files 10"
    else
        y="$((x-10))"
        `ls | head -$y | xargs rm -rf`
    fi
done
cd ~



