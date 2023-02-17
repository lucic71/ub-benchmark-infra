#!/bin/sh -ex

# array of flags separated by :
FLAGS=":-fwrapv"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

for i in $(seq 1 $FLAGSNO);
do
	flags=`echo $FLAGS | cut -d':' -f$i`
	./install-compiler.sh $flags
	./install-profiles.sh $flags
	./run-profiles.sh     $flags
done

echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
