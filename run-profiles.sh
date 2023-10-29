#!/bin/sh -ex

LOG_FILE="run-logs$@.txt"

batch_setup=`echo y && echo n && echo n && echo y && echo n && echo y && echo y`
echo $batch_setup | $PTS batch-setup

# Why did I need this?
ulimit -s unlimited

for p in $(grep -v '#' categorized-profiles.txt | grep -v '/build-')
do
	result_name=`echo $p | cut -d'/' -f2`"$@"
	result_name="$result_name\n$result_name\n$result_name"
	pts_command="echo -n '$result_name' | $PTS batch-run $p"
	sh -c "$pts_command" 2>&1| tee -a $LOG_FILE
done

export CC=`pwd`/llvm-project-llvmorg-15.0.7/build/bin/clang
export CXX=`pwd`/llvm-project-llvmorg-15.0.7/build/bin/clang++

for p in $(grep -v '#' categorized-profiles.txt | grep '/build-')
do
	result_name=`echo $p | cut -d'/' -f2`"$@"
	result_name="$result_name\n$result_name\n$result_name"
	pts_command="echo -n '$result_name' | $PTS batch-run $p"
	sh -c "$pts_command" 2>&1| tee -a $LOG_FILE
done
