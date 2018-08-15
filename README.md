# Android Application's Native Fuzzer

A Fuzzer for the native part of Android apps (closed source .so files). This tool is based on [AFL Fuzzer](https://github.com/mcarpenter/afl) and [QEMU emulator](https://github.com/qemu/qemu).

**Since this tool may be used for malicious intentions other than security research, we do not publicly share the code or the binary. Nevertheless, we will be happy to cooperate and share the tool with fellow security researchers. For more details you're welcome to contact** slavam@checkpoint.com

##### How does it work?

This tool consists of several parts including patched version of Android Runtime (libart.so), dalvikvm tool, GLib, QEMU and AFL. The assembly of these tools eventually allows to fuzz a user custom lib wrapped in a DEX file on an actual Android device or an ARM device emulator. The execution flow is as follows: 
`AFL Fuzz Engine → QEMU ARM CPU emulator → dalvikvm tool → Android Runtime + adapter DEX`

## Compatibility
* Android 6.x (Marshmallow)
* All build scripts target ARMv7 platform

## Test Run

First make sure an Android 6.x device is connected and accessible via ADB.
Execute the following commands:

```bash
./push.sh                                               # push base fuzzer binaries to the device
adapters/push_sample1.sh                                # push sample1 adapter to the device
adb shell source /data/local/tmp/fuzz/fuzz_sample1.sh   # start fuzzing sample1
```

## Running your first custom adapter
A full example of a custom Java adapter as well as build, push and execution scripts can be found in [adapters](adapters) directory.

A custom Java adapter is a class which implements at least two main methods:
* `load()` - will be executed only once when the fuzzing starts
* `main()` - will be called for each test case. The first argument is the path to the file containing the permuted data

The Java adapter should be compiled as a DEX to be later fuzzed in the following way:

```bash
FUZZ_DIR=/data/local/tmp/fuzz                    # Directory containing all fuzzer binaries
export LD_LIBRARY_PATH=${FUZZ_DIR}:/system/lib   # Use FUZZ_DIR as a path to the patched libs
export AFL_DALVIKVM_FUZZ_LIB=libnative.so        # Target lib to be fuzzed

${FUZZ_DIR}/afl-fuzz -Q -m 1024Mb -i ${FUZZ_DIR}/sample1/in -o ${FUZZ_DIR}/sample1/out \
	${FUZZ_DIR}/dalvikvm -classpath \
	${FUZZ_DIR}/sample1/sample1.dex \
	com.sample1.Adapter @@                   # Compiled DEX and Adapter’s class name
```

For further information please refer to [AFL documentation](https://github.com/mcarpenter/afl/tree/master/docs).

## How to build the Fuzzer?

All binaries are pre-built and ready for use, they can be found in [lib](lib) and [bin](bin) directories.

Should you have any reason to build the Fuzzer on your own, here’s what you need to do:

##### Prerequisites (For Ubuntu 16.04)

* Install Git:

```bash
sudo apt-get install git-core
```

* Install repo:

```bash
mkdir ~/bin && PATH=~/bin:$PATH
wget -O ~/bin/repo https://storage.googleapis.com/git-repo-downloads/repo
chmod a+x ~/bin/repo
```

* Install Java 7:

```bash
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-7-jdk
```

##### Run the build script

```bash
./build.sh
```

What does the script do?
* Download and unpack NDK r10e
* Patch & Build
  * libiconv 1.14
  * libffi 3.2.1
  * gettext 0.19.7
  * glib 2.48.1
  * AFL 2.52b
  * QEMU 2.10.0 
  * AOSP 6.0.1_r65 (libart, dalvikvm, dx)

It should be noted that downloading AOSP will take a very long time!

## License

Released under “Apache 2.0” license.


Presented in DEF CON 26 (2018) by Slava Makkaveev