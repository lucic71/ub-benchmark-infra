# Getting Started Guide

1. Run the docker image using the following command:
```
docker run --rm -it --privileged --pid=host ub-benchmarks /bin/bash
```
The `privileged` flag is needed in order to run the benchmarks using `nice`,
which affects process scheduling. `pid=host` is needed in order to flush the
swap back to main memory after a demanding benchmark, such as build-llvm, runs.

2. Below is a description of each file in the '/benchmarks' directory, where you
you will land after launching the docker image:
```
benchmarks.txt: 
    This file contains the names of the Phoronix Test Suite benchmarks that will
    be evaluated, one per line. To disable a benchmark, simply add '#' at the
    beginning of a line.

flags.sh:
    This file contains the names of the flags used for compiling the benchmarks,
    one per line. To disable a flag, simply add '#' at the beginning of a line.

get-size-results.sh:
    Script used for comparing the binary size results when compiling the same
    benchmark with different flags.

merge-results.sh:
    Script used for merging the peformance numbers when compiling the same
    benchmark with different flags.

prepare-benchmark-env.sh:
    Disables turbo-boost, hyperthreading, put CPU at fixed frequency and disable
    ASLR.

README.md
    This file.

run.sh
    Entry point for running the benchmarks. Supports 2 arguments:
        `--lto`, when passed, enables LTO support for compiling the benchmarks
        `--run-only-all`, compiles the benchmarks with all flags at once.
        Default is to first run with each flag separately, then run with all
        flags at once.

toolchain
    clang and clang++ wrappers that force the compilation of the benchmarks with
    the flags specified in flags.sh.

Dockerfile
    Used for building the current docker image.
```

# Step-by-Step Instructions

## How to run the UB benchmarks

1. Control the flags you want to benchmark by editing `flags.sh`. For this demo
   only 2 flags are enabled: `baseline` and `-fwrapv`.
2. Control the benchmarks you want to run by editing `benchmarks.txt`. For this
   demo only 2 benchmarks are enabled: `pts/simdjson-2.0.1` and
   `pts/compress-pbzip2-1.6.0`
3. `./run.sh`. ETA: TODO

## How to view the performance results

1. `./merge-results.sh`
2. `pts list-saved-results`
```
Possible output:
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
Possible output:
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

## How to view the code size results

1. `./get-size-results.sh`
```
Possible output:
-base:
259976  /var/lib/phoronix-test-suite/installed-tests/pts/compress-pbzip2-1.6.0/pbzip2-1.1.13/pbzip2
327716  /var/lib/phoronix-test-suite/installed-tests/pts/simdjson-2.0.1/simdjson-2.0.4/build/libsimdjson.a

-fwrapv:
259304  /var/lib/phoronix-test-suite/installed-tests/pts/compress-pbzip2-1.6.0/pbzip2-1.1.13/pbzip2
327804  /var/lib/phoronix-test-suite/installed-tests/pts/simdjson-2.0.1/simdjson-2.0.4/build/libsimdjson.a
```
