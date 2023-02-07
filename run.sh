#!/bin/sh -ex

PTS_PROFILES_BASE_DIR=/var/lib/phoronix-test-suite
MODCC=/ssd/llvm-project-main/build/bin/clang
MODCXX=/ssd/llvm-project-main/build/bin/clang++
MODCFLAGS=" -fwrapv "
MODCXXFLAGS=" -fwrapv "
pts=`which phoronix-test-suite`

# Install the test profiles
cp -r test-profiles/* $PTS_PROFILES_BASE_DIR/test-profiles/local/

# Install the benchmarks
for fulltp in $PTS_PROFILES_BASE_DIR/test-profiles/local/*; do
	tp=`basename $fulltp`
	CC=$MODCC CXX=$MODCXX CFLAGS=$MODCFLAGS CXXFLAGS=$MODCXXFLAGS $pts debug-install $tp
done

# Run the benchmarks
for fulltp in $PTS_PROFILES_BASE_DIR/installed-tests/local/*; do
	tp=`basename $fulltp`
	$pts benchmark $tp
done
