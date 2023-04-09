#!/bin/sh -ex

# array of flags separated by :
FLAGS=":-fwrapv:-fno-strict-aliasing:-fstrict-enums:-fno-delete-null-pointer-checks:-fconstrain-shift-value:-fno-constrain-bool-value"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

PTS_DIR=/var/lib/phoronix-test-suite

mkdir ./results || true

rm -rf PTS_DIR/test-results/*

# Copy the results for each flag in test-results/
for i in $(seq 1 $FLAGSNO);
do
	flags=`echo $FLAGS | cut -d':' -f$i`
	if [ "$flags" = "" ]
	then
		flags="-base"
	fi
	cp -r $PTS_DIR/test-results$flags/* $PTS_DIR/test-results/	
done

# Merge the results for the same flag into a single result
for profile in $(cat categorized-profiles.txt | grep -v '#')
do
	profile_results=`ls -1 $PTS_DIR/test-results/ | grep $(echo $profile | cut -d'/' -f2)`
	echo n | phoronix-test-suite merge-results $profile_results
done

# Copy the merged results here
for profile in $(cat categorized-profiles.txt | grep -v '#')
do
	profile_name=`echo $profile | cut -d'/' -f2`
	merged_result=`grep -rl $profile_name-base $PTS_DIR/test-results/merge-* | rev | cut -d'/' -f2- | rev`
	cp -r $merged_result ./results/$profile_name
done

# Change the title to contain only the name of the test profile
for res in `grep -orPn -m1 --include=*.xml '(?<=<Title>).*?(?=</Title>)' results/`
do
	file=`echo $res | cut -d':' -f1`
	lineno=`echo $res | cut -d':' -f2`
	title=`echo $res | cut -d':' -f3`
	sed_command="$lineno""s/$title/$(echo $title | rev | cut -d'-' -f2- | rev)/"
	sed -i $sed_command $file
done

# Drpo the name of the test profile from the test results
for res in `ls -1 results`
do
	ids=`grep -orPn --include=*.xml '(?<=<Identifier>).*?(?=</Identifier>)' results/ | grep $res | grep -vP 'pts\/|local\/'`
	for id in $ids
	do
		file=`echo $id | cut -d':' -f1`
		lineno=`echo $id | cut -d':' -f2`
		title=`echo $id | cut -d':' -f3`
		new_title=`echo $title | sed -e "s/^${res}-//"`
		sed_command="$lineno""s/$title/$new_title/"
		sed -i $sed_command $file
	done
done
