#!/bin/bash


FUZZ_DIR=/data/local/tmp/fuzz

# Set terminal settings
${FUZZ_DIR}/busybox stty rows 100 cols 100

# Skip CPU frequency scaling
# If you have root permissions, run this cmd instead
#	su
# 	cd /sys/devices/system/cpu && echo performance | tee cpu*/cpufreq/scaling_governor
#	exit
export AFL_SKIP_CPUFREQ=1

export LD_LIBRARY_PATH=${FUZZ_DIR}:/system/lib
export AFL_DALVIKVM_FUZZ_LIB=libnative.so

rm -rf ${FUZZ_DIR}/sample1/out/*

# Skiped deterministic steps for the sample
# If you need full analysis, remove -d option
${FUZZ_DIR}/afl-fuzz \
    -Q -m 1024Mb \
    -d \
    -i ${FUZZ_DIR}/sample1/in \
    -o ${FUZZ_DIR}/sample1/out \
    ${FUZZ_DIR}/dalvikvm -classpath ${FUZZ_DIR}/sample1/sample1.dex com.sample1.Adapter \
    @@
