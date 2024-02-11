#!/bin/sh -ex

mkdir impacts || true

for f in csvs/*
do
	result_f=impacts/`basename $f .csv`-impact.csv
	head -n1 $f > $result_f
	tail -n +2 $f | awk -F',' -f csv-to-impact.awk >> $result_f
done
