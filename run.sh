#!/bin/sh -ex

# array of flags separated by :
FLAGS=":-fwrapv:-fno-strict-aliasing:-fstrict-enums"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

for i in $(seq 1 $FLAGSNO);
do
	flags=`echo $FLAGS | cut -d':' -f$i`

	# PATH is set for the linker to be found
	export PATH="/ssd/llvm-project-master/build-clang/bin:/ssd/llvm-project-master/build-llvm/bin:$PATH"
	export CC="/ssd/llvm-project-master/build-clang/bin/clang $flags"
	export CXX="/ssd/llvm-project-master/build-clang/bin/clang++ $flags"

	if [ "$flags" = "" ]
	then
		flags="-base"
	fi
	CONCAT_FLAGS=`echo $flags | tr -d ' '`

	/usr/bin/time ./install-profiles.sh $CONCAT_FLAGS
	/usr/bin/time ./run-profiles.sh     $CONCAT_FLAGS

	mkdir "/var/lib/phoronix-test-suite/test-results$CONCAT_FLAGS/" || true
	mv -f /var/lib/phoronix-test-suite/test-results/* "/var/lib/phoronix-test-suite/test-results$CONCAT_FLAGS/" || true
	rm -rf /var/lib/phoronix-test-suite/installed-tests/*
done

echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
