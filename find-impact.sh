#!/bin/sh

impact=$1

for f in results/*-impact.csv
do
	awk -F',' '{
		for (i = 3; i <= NF; i++){
			if ($i > 15 || $i < -15) {
				print $1, $i
				break
			}
		}
	}' $f
done
