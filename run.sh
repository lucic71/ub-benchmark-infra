#!/bin/sh -ex

# array of flags separated by :
FLAGS=":-fwrapv:-fno-strict-aliasing:-fstrict-enums:-fno-delete-null-pointer-checks:-fconstrain-shift-value:-fno-finite-loops:-fno-constrain-bool-value"
#FLAGS="-fno-use-default-alignment"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

rm -rf /var/lib/phoronix-test-suite/installed-tests/*
rm -rf /var/lib/phoronix-test-suite/test-results/*
rm -rf /var/lib/phoronix-test-suite/test-results-*

for i in $(seq 1 $FLAGSNO);
do
	flags=`echo $FLAGS | cut -d':' -f$i`

	# PATH is set for the linker to be found
	export PATH="/git/llvm-ub-free/build/bin:$PATH"
	export CC="/git/llvm-ub-free/build/bin/clang $flags"
	export CXX="/git/llvm-ub-free/build/bin/clang++ $flags"
	export NUM_CPU_CORES=`nproc`
	# export LDFLAGS="-latomic" this is only needed when running -fno-use-default-alignment

	if [ "$flags" = "" ]
	then
		flags="-base"
	fi
	CONCAT_FLAGS=`echo $flags | tr -d ' '`

	/usr/bin/time ./install-profiles.sh $flags
	/usr/bin/time ./run-profiles.sh     $CONCAT_FLAGS

	mkdir "/var/lib/phoronix-test-suite/test-results$CONCAT_FLAGS/" || true
	mv -f /var/lib/phoronix-test-suite/test-results/* "/var/lib/phoronix-test-suite/test-results$CONCAT_FLAGS/" || true
	rm -rf /var/lib/phoronix-test-suite/installed-tests/*
done

echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
