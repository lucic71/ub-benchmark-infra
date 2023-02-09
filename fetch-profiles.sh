#!/bin/sh -ex

# find /var/lib/phoronix-test-suite/ -name install-failed.log
# helps you find the profiles that did not install successfully

TEST_PROFILES_DIR=~/git/test-profiles/

# extract the name of the profiles that are compiled with a C compiler
# and drop the version number form their name, eg git/clickhouse-1.0.0
# becomse git/clickhouse. do this to prevent running multiple versions
# of the same profile. running with git/clickhouse gets the latest
# version of the profile.
# 
# and drop windows profiles.

grep -orP --include=*.xml '(?<=<ExternalDependencies>).*?(?=</ExternalDependencies>)' $TEST_PROFILES_DIR \
	| grep "build-utilities" \
	| grep -v windows \
	| cut -d':' -f1 \
	| cut -d'/' -f1,2 \
	| rev \
	| cut -d'-' -f2- \
	| rev > profiles.txt
