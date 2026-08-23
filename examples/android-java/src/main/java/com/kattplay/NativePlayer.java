package com.kattplay;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;

import java.io.IOException;

public final class NativePlayer implements AutoCloseable {
    public static final int OUTPUT_AUTO = 0;
    public static final int OUTPUT_SAFE = 1;
    public static final int OUTPUT_DIRECT = 2;

    private long handle;

    static { System.loadLibrary("kattplay"); }

    public NativePlayer() { this(48000, 2); }

    public NativePlayer(int sampleRate, int channels) {
        handle = nativeCreate(sampleRate, channels);
    }

    public boolean load(String path) {
        return handle != 0 && nativeLoad(handle, path);
    }

    public boolean load(Context context, Uri uri) throws IOException {
        try (ParcelFileDescriptor descriptor =
                 context.getContentResolver().openFileDescriptor(uri, "r")) {
            return descriptor != null &&
                load("/proc/self/fd/" + descriptor.getFd());
        }
    }

    public boolean play() { return handle != 0 && nativePlay(handle); }
    public boolean recoverOutput() {
        return handle != 0 && nativeRecoverOutput(handle);
    }
    public boolean setOutputMode(int mode) {
        return handle != 0 && nativeSetOutputMode(handle, mode);
    }
    public long[] getOutputStatus() {
        return handle == 0 ? null : nativeOutputStatus(handle);
    }
    public void pause() { if (handle != 0) nativePause(handle); }
    public void stop() { if (handle != 0) nativeStop(handle); }
    public boolean seek(double seconds) {
        return handle != 0 && nativeSeek(handle, seconds);
    }
    public int getState() { return handle == 0 ? -1 : nativeState(handle); }
    public double getPositionSeconds() {
        return handle == 0 ? 0.0 : nativePosition(handle);
    }
    public double getDurationSeconds() {
        return handle == 0 ? 0.0 : nativeDuration(handle);
    }
    public String getLastError() {
        return handle == 0 ? "KattPlay handle is not initialized" :
            nativeLastError(handle);
    }
    public String getVersion() { return nativeVersion(); }
    public int getAbiVersion() { return nativeAbiVersion(); }

    @Override public void close() {
        if (handle != 0) {
            nativeDestroy(handle);
            handle = 0;
        }
    }

    private native long nativeCreate(int sampleRate, int channels);
    private native void nativeDestroy(long handle);
    private native boolean nativeLoad(long handle, String path);
    private native boolean nativePlay(long handle);
    private native boolean nativeRecoverOutput(long handle);
    private native boolean nativeSetOutputMode(long handle, int mode);
    private native long[] nativeOutputStatus(long handle);
    private native void nativePause(long handle);
    private native void nativeStop(long handle);
    private native boolean nativeSeek(long handle, double seconds);
    private native int nativeState(long handle);
    private native double nativePosition(long handle);
    private native double nativeDuration(long handle);
    private native String nativeLastError(long handle);
    private native String nativeVersion();
    private native int nativeAbiVersion();
}
