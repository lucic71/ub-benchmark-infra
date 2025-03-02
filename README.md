# How to run the UB benchmarks

1. Control the flags you want to benchmark by editing flags.sh. For this demo
   only 3 flags are enabled: baseline, -fwrapv and -fconstrain-shift-value.
2. Control the benchmarks you want to run by editing benchmarks.txt. For this
   demo only 2 benchmarks are enabled: pts/simdjson-2.0.1 and
   pts/compress-pbzip2-1.6.0
3. `./run.sh`

# How to view the performance results

1. `./merge-results.sh`
2. `pts list-saved-results`
```
root@fabbfa03788e:/benchmarks# pts list-saved-results


Phoronix Test Suite v10.8.4
3 Saved Results

simdjson-2.0.1 simdjson-2.0.1
        - base
        - fwrapv

simdjson-201-base simdjson-2.0.1-base
        - simdjson-2.0.1-base

simdjson-201-fwrapv simdjson-2.0.1-fwrapv
        - simdjson-2.0.1-fwrapv

```
3. `pts result-file-to-text SAVED_RESULT`, where SAVED\_RESULT is a saved result name listed in step 2
```
root@fabbfa03788e:/benchmarks# pts result-file-to-text simdjson-2.0.1
...
simdjson 2.0
Throughput Test: Kostya
GB/s > Higher Is Better
base ... 1.32 |======================================================
fwrapv . 1.34 |=======================================================


simdjson 2.0
Throughput Test: TopTweet
GB/s > Higher Is Better
base ... 1.68 |=======================================================
fwrapv . 1.68 |=======================================================


simdjson 2.0
Throughput Test: LargeRandom
GB/s > Higher Is Better
base ... 0.52 |======================================================
fwrapv . 0.53 |=======================================================


simdjson 2.0
Throughput Test: PartialTweets
GB/s > Higher Is Better
base ... 1.42 |=======================================================
fwrapv . 1.00 |==================================


simdjson 2.0
Throughput Test: DistinctUserID
GB/s > Higher Is Better
base ... 1.60 |================================================
fwrapv . 1.71 |=======================================================

```

# How to view the code size results

TODO
