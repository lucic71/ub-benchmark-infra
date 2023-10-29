#!/bin/sh -ex

# array of flags separated by :
export FLAGS=":-fwrapv:-fignore-pure-const-attrs:-fno-strict-aliasing:-fstrict-enums:-fno-delete-null-pointer-checks:-fconstrain-shift-value:-fno-finite-loops:-fno-constrain-bool-value:-fno-use-default-alignment:-fdrop-inbounds-from-gep -mllvm -disable-oob-analysis:-mllvm -zero-uninit-loads:-mllvm -disable-object-based-analysis:-fcheck-div-rem-overflow:-fdrop-noalias-restrict-attr:-fdrop-align-attr:-fdrop-deref-attr:-Xclang -no-enable-noundef-analysis:-fdrop-ub-builtins:-all"
FLAGSNO=$((`echo $FLAGS | tr -cd ':' | wc -c`+1))

export PTS_BASE=$HOME/.phoronix-test-suite
export PTS_BM_BASE=/mnt/tmp/pts
LLVM_DIR=/usr/bin/ub/
export PTS="php $HOME/git/phoronix-test-suite/pts-core/phoronix-test-suite.php"

# Delete previous compiled binaries and previous results
rm -rf $PTS_BM_BASE/installed-tests/*
rm -rf $PTS_BM_BASE/test-results/*
rm -rf $PTS_BM_BASE/test-results-*

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
	 cd test-profiles && git checkout x86 && cd .. && rm -rf $PTS_BASE/test-profiles && \
	 cp -r test-profiles $PTS_BASE)
fi

# Install dependencies
sudo apt install -y libnl-genl-3-dev php-xml php-dom

for i in $(seq 1 $FLAGSNO);
do
	flags=`echo $FLAGS | cut -d':' -f$i`

        if [ "$flags" = "-fno-use-default-alignment" ] || [ "$flags" = "-all"]
        then
		export LDFLAGS="-latomic"
        else
		export LDFLAGS=""
        fi

	export UB_OPT_FLAG="-O2"
	export CC="$LLVM_DIR/clang $flags"
	export CXX="$LLVM_DIR/clang++ $flags"

	if [ "$flags" = "" ]
	then
		flags="-base"
	fi
	CONCAT_FLAGS=`echo $flags | tr -d ' '`

	./install-profiles.sh $flags
	./record-size.sh      `echo $CONCAT_FLAGS | cut -c2-`
	./run-profiles.sh     $CONCAT_FLAGS

	mkdir "$PTS_BM_BASE/test-results$CONCAT_FLAGS/" || true
	mv -f  $PTS_BM_BASE/test-results/* "$PTS_BM_BASE/test-results$CONCAT_FLAGS/" || true
	rm -rf $PTS_BM_BASE/installed-tests/*
done
