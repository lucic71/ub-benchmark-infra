#!/bin/sh -ex

CONCAT_FLAGS=`echo $@ | tr -d ' '`
LOG_DIR="install-logs""$CONCAT_FLAGS"
mkdir $LOG_DIR || true
mkdir $LOG_DIR/pts || true
mkdir $LOG_DIR/local || true

PTS_COMMAND="(trap 'kill 0' INT; "
# Omit the profiles in LLVM Build Speed as they need special treatment
for p in $(grep -v '#' categorized-profiles.txt | grep -v '/build-')
do
	PTS_COMMAND=$PTS_COMMAND"\$PTS debug-install $p 2>&1 | tee \$LOG_DIR/$p.log & "
done
PTS_COMMAND=$PTS_COMMAND"wait)"

eval $PTS_COMMAND

# Process the profiles in LLVM Build Speed
if [ $(grep -v '#' categorized-profiles.txt | grep '/build-' | wc -l) -gt 0 ]
then
	COMPILED_CLANG_PATH=`pwd`/llvm-project-llvmorg-15.0.7
	if [ `lscpu | grep -ic x86` = 1 ]
	then
		(cd $COMPILED_CLANG_PATH && rm -rf build/ && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="llvm;clang" -S ./llvm -B build/ && ninja -C build)
	else
		(cd $COMPILED_CLANG_PATH && rm -rf build/ && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=AArch64 -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="llvm;clang" -S ./llvm -B build/ && ninja -C build)
	fi

	PTS_COMMAND="(trap 'kill 0' INT; "
	for p in $(grep -v '#' categorized-profiles.txt | grep '/build-')
	do
		PTS_COMMAND=$PTS_COMMAND"PATH='$COMPILED_CLANG_PATH/build/bin:$PATH' CC=$COMPILED_CLANG_PATH/build/bin/clang CXX=$COMPILED_CLANG_PATH/build/bin/clang++ \$PTS debug-install $p 2>&1 | tee \$LOG_DIR/$p.log & "
	done
	PTS_COMMAND=$PTS_COMMAND"wait)"
	eval $PTS_COMMAND
fi
