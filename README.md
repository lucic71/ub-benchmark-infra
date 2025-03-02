# How to run the UB benchmarks

1. Control the flags you want to benchmark by editing flags.sh. For this demo
   only 3 flags are enabled: baseline, -fwrapv and -fconstrain-shift-value.
2. Control the benchmarks you want to run by editing benchmarks.txt. For this
   demo only 2 benchmarks are enabled: pts/simdjson-2.0.1 and
   pts/compress-pbzip2-1.6.0
3. ./run.sh

# How to view the performance results

1. ./merge-results.sh
2. pts list-saved-results
3. pts result-file-to-text $RESULT\_NAME

# How to view the code size results

TODO
