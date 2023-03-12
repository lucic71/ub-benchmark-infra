#!/bin/sh -ex

LOG_DIR="install-logs""$@"
mkdir $LOG_DIR || true
mkdir $LOG_DIR/pts || true
mkdir $LOG_DIR/local || true

PTS="/usr/bin/time php /home/lucianp/git/phoronix-test-suite/pts-core/phoronix-test-suite.php debug-install"

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

PTS_COMMAND="(trap 'kill 0' INT; "
# Omit the profiles in LLVM Build Speed as they need special treatment
for p in $(grep -v '#' categorized-profiles.txt | tail -n +3)
do
	PTS_COMMAND=$PTS_COMMAND"\$PTS $p 2>&1 | tee \$LOG_DIR/$p.log & "
done
PTS_COMMAND=$PTS_COMMAND"wait)"

eval $PTS_COMMAND

# Process the profiles in LLVM Build Speed
COMPILED_CLANG_PATH=/ssd/llvm-project-llvmorg-15.0.7
(cd $COMPILED_CLANG_PATH && ./build.sh)

PTS_COMMAND="(trap 'kill 0' INT; "
for p in $(grep -v '#' categorized-profiles.txt | head -n2)
do
	PTS_COMMAND=$PTS_COMMAND"PATH='$COMPILED_CLANG_PATH/build-clang/bin:$COMPILED_CLANG_PATH/build-llvm/bin:$PATH' CC=$COMPILED_CLANG_PATH/build-clang/bin/clang CXX=$COMPILED_CLANG_PATH/build-clang/bin/clang++ \$PTS $p 2>&1 | tee \$LOG_DIR/$p.log & "
done
PTS_COMMAND=$PTS_COMMAND"wait)"
eval $PTS_COMMAND
