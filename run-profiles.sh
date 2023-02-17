#!/bin/sh -ex

export CC=/usr/bin/cc
export CXX=/usr/bin/c++
export LD=/usr/bin/ld

CONCAT_FLAGS=`echo "$@" | tr -d ' '`
LOG_FILE="run-log"$CONCAT_FLAGS".txt"

if [ "$CONCAT_FLAGS" = "" ]
then
	CONCAT_FLAGS="base"
fi

batch_setup=`echo y && echo n && echo n && echo y && echo n && echo y && echo y`
echo $batch_setup | phoronix-test-suite batch-setup

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

for profile in $(cat rand-profiles.txt)
do
	result_name=`echo $profile | cut -d'/' -f2`"$CONCAT_FLAGS"
	result_name="$result_name\n$result_name\n$result_name"
	pts_command="echo -n '$result_name' | php /home/lucianp/git/phoronix-test-suite/pts-core/phoronix-test-suite.php batch-run $profile" 
	/usr/bin/time sh -c "$pts_command" 2>&1| tee -a $LOG_FILE
done
