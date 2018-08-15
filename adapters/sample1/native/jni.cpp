#include <jni.h>
#include <unistd.h>

#define JAVA_PROXY(func) Java_com_sample1_NativeJni_##func
#define JAVA_LOGGER "com/sample1/NativeLogger"

void Log(JNIEnv *env, const char* msg) {
    jclass cls = env->FindClass(JAVA_LOGGER);
    jmethodID mid = env->GetStaticMethodID(cls, "log", "(ILjava/lang/String;)V");
    env->CallStaticVoidMethod(cls, mid, 0, env->NewStringUTF(msg));
}

extern "C" void JAVA_PROXY(dummy)(JNIEnv *env, jobject, jint file_size) {
    Log(env, "Native dummy()");

    if (file_size == 2283) {
        Log(env, "Native crash!!!");

        int* ptr = NULL;
        *ptr = 1;
    }
}
