#!/bin/sh -ex

# array of flags separated by :
FLAGS=":-fwrapv:-fno-strict-aliasing:-fstrict-enums:-fno-delete-null-pointer-checks:-fconstrain-shift-value:-fno-finite-loops:-fno-constrain-bool-value:-fno-use-default-alignment:-fdrop-inbounds-from-gep -mllvm -trap-on-oob -mllvm -disable-oob-analysis:-mllvm -zero-uninit-loads:-mllvm -disable-object-based-analysis:-fcheck-div-rem-overflow"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

rm -rf /var/lib/phoronix-test-suite/installed-tests/*
rm -rf /var/lib/phoronix-test-suite/test-results/*
rm -rf /var/lib/phoronix-test-suite/test-results-*

mkdir size-results || true

if [ ! -d llvm-project-llvmorg-15.0.7 ]
then
	wget https://codeload.github.com/llvm/llvm-project/tar.gz/refs/tags/llvmorg-15.0.7
	tar xzvf llvmorg-15.0.7
fi

for i in $(seq 1 $FLAGSNO);
do
	flags=`echo $FLAGS | cut -d':' -f$i`

	# PATH is set for the linker to be found
	#export PATH="/git/llvm-project/build/bin:$PATH"
	export CC="/git/llvm-project/build/bin/clang $flags"
	export CXX="/git/llvm-project/build/bin/clang++ $flags"
	export NUM_CPU_CORES=`nproc`
        if [ "$flags" = "-fno-use-default-alignment" ]
        then
		export LDFLAGS="-latomic"
        else
		export LDFLAGS=""
        fi

	if [ "$flags" = "" ]
	then
		flags="-base"
	fi
	CONCAT_FLAGS=`echo $flags | tr -d ' '`

	./install-profiles.sh $flags
	./record-size.sh      `echo $CONCAT_FLAGS | cut -c2-`
	./run-profiles.sh     $CONCAT_FLAGS

	mkdir "/var/lib/phoronix-test-suite/test-results$CONCAT_FLAGS/" || true
	mv -f /var/lib/phoronix-test-suite/test-results/* "/var/lib/phoronix-test-suite/test-results$CONCAT_FLAGS/" || true
	rm -rf /var/lib/phoronix-test-suite/installed-tests/*
done

echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
