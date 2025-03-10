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
which affects process scheduling, and to optionally disable hyperthreading,
turbo-boost, etc on host. `pid=host` is needed in order to flush the swap back
to main memory after a demanding benchmark, such as `build-llvm`, runs.

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

For quick testing the artifact, we enabled a limited number of benchmarks
(encode-flac, draco, espeak) and flags (baseline, -fwrapv,
-fno-constrain-shift-value). However, you can freely edit the `flags.sh` and
`benchmarks.txt` files to enabled more flags and bechmarks.

The install scripts for the benchmarks can be found in the following Github
repo: [test-profiles](https://github.com/lucic71/test-profiles). The modified
clang version that implements most of the flags used for benchmarking can be
found in the following Github repo:
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
   only 3 flags are enabled: `baseline`, `-fwrapv`, `-fconstrain-shift-value`.
2. Control the benchmarks you want to run by editing `benchmarks.txt`. For this
   demo only 3 benchmarks are enabled: `pts/draco-1.6.0`, `pts/luajit-1.1.0`,
   `pts/rnnoise-1.0.2`.
3. Optional: `export FORCE_TIMES_TO_RUN=1`. To reduce the runs per benchmark
   from 3 (default) to 1. Useful for quick testing the benchmark suite.
4. Optional: `./prepare-benchmark-env.sh`. Disables (on host) turbo-boost,
   hyperthreading, put CPU at fixed frequency and disable ASLR. Useful for
   getting stable results.
3. `$ ./run.sh`. ETA: 15 minutes with step 3 and 4 applied

## How to view the performance results

Run the below commands after you successfully ran the benchmarks.

1. `$ ./merge-results.sh`
2. `$ pts list-saved-results`
    ```
    Possible output:
    draco-1.6.0 draco-1.6.0
            - base
            - fconstrain-shift-value
            - fwrapv

    draco-160-base draco-1.6.0-base
            - draco-1.6.0-base

    draco-160-fconstrain-shift-value draco-1.6.0-fconstrain-shift-value
            - draco-1.6.0-fconstrain-shift-value

    draco-160-fwrapv draco-1.6.0-fwrapv
            - draco-1.6.0-fwrapv

    luajit-1.1.0 luajit-1.1.0
            - base
            - fconstrain-shift-value
            - fwrapv

    luajit-110-base luajit-1.1.0-base
            - luajit-1.1.0-base

    luajit-110-fconstrain-shift-value luajit-1.1.0-fconstrain-shift-value
            - luajit-1.1.0-fconstrain-shift-value

    luajit-110-fwrapv luajit-1.1.0-fwrapv
            - luajit-1.1.0-fwrapv

    rnnoise-1.0.2 rnnoise-1.0.2
            - base
            - fconstrain-shift-value
            - fwrapv

    rnnoise-102-base rnnoise-1.0.2-base
            - rnnoise-1.0.2-base

    rnnoise-102-fconstrain-shift-value rnnoise-1.0.2-fconstrain-shift-value
            - rnnoise-1.0.2-fconstrain-shift-value

    rnnoise-102-fwrapv rnnoise-1.0.2-fwrapv
            - rnnoise-1.0.2-fwrapv
    ```
3. `$ pts result-file-to-text SAVED_RESULT`, where SAVED\_RESULT is a saved result name listed in step 2
    ```
    Possible output:
    root@fabbfa03788e:/benchmarks# pts result-file-to-text draco-1.6.0
    ...
    Google Draco 1.5.6
    Model: Lion
    ms < Lower Is Better
    base ................... 8137 |==============================================
    fconstrain-shift-value . 8203 |==============================================
    fwrapv ................. 8098 |=============================================


    Google Draco 1.5.6
    Model: Church Facade
    ms < Lower Is Better
    base ................... 10410 |=============================================
    fconstrain-shift-value . 10319 |============================================
    fwrapv ................. 10440 |=============================================
    ```

## How to view the code size results

Run the below commands after you successfully ran the benchmarks.

1. `$ ./get-size-results.sh`
    ```
    Possible output:
    -base
    1521360 /var/lib/phoronix-test-suite/installed-tests/pts/draco-1.6.0/draco-1.5.6/build/draco_encoder-1.5.6
    568384  /var/lib/phoronix-test-suite/installed-tests/pts/luajit-1.1.0/LuaJIT-Git/src/luajit
    200616  /var/lib/phoronix-test-suite/installed-tests/pts/rnnoise-1.0.2/rnnoise-git/.libs/librnnoise.so.0.4.1

    -fwrapv
    1517552 /var/lib/phoronix-test-suite/installed-tests/pts/draco-1.6.0/draco-1.5.6/build/draco_encoder-1.5.6
    568384  /var/lib/phoronix-test-suite/installed-tests/pts/luajit-1.1.0/LuaJIT-Git/src/luajit
    201544  /var/lib/phoronix-test-suite/installed-tests/pts/rnnoise-1.0.2/rnnoise-git/.libs/librnnoise.so.0.4.1

    -fconstrain-shift-value
    1521360 /var/lib/phoronix-test-suite/installed-tests/pts/draco-1.6.0/draco-1.5.6/build/draco_encoder-1.5.6
    560192  /var/lib/phoronix-test-suite/installed-tests/pts/luajit-1.1.0/LuaJIT-Git/src/luajit
    200600  /var/lib/phoronix-test-suite/installed-tests/pts/rnnoise-1.0.2/rnnoise-git/.libs/librnnoise.so.0.4.1
    ```
