#!/bin/sh -ex

if [ "$1" = "-mod" ]; then
	ln -sf `pwd`/mod-cc /usr/bin/cc
	ln -sf `pwd`/mod-c++ /usr/bin/c++
	ln -sf `pwd`/mod-lld /usr/bin/ld
else
	ln -sf `pwd`/cc /usr/bin/cc
	ln -sf `pwd`/c++ /usr/bin/c++
	ln -sf `pwd`/lld /usr/bin/ld
fi
