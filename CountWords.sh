#!/bin/bash
input="data.txt"
while IFS= read -r var
do
  words=( $var )
  for((word=0;word<${#words[@]};word++))
  {
      echo ${words[$word]} | tr -d '[:punct:]'
  }
done < "$input"
# cat data.txt | tr '[:space:]' '[\n*]' | grep -v "^\s*$" | sort | uniq -c | sort -bnr