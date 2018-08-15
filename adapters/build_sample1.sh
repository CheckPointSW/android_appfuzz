#!/bin/bash


ADPT_DIR=$(cd "$(dirname "$0")"; pwd -P)
NDK=${ADPT_DIR}/../android-ndk-r10e

SRC_DIR=${ADPT_DIR}/sample1
BLD_DIR=${ADPT_DIR}/sample1/build
OUT_DIR=${ADPT_DIR}/sample1/bin

if [ ! -d ${BLD_DIR} ]; then
  mkdir ${BLD_DIR}
fi

if [ ! -d ${OUT_DIR} ]; then    
  mkdir ${OUT_DIR}
fi

echo "[*] libnative.so building..."

# Download NDK r10e
if [ ! -d ${NDK} ]; then
  cd ${ADPT_DIR}/..
  wget https://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip
  unzip android-ndk-r10e-linux-x86_64.zip
  rm android-ndk-r10e-linux-x86_64.zip
fi

# Build libnative.so
${NDK}/ndk-build \
    NDK_TOOLCHAIN=arm-linux-androideabi-4.9 \
    NDK_PROJECT_PATH=. \
    NDK_OUT=${BLD_DIR} \
    NDK_LIBS_OUT=${BLD_DIR} \
    APP_BUILD_SCRIPT=${SRC_DIR}/native/Android.mk \
    APP_ABI=armeabi \
    APP_PLATFORM=android-21

cp ${BLD_DIR}/armeabi/libnative.so ${OUT_DIR}

echo "[*] sample1.dex building..."

# Let's use javac 1.7 (as Android 6.x Runtime)
if [ -z "$(echo $(javac -version 2>&1) | grep '[ "]1\.7[\. "$$]')" ]; then
  echo "[-] Error: incorrect javac version. 1.7 is required"
  exit 1
fi

# Build sample1.dex
# If your adapter uses Android Framework specific namespaces, indicate relevant Android SDK JAR file as [-cp] javac option
# For example, javac -cp ~/Android/Sdk/platforms/android-21/layoutlib.jar
javac -d ${BLD_DIR} -g \
    ${SRC_DIR}/NativeJni.java \
    ${SRC_DIR}/NativeLogger.java \
    ${SRC_DIR}/Adapter.java

${ADPT_DIR}/../bin/dx --dex --output=${OUT_DIR}/sample1.dex ${BLD_DIR}

echo "[+] Done!"
