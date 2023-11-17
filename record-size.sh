#!/bin/sh -ex

# Create directory where binary sizes will be saved for current flag
mkdir -p size-results/$1 || true

PTS_INSTALLED_TESTS=$PTS_BM_BASE/installed-tests/pts
RES_DIR=size-results/$1

du -b `pwd`/llvm-project-llvmorg-15.0.7/build/bin/* > $RES_DIR/build-llvm || true
du -b $PTS_INSTALLED_TESTS/fftw-1.2.0/fftw-{mr,stock}/tests/bench > $RES_DIR/fftw || true
du -b $PTS_INSTALLED_TESTS/aom-av1-3.6.0/aom/build/aomenc > $RES_DIR/aom-av1 || true
du -b $PTS_INSTALLED_TESTS/jpegxl-1.5.0/libjxl-0.7.0/build/tools/cjxl > $RES_DIR/jpegxl || true
du -b $PTS_INSTALLED_TESTS/graphics-magick-2.1.0/gm_/bin/gm > $RES_DIR/jpegxl || true
du -b $PTS_INSTALLED_TESTS/tjbench-1.2.0/libjpeg-turbo-2.1.0/build/tjbench > $RES_DIR/tjbench || true
du -b $PTS_INSTALLED_TESTS/simdjson-2.0.1/simdjson-2.0.4/build/libsimdjson.a > $RES_DIR/simdjson || true
du -b $PTS_INSTALLED_TESTS/aircrack-ng-1.3.0/aircrack-ng-1.7/aircrack-ng > $RES_DIR/aircrack-ng || true
du -b $PTS_INSTALLED_TESTS/openssl-3.1.0/openssl-3.1.0/apps/openssl > $RES_DIR/openssl || true
du -b $PTS_INSTALLED_TESTS/john-the-ripper-1.8.0/john-c7cacb14f5ed20aca56a52f1ac0cd4d5035084b6/run/john > $RES_DIR/john-the-ripper || true
du -b $PTS_INSTALLED_TESTS/redis-1.4.0/redis-7.0.4/src/{redis-server,redis-cli} > $RES_DIR/redis || true
du -b $PTS_INSTALLED_TESTS/encode-flac-1.8.1/flac_/bin/flac > $RES_DIR/encode-flac || true
du -b $PTS_INSTALLED_TESTS/basis-1.1.1/basis_universal-1.13/bin/basisu > $RES_DIR/basis || true
du -b $PTS_INSTALLED_TESTS/draco-1.6.0/draco-1.5.6/build/draco_encoder > $RES_DIR/draco || true
du -b $PTS_INSTALLED_TESTS/compress-zstd-1.6.0/zstd-1.5.4/zstd > $RES_DIR/compress-zstd || true
du -b $PTS_INSTALLED_TESTS/compress-pbzip2-1.6.0/pbzip2-1.1.13/pbzip2 > $RES_DIR/compress-pbzip2 || true
du -b $PTS_INSTALLED_TESTS/espeak-1.7.0/espeak_/bin/espeak-ng > $RES_DIR/espeak || true
find $PTS_INSTALLED_TESTS/rnnoise-1.0.2/rnnoise-git/ -name *.so* -or -name *.a | xargs du -b > $RES_DIR/rnnoise || true
du -b $PTS_INSTALLED_TESTS/quantlib-1.1.0/QuantLib-1.30/build/ql/libQuantLib.so.1.30.0 > $RES_DIR/quantlib || true
du -b $PTS_INSTALLED_TESTS/ngspice-1.0.0/ngspice-34/src/ngspice > $RES_DIR/ngspice || true
du -b $PTS_INSTALLED_TESTS/apache-3.0.0/httpd_/bin/httpd > $RES_DIR/apache || true
du -b $PTS_INSTALLED_TESTS/nginx-3.0.1/nginx_/sbin/nginx > $RES_DIR/nginx || true
du -b $PTS_INSTALLED_TESTS/z3-1.0.0/z3-z3-4.12.1/build/z3 > $RES_DIR/z3 || true
du -b $PTS_INSTALLED_TESTS/luajit-1.1.0/LuaJIT-Git/src/luajit > $RES_DIR/luajit || true
