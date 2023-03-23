#!/bin/sh -ex

LOG_FILE="run-logs$@.txt"

batch_setup=`echo y && echo n && echo n && echo y && echo n && echo y && echo y`
echo $batch_setup | phoronix-test-suite batch-setup

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

for p in $(grep -v '#' categorized-profiles.txt | grep -v '/build-')
do
	result_name=`echo $p | cut -d'/' -f2`"$@"
	result_name="$result_name\n$result_name\n$result_name"
	pts_command="echo -n '$result_name' | php /home/lucianp/git/phoronix-test-suite/pts-core/phoronix-test-suite.php batch-run $p"
	/usr/bin/time sh -c "$pts_command" 2>&1| tee -a $LOG_FILE
done

# PATH is set for the linker to be found
export PATH="/ssd/llvm-project-llvmorg-15.0.7/build/bin:$PATH"
export CC=/ssd/llvm-project-llvmorg-15.0.7/build/bin/clang
export CXX=/ssd/llvm-project-llvmorg-15.0.7/build/bin/clang++

for p in $(grep -v '#' categorized-profiles.txt | grep '/build-')
do
	result_name=`echo $p | cut -d'/' -f2`"$@"
	result_name="$result_name\n$result_name\n$result_name"
	pts_command="echo -n '$result_name' | php /home/lucianp/git/phoronix-test-suite/pts-core/phoronix-test-suite.php batch-run $p"
	/usr/bin/time sh -c "$pts_command" 2>&1| tee -a $LOG_FILE
done
