# ub-benchmark-infra
Collection of scripts used for benchmarking various systems against UB
optimizations.

# Useful information
To create a new benchmark for phoronix-test-suite (PTS) you need to use
the template found in template/. The template is a modified
compress-pbzip2. Modify it as per your use case, put the modified
template/ in /var/lib/phoronix-test-suite/test-profiles/local/ (at least
that is for Debian 11) and run:
```
phoronix-test-suite force-install yourtestsuite
```

Read the content of the files in template/ if you want to understand
what they are doing.

If you want to install it with your compiler configuration run:
```
CC=/path/to/c/compiler CXX=/path/to/cpp/compiler CFLAGS='-f1 -f2'
CXXFLAGS='-f3 -f4' phoronix-test-suite force-install yourtestsuite
```

Then to run the benchmark run:
```
phoronix-test-suite benchmark yourtestsuite
```

To delete a benchmark run:
```
rm -rf /var/lib/phoronix-test-suite/installed-tests/local/yourtestsuite
rm -rf /var/lib/phoronix-test-suite/test-profiles/local/yourtestsuite
```

# UB benchmarking algorithm
```
for ts in test-suites
	res = {}
	for ub in undef_behaviors:
		compile_testsuite(ts, {compiler, ub})
		run_testsuite(ts)
		res += fetch_testsuite_results()
	compare_results(res)
```

The only problem that I see here is that at one moment I will want to
combine multiple UBs to test their impact. I don't want to try all
combinations of UBs, instead it would be helpful to do an analysis to
see what UBs are required to be tested.
