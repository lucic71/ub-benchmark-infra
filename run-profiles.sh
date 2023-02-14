#!/bin/sh -ex

export CC=/usr/bin/cc
export CXX=/usr/bin/c++
export LD=/usr/bin/ld
/usr/bin/time sh -c 'cat rand-profiles.txt | xargs -n1 /usr/bin/time php /home/lucianp/git/phoronix-test-suite/pts-core/phoronix-test-suite.php batch-run 2>&1 | tee -a benchmark-log.txt'
