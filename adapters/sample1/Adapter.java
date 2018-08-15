package com.sample1;

import java.io.File;
import java.io.IOException;
import java.lang.RuntimeException;

public class Adapter {
    public static void load() {
        NativeLogger.log(0, "Java load()");
        System.load("/data/local/tmp/fuzz/sample1/libnative.so");
    }

    public static void main(String[] args) {
        NativeLogger.log(0, "Java main()");

        File file = new File(args[0]);
        int file_size = (int)file.length();

        NativeJni jni = new NativeJni();
        jni.dummy(file_size);
    }
}
