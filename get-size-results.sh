#!/bin/bash -e

. ./flags.sh # import FLAGS, FLAGSNO

SEARCHDIR=size-results

BMS="build-llvm-1.5.0:aircrack-ng-1.3.0:aom-av1-3.7.0:botan-1.6.0:compress-pbzip2-1.6.0:compress-zstd-1.6.0:draco-1.6.0:encode-flac-1.8.1:espeak-1.7.0:fftw-1.2.0:graphics-magick-2.1.0:john-the-ripper-1.8.0:jpegxl-1.5.0:luajit-1.1.0:mafft-1.6.2:ngspice-1.0.0:openssl-3.1.0:primesieve-1.9.0:quantlib-1.2.0:rnnoise-1.0.2:simdjson-2.0.1:sqlite-speedtest-1.0.1:tjbench-1.2.0:z3-1.0.0"
SEARCHSTR='libclang.so.15.0.7$:.libs/aircrack-ng:aomenc$:Botan-2.17.3/botan$:pbzip2-1.1.13/pbzip2$:programs/zstd$:build/draco_encoder-1.5.6$:bin/flac$:libespeak-ng.so.1.1.51$:fftw-mr/tests/bench$:gm_/bin/gm$:run/john$:build/libjxl.so.0.7.0$:src/luajit$:mafft_/mafft$:src/ngspice$:apps/openssl$:primesieve-8.0/primesieve$:libQuantLib.so.1.32.0$:librnnoise.so.0.4.1$:build/libsimdjson.a$:speedtest1$:build/libjpeg.so.62.3.0$:build/z3$'
BMSNO=$((`echo $BMS | tr -cd ':' | wc -c`+1))

for i in $(seq 1 $FLAGSNO); do
        flags=`echo $FLAGS | cut -d':' -f$i | tr -d ' '`
        if [ $flags = "" ]; then flags="-base"; fi

        for j in $(seq 1 $BMSNO); do
                searchStr=$(echo $SEARCHSTR | cut -d':' -f$j | tr -d ' ')
                benchmark=$(echo $BMS | cut -d':' -f$j | tr -d ' ')

                if $(grep -v '#' benchmarks.txt | grep -q $benchmark); then :; else
                        continue
                fi

                grep -rIh "$searchStr" $SEARCHDIR/sz$flags
        done
        echo
done
