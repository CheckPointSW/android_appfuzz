#!/bin/bash


ADPT_DIR=$(cd "$(dirname "$0")"; pwd -P)
FUZZ_DIR=/data/local/tmp/fuzz

adb shell mkdir ${FUZZ_DIR}
adb shell mkdir ${FUZZ_DIR}/sample1

adb push ${ADPT_DIR}/sample1/bin/libnative.so ${FUZZ_DIR}/sample1
adb shell chmod 755 ${FUZZ_DIR}/sample1/libnative.so

adb push ${ADPT_DIR}/sample1/bin/sample1.dex ${FUZZ_DIR}/sample1
adb shell chmod 755 ${FUZZ_DIR}/sample1/sample1.dex

adb shell mkdir ${FUZZ_DIR}/sample1/out
adb shell mkdir ${FUZZ_DIR}/sample1/in

adb push ${ADPT_DIR}/sample1/testcase/first.bin ${FUZZ_DIR}/sample1/in

# Push fuzzing script
adb push ${ADPT_DIR}/fuzz_sample1.sh ${FUZZ_DIR}
adb shell chmod 755 ${FUZZ_DIR}/fuzz_sample1.sh
