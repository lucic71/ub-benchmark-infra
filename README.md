# Getting Started Guide

The artifact comprises a Docker image `ub-benchmarks.tar.gz`. Depending on
your system, docker commands might or might not need to be prefixed with sudo.
In the following we will leave off sudo, but you may have to add it yourself.

You can load the Docker image into Docker with:
```
$ docker load -i ub-benchmarks.tar.gz
```

You can then run the image with:
```
$ docker run --rm -it --privileged --pid=host ub-benchmarks /bin/bash
```

The `privileged` flag is needed in order to run the benchmarks using `nice`,
which affects process scheduling. `pid=host` is needed in order to flush the
swap back to main memory after a demanding benchmark, such as `build-llvm`, runs.

After launching the docker image, you will land in the `/benchmarks` directory
which contains our experimental infrastructure. The `./run.sh` runs the Phoronix
Test Suite benchmarks and saves the results in `/var/lib/phoronix-test-suite`.
To control the behavior of `run.sh`, please read the below description of the
files inside `/benchmarks`:

* `benchmarks.txt`: 
    This file contains the names of the Phoronix Test Suite benchmarks that will
    be evaluated, one per line. To disable a benchmark, simply add '#' at the
    beginning of a line.

* `flags.sh`
    This file contains the names of the flags used for compiling the benchmarks,
    one per line. To disable a flag, simply add '#' at the beginning of a line.

* `get-size-results.sh`:
    Script used for comparing the binary size results when compiling the same
    benchmark with different flags.

* `merge-results.sh`:
    Script used for merging the peformance numbers when compiling the same
    benchmark with different flags.

* `prepare-benchmark-env.sh`:
    Disables turbo-boost, hyperthreading, put CPU at fixed frequency and disable
    ASLR.

* `README.md`:
    This file.

* `run.sh`:
    Entry point for running the benchmarks. Supports 2 arguments:
    * `--lto`, when passed, enables LTO support for compiling the benchmarks
    * `--run-only-all`, compiles the benchmarks with all flags at once.
    Default is to first run with each flag separately, then run with all
    flags at once.

* `toolchain/`:
    clang and clang++ wrappers that force the compilation of the benchmarks with
    the flags specified in flags.sh.

* `Dockerfile`:
    Used for building the current docker image.

# Step-by-Step Instructions

This artifact reproduces the results presented in Fig. 1-5.

In our experiments we used 3 servers:
* 2x Intel Xeon CPU E5-2680 v2 @ 2.80GHz (IvyBridge), 64GB DDR3 RAM (@ 1600
  MHz), running Debian 11
* 2x ARM64 Neoverse-N1 @ 3.00GHz (Ampere Altra) server, 1024GB DDR4 RAM (@ 3200
  MHz), running Ubuntu 22.04
* 2x AMD EPYC 9J14 @ 4.00GHz (Zen) server, 2304GB DDR5 RAM (@ 4800 MHz), running
  Ubuntu 22.04

Additionally, we run our benchmarks in 2 configurations: LTO and non-LTO. The
precise results you obtain are likely to be somewhat different unless you use
the same hardware. Hopefully the general trends will remain stable.

There are 24 benchmarks and 19 flag configurations in our suite. It takes around
2.5 weeks run all benchmarks with all 19 flag configurations. This number
doubles to 5 weeks when considering that we can run the benchmarks in LTO and
non-LTO modes.

For quick testing the artifact, we enabled a limited number of benchmarks and
flags. However, you can freely edit the `flags.sh` and `benchmarks.txt` files to
enabled more flags and bechmarks.

Besides that, you can find the install scripts for the benchmarks in
`/var/lib/phoronix-test-suite/test-profiles`. This directory is created after
running `/benchmarks/run.sh` once. Alternatively, the test profiles are
available in this Github repo:
[test-profiles](https://github.com/lucic71/test-profiles).

The modified clang version that implements most of the flags used for
benchmarking can be found in `/llvm-project`. Alternatively, it is available as
well in this Github repo:
[llvm-project](https://github.com/lucic71/llvm-project/tree/release/16.x-ub).

## System Requirements

All required packages to run the benchmarks are already installed in the docker
image. The dependencies are listed in the `Dockerfile` which is present in
`/benchmarks`.

There are no strict memory or CPU requirements for running the benchmarks. If
you are limited on RAM, avoid running benchmarks such as `build-llvm`,
especially in LTO mode.

## How to run the benchmarks

1. Control the flags you want to benchmark by editing `flags.sh`. For this demo
   only 2 flags are enabled: `baseline` and `-fwrapv`.
2. Control the benchmarks you want to run by editing `benchmarks.txt`. For this
   demo only 2 benchmarks are enabled: `pts/simdjson-2.0.1` and
   `pts/compress-pbzip2-1.6.0`
3. `$ ./run.sh`. ETA: TODO

## How to view the performance results

Run the below commands after you successfully ran the benchmarks.

1. `$ ./merge-results.sh`
2. `$ pts list-saved-results`
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
3. `$ pts result-file-to-text SAVED_RESULT`, where SAVED\_RESULT is a saved result name listed in step 2
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

Run the below commands after you successfully ran the benchmarks.

1. `$ ./get-size-results.sh`
    ```
    Possible output:
    -base:
    259976  /var/lib/phoronix-test-suite/installed-tests/pts/compress-pbzip2-1.6.0/pbzip2-1.1.13/pbzip2
    327716  /var/lib/phoronix-test-suite/installed-tests/pts/simdjson-2.0.1/simdjson-2.0.4/build/libsimdjson.a

    -fwrapv:
    259304  /var/lib/phoronix-test-suite/installed-tests/pts/compress-pbzip2-1.6.0/pbzip2-1.1.13/pbzip2
    327804  /var/lib/phoronix-test-suite/installed-tests/pts/simdjson-2.0.1/simdjson-2.0.4/build/libsimdjson.a
    ```
