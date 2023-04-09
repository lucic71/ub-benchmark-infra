#!/bin/sh -ex

mkdir text-results/ || true
cp -r results/* /var/lib/phoronix-test-suite/test-results/

for p in $(ls -1 /git/ub-benchmark-infra/results)
do
	echo y | php /git/phoronix-test-suite/pts-core/phoronix-test-suite.php show-result $p/ | tee text-results/$p.txt
done

cd text-results/
for res in $(ls -1 ./)
do
	sed -i '1,7d' $res
	sed -i '4,36d' $res
	sed -i "1s/.*/hardware info:/" $res
done
