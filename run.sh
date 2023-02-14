#!/bin/sh

# run with unmodified compiler
./install-compiler.sh
./instal-profiles.sh
./run-profiles.sh

# run with modified compiler
./install-compiler.sh -mod
./instal-profiles.sh
./run-profiles.sh
