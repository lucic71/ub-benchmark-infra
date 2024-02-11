#!/bin/sh

BMS=`for f in impacts/*
do
	tail -n +2 $f | awk -v thrs="$@" -F',' ' { 
		relevant = 0;
		for (i = 3; i <= NF; i++) {
			if ($i == "N/A") {
				relevant = 2;
				break;
			}
			if ($i > thrs || $i < -thrs) {
				relevant = 1;
				break;
			}
		}

		if (relevant == 1)
			print $0
	}'
done`

RES=`echo "$BMS" | awk -F',' '
	BEGIN {
		flags[3]="all"
		flags[4]="base"
		flags[5]="fcheck-div-rem-overflow"
		flags[6]="fconstrain-shift-value"
		flags[7]="fdrop-align-attr"
		flags[8]="fdrop-deref-attr"
		flags[9]="fdrop-inbounds-from-gep-mllvm-disable-oob-analysis"
		flags[10]="fdrop-noalias-restrict-attr"
		flags[11]="fdrop-ub-builtins"
		flags[12]="fignore-pure-const-attrs"
		flags[13]="fno-constrain-bool-value"
		flags[14]="fno-delete-null-pointer-checks"
		flags[15]="fno-finite-loops"
		flags[16]="fno-strict-aliasing"
		flags[17]="fno-use-default-alignment"
		flags[18]="fstrict-enums"
		flags[19]="fwrapv"
		flags[20]="mllvm-disable-object-based-analysis"
		flags[21]="mllvm-zero-uninit-loads"
		flags[22]="Xclang-no-enable-noundef-analysis"
	}
	{
		for (i = 4; i <= NF; i++) {
			print $i "  ----  " flags[i] "  ----  " $0
		}
	}' | sort -t' ' -k1,1 -n`

head -n1 impacts/`ls impacts | shuf -n1`
echo
echo "$RES"
