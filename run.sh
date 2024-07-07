#!/bin/sh -ex

# array of flags separated by :
FLAGS=":-fwrapv:-fignore-pure-const-attrs:-fno-strict-aliasing:-fstrict-enums:-fno-delete-null-pointer-checks:-fconstrain-shift-value:-fno-finite-loops:-fno-constrain-bool-value:-fno-use-default-alignment:-fdrop-inbounds-from-gep -mllvm -disable-oob-analysis:-mllvm -zero-uninit-loads:-mllvm -disable-object-based-analysis:-fcheck-div-rem-overflow:-fdrop-noalias-restrict-attr:-fdrop-align-attr:-fdrop-deref-attr:-Xclang -no-enable-noundef-analysis:-fdrop-ub-builtins:-all"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

PTS_BASE=$HOME/.phoronix-test-suite
if [ `lscpu | grep -ic arm` = 1 ]
then
	export PTS_BM_BASE=/mnt/tmp/pts
else
	export PTS_BM_BASE=/ssd/pts
fi
LLVM_DIR=`pwd`/toolchain
export PTS="php $HOME/git/phoronix-test-suite/pts-core/phoronix-test-suite.php"

# Delete previous compiled binaries and previous results
rm -rf $PTS_BM_BASE/installed-tests/*
rm -rf $PTS_BM_BASE/test-results/*
rm -rf $PTS_BM_BASE/test-results-*
rm -rf $PTS_BASE/test-results/*
rm -rf $PTS_BASE/test-results-*
rm -rf size-results

mkdir size-results || true

# Download llvm-15 used by pts/build-llvm benchmark
if [ ! -d llvm-project-llvmorg-15.0.7 ]
then
	wget https://codeload.github.com/llvm/llvm-project/tar.gz/refs/tags/llvmorg-15.0.7
	tar xzvf llvmorg-15.0.7
fi

# Download my modified phoronix-test-suite
if [ ! -d $HOME/git/phoronix-test-suite ]
then
	(cd $HOME/git && git clone https://github.com/lucic71/phoronix-test-suite)
fi

# Download my modified test-profiles
if [ ! -d $HOME/git/test-profiles ]
then
	(cd $HOME/git && git clone https://github.com/lucic71/test-profiles && \
	 cd test-profiles && git checkout ub && cd .. && rm -rf $PTS_BASE/test-profiles && \
	 cp -r test-profiles $PTS_BASE)
fi

# Install dependencies
sudo apt install -y libnl-genl-3-dev php-xml php-dom

OLDPATH=$PATH
NEWPATH=home/lucian/git/llvm-project/build/bin:$PATH

for i in $(seq 1 $FLAGSNO); do
	for p in $(grep -v '#' categorized-profiles.txt | grep -v '/build-'); do
		### COMPILE BENCHMARK ###
		flags=`echo $FLAGS | cut -d':' -f$i`

		if [ "$flags" = "-fno-use-default-alignment" ] || [ "$flags" = "-all" ]
		then
			export LDFLAGS="-latomic"
		else
			export LDFLAGS=""
		fi

		export LD_LIBRARY_PATH=/home/lucian/git/llvm-project/build/lib:${LD_LIBRARY_PATH}
		export PATH=${NEWPATH}
		export CC=$LLVM_DIR/clang
		export CXX=$LLVM_DIR/clang++

		if [ "$flags" = "-all" ]
		then
			# Delete first character from FLAGS then delete ":-all" then replace ':' with ' '
			# Also delete -fstrict-enums because it introduces UB
			_flags=`echo $FLAGS | cut -c2- | rev | cut -c6- | rev | tr ':' ' ' | awk -F"-fstrict-enums" '{print $1 $2}'`
			export UB_OPT_FLAG="-O2 $_flags -flto -fuse-ld=gold"
			#export UB_OPT_FLAG="-O2 $_flags"

		else
			export UB_OPT_FLAG="-O2 $flags -flto -fuse-ld=gold"
			#export UB_OPT_FLAG="-O2 $flags"
		fi

		if [ "$flags" = "" ]; then
			flags="-base"
		fi

		$PTS debug-install $p

		### GET BINARY SIZE ###
		CONCAT_FLAGS=`echo $flags | tr -d ' '`
		PTS_INSTALLED_TESTS=$PTS_BM_BASE/installed-tests/pts

		# Create directory where binary sizes will be saved for current flag
		mkdir -p size-results/sz$CONCAT_FLAGS || true
		du -ab $PTS_BM_BASE/installed-tests/$p > size-results/sz$CONCAT_FLAGS/`echo $p | cut -d'/' -f2`

		continue

		### RUN BENCHMARK ###
		unset CC
		unset CXX
		unset UB_OPT_FLAG
		unset LDFLAGS
		unset LD_LIBRARY_PATH
		export PATH=${OLDPATH}

		batch_setup=`echo y && echo n && echo n && echo y && echo n && echo y && echo y`
		echo $batch_setup | $PTS batch-setup

		result_name=`echo $p | cut -d'/' -f2`"$CONCAT_FLAGS"
		result_name="$result_name\n$result_name\n$result_name"
		pts_command="echo -n '$result_name' | $PTS batch-run $p"
		sh -c "$pts_command" 
	done

	#./record-size.sh      `echo $CONCAT_FLAGS | cut -c2-`

	flags=`echo $FLAGS | cut -d':' -f$i`
	if [ "$flags" = "" ]; then
		flags="-base"
	fi
	CONCAT_FLAGS=`echo $flags | tr -d ' '`

	mkdir "$PTS_BASE/test-results$CONCAT_FLAGS/" || true
	mv -f  $PTS_BM_BASE/test-results/* "$PTS_BASE/test-results$CONCAT_FLAGS/" || true
	rm -rf $PTS_BM_BASE/installed-tests/*
done
