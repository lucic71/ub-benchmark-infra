#/bin/sh

# For this artifact, only 3 flags are enabled: baseline, -fwrapv and
# -fconstrain-shift-value. To run -all, uncomment all the flags beforehand.

# Empty string: baseline.
FLAGS="" # DO NOT EDIT THIS LINE

FLAGS="$FLAGS:-fwrapv"
FLAGS="$FLAGS:-fconstrain-shift-value"
#FLAGS="$FLAGS:-fignore-pure-const-attrs"
#FLAGS="$FLAGS:-fno-strict-aliasing"
#FLAGS="$FLAGS:-fstrict-enums"
#FLAGS="$FLAGS:-fno-delete-null-pointer-checks"
#FLAGS="$FLAGS:-fno-finite-loops"
#FLAGS="$FLAGS:-fno-constrain-bool-value"
#FLAGS="$FLAGS:-fno-use-default-alignment"
#FLAGS="$FLAGS:-fdrop-inbounds-from-gep -mllvm -disable-oob-analysis"
#FLAGS="$FLAGS:-mllvm -zero-uninit-loads"
#FLAGS="$FLAGS:-mllvm -disable-object-based-analysis"
#FLAGS="$FLAGS:-fcheck-div-rem-overflow"
#FLAGS="$FLAGS:-fdrop-noalias-restrict-attr"
#FLAGS="$FLAGS:-fdrop-align-attr"
#FLAGS="$FLAGS:-fdrop-deref-attr"
#FLAGS="$FLAGS:-Xclang -no-enable-noundef-analysis"
#FLAGS="$FLAGS:-fdrop-ub-builtins"

# All the above flags. Please uncomment all flags if you want to run -all.
# Use ./run.sh --run-only-all after uncommenting all flags above if you want to
# only run all flags combined. The default behavior is to run each flag
# separately and at the end run all flags combined.
#FLAGS="$FLAGS:-all"

FLAGSNO=$(($(echo $FLAGS | tr -cd ':' | wc -c) + 1))
