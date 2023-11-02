#!/bin/sh

for f in results/*.csv
do
	result_f=`dirname $f`/`basename $f .csv`-impact.csv
	tail -n +15 $f | head -n1 > $result_f
	tail -n +16 $f | head -n -1 | awk -F',' -f csv-to-impact.awk >> $result_f
done
