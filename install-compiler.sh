#!/bin/sh -ex

echo '#!/bin/sh' > ./cc
echo -n 'echo "This is clang with ' >> ./cc
echo "$@"'"'>> ./cc
echo -n '/ssd/llvm-project-main/build/bin/clang ' >> ./cc
echo -n "$@"' '>> ./cc
echo '"$@"' >> ./cc
chmod +x ./cc
ln -sf `pwd`/cc /usr/bin/cc

echo '#!/bin/sh' > ./c++
echo -n 'echo "This is clang++ with ' >> ./c++
echo "$@"'"'>> ./c++
echo -n '/ssd/llvm-project-main/build/bin/clang++ ' >> ./c++
echo -n "$@"' '>> ./c++
echo '"$@"' >> ./c++
chmod +x ./c++
ln -sf `pwd`/c++ /usr/bin/c++

echo '#!/bin/sh' > ./ld
echo -n 'echo "This is ld with ' >> ./ld
echo "$@"'"'>> ./ld
echo -n '/ssd/llvm-project-main/build/bin/ld.lld ' >> ./ld
echo -n "$@"' '>> ./ld
echo '"$@"' >> ./ld
chmod +x ./ld
ln -sf `pwd`/ld /usr/bin/ld
