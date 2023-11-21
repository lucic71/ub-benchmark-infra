#!/bin/sh -ex

PTS="php $HOME/git/phoronix-test-suite/pts-core/phoronix-test-suite.php"
PTS_TEST_RESULTS=$HOME/.phoronix-test-suite/test-results

rm -rf $PTS_TEST_RESULTS/*
cp -r results/* $PTS_TEST_RESULTS

mkdir htmls || true

find $PTS_TEST_RESULTS -name composite.xml | xargs sed -i 's/BAR_GRAPH/HORIZONTAL_BOX_PLOT/g'

for f in $PTS_TEST_RESULTS/*
do
        base=`basename $f`
        $PTS result-file-to-html $base
        mv $HOME/$base.html htmls/
done

