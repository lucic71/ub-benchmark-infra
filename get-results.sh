#!/bin/sh

PTS_RESULTS_DIR=/var/lib/phoronix-test-suite/test-results/

input="rand-profiles.txt"
while IFS= read -r line
do
	tp=`echo $line | cut -d'/' -f2`
	echo $tp
	resfiles=`grep -orP --include=composite.xml '(?<=<Identifier>).*?(?=</Identifier>)' $PTS_RESULTS_DIR \
		| grep -v 'Intel Xeon' \
		| grep $tp \
		| cut -d':' -f1 \
		| uniq \
		| rev \
		| cut -d'/' -f2 \
		| rev \
		| xargs echo`

	# I had to modify a bit PTS because it prompted me with questions
	# about opening the result file which broke my script.
	php ../phoronix-test-suite/pts-core/phoronix-test-suite.php merge-results $resfiles
done < "$input"
