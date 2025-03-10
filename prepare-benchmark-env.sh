#!/bin/bash -x

# Disable turbo boost
echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
# Disable hyperthreading
echo off | sudo tee /sys/devices/system/cpu/smt/control
# Put CPUs in 80% of max frequency with performance governor
max_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
freq_80_pct=$((max_freq * 80 / 100))
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
    echo performance | sudo tee "$cpu/scaling_governor"
    echo $freq_80_pct | sudo tee "$cpu/scaling_min_freq"
    echo $freq_80_pct | sudo tee "$cpu/scaling_max_freq"
done
# Disable ASLR
echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
