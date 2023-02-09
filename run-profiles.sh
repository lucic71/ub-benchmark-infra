#!/bin/sh -ex

# run this for having the modified version of pts
# php ../phoronix-test-suite/pts-core/phoronix-test-suite.php 

# append this at the end of the command to save overall logs
# | tee pts-run-out.txt

/usr/bin/time sh -c 'cat profiles.txt | xargs -n1 phoronix-test-suite batch-run'
