#!/bin/sh -ex

PTS="php $HOME/git/phoronix-test-suite/pts-core/phoronix-test-suite.php"
PTS_TEST_RESULTS=$HOME/.phoronix-test-suite/test-results

rm -rf $PTS_TEST_RESULTS/*
cp -r results/* $PTS_TEST_RESULTS

mkdir csvs || true

for f in $PTS_TEST_RESULTS/*
do
        base=`basename $f`
        $PTS result-file-to-csv $base
        mv $HOME/$base.csv csvs/
	tac csvs/$base.csv  | awk -v RS='(\r?\n){2,}' 'NR == 1' | tac > csvs/$base.csv.tmp
	mv csvs/$base.csv.tmp csvs/$base.csv
	sed -i '$ d' csvs/$base.csv
done

