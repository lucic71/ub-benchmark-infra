#!/bin/sh -ex

# Create directory where binary sizes will be saved for current flag
mkdir -p size-results/$@ || true

PTS_INSTALLED_TESTS=/var/lib/phoronix-test-suite/installed-tests/pts

du -b /ssd/llvm-project-llvmorg-15.0.7/build/bin/* > size-results/$@/build-llvm
du -b $PTS_INSTALLED_TESTS/fftw-1.2.0/fftw-{mr,stock}/tests/bench > size-results/$@/fftw
du -b $PTS_INSTALLED_TESTS/aom-av1-3.6.0/aom/build/aomenc > size-results/$@/aom-av1
du -b $PTS_INSTALLED_TESTS/uvg266-1.0.0/uvg266-0.4.1/build/uvg266 > size-results/$@/uvg266
find $PTS_INSTALLED_TESTS/brl-cad-1.4.0/brlcad-7.34.0/build/lib -name *.so* -or -name *.a | xargs du -b > size-results/$@/brl-cad
du -b $PTS_INSTALLED_TESTS/mrbayes-1.5.0/MrBayes-3.2.7a/src/mb > size-results/$@/mrbayes
du -b $PTS_INSTALLED_TESTS/hmmer-1.3.0/hmmer-3.3.2/src/hmmsearch > size-results/$@/hmmer
du -b $PTS_INSTALLED_TESTS/jpegxl-1.5.0/libjxl-0.7.0/build/tools/cjxl > size-results/$@/jpegxl
du -b $PTS_INSTALLED_TESTS/graphics-magick-2.1.0/gm_/bin/gm > size-results/$@/jpegxl
du -b $PTS_INSTALLED_TESTS/tungsten-1.0.0/tungsten-master/build/release/tungsten > size-results/$@/tungsten
du -b $PTS_INSTALLED_TESTS/tjbench-1.2.0/libjpeg-turbo-2.1.0/build/tjbench > size-results/$@/tjbench
du -b $PTS_INSTALLED_TESTS/simdjson-2.0.1/simdjson-2.0.4/build/libsimdjson.a > size-results/$@/simdjson
du -b $PTS_INSTALLED_TESTS/aircrack-ng-1.3.0/aircrack-ng-1.7/aircrack-ng > size-results/$@/aircrack-ng
du -b $PTS_INSTALLED_TESTS/openssl-3.1.0/openssl-3.1.0/apps/openssl > size-results/$@/openssl
du -b $PTS_INSTALLED_TESTS/john-the-ripper-1.8.0/john-c7cacb14f5ed20aca56a52f1ac0cd4d5035084b6/run/john > size-results/$@/john-the-ripper
du -b $PTS_INSTALLED_TESTS/redis-1.4.0/redis-7.0.4/src/{redis-server,redis-cli} > size-results/$@/redis
du -b $PTS_INSTALLED_TESTS/encode-flac-1.8.1/flac_/bin/flac > size-results/$@/encode-flac
du -b $PTS_INSTALLED_TESTS/basis-1.1.1/basis_universal-1.13/bin/basisu > size-results/$@/basis
du -b $PTS_INSTALLED_TESTS/draco-1.6.0/draco-1.5.6/build/draco_encoder > size-results/$@/draco
du -b $PTS_INSTALLED_TESTS/compress-zstd-1.6.0/zstd-1.5.4/zstd > size-results/$@/compress-zstd
du -b $PTS_INSTALLED_TESTS/compress-pbzip2-1.6.0/pbzip2-1.1.13/pbzip2 > size-results/$@/compress-pbzip2
du -b $PTS_INSTALLED_TESTS/espeak-1.7.0/espeak_/bin/espeak-ng > size-results/$@/espeak
find $PTS_INSTALLED_TESTS/rnnoise-1.0.2/rnnoise-git/ -name *.so* -or -name *.a | xargs du -b > size-results/$@/rnnoise
du -b $PTS_INSTALLED_TESTS/liquid-dsp-1.0.0/liquid/lib/libliquid.* > size-results/$@/liquid-dsp
du -b $PTS_INSTALLED_TESTS/gtkperf-1.2.2/gtkperf_env/bin/gtkperf > size-results/$@/gtkperf
du -b $PTS_INSTALLED_TESTS/quantlib-1.1.0/QuantLib-1.30/build/ql/libQuantLib.so.1.30.0 > size-results/$@/quantlib
du -b $PTS_INSTALLED_TESTS/pjsip-1.0.1/pjproject-2.11/{pjlib,pjmedia,pjlib-util,pjnath,third_party}/lib/ > size-results/$@/pjsip
du -b $PTS_INSTALLED_TESTS/ngspice-1.0.0/ngspice-34/src/ngspice > size-results/$@/ngspice
du -b $PTS_INSTALLED_TESTS/apache-3.0.0/httpd_/bin/httpd > size-results/$@/apache
du -b $PTS_INSTALLED_TESTS/nginx-3.0.1/nginx_/sbin/nginx > size-results/$@/nginx
du -b /var/lib/phoronix-test-suite/installed-tests/local/z3/z3-z3-4.12.1/build/z3 > size-results/$@/z3
