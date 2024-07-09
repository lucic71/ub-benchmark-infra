#!/bin/bash

for p in php g++ binutils-dev libhwy-dev linux-tools-$(uname -r); do
	sudo apt install -y $p || true
done

if `lscpu | grep -q arm`; then
	for p in linux-modules-extra-6.5.0-1025-oracle; do
		sudo apt install -y $p || true
	done
fi
