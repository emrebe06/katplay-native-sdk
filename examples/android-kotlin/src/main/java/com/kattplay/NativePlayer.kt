package com.kattplay

import android.content.Context
import android.net.Uri

class NativePlayer(sampleRate: Int = 48000, channels: Int = 2) : AutoCloseable {
    private var handle: Long = nativeCreate(sampleRate, channels)

    fun load(path: String): Boolean = handle != 0L && nativeLoad(handle, path)

    fun load(context: Context, uri: Uri): Boolean =
        context.contentResolver.openFileDescriptor(uri, "r")?.use { descriptor ->
            load("/proc/self/fd/${descriptor.fd}")
        } ?: false

    fun play(): Boolean = handle != 0L && nativePlay(handle)
    fun recoverOutput(): Boolean = handle != 0L && nativeRecoverOutput(handle)
    fun pause() { if (handle != 0L) nativePause(handle) }
    fun stop() { if (handle != 0L) nativeStop(handle) }
    fun seek(seconds: Double): Boolean = handle != 0L && nativeSeek(handle, seconds)
    val state: Int get() = if (handle == 0L) -1 else nativeState(handle)
    val positionSeconds: Double get() = if (handle == 0L) 0.0 else nativePosition(handle)
    val durationSeconds: Double get() = if (handle == 0L) 0.0 else nativeDuration(handle)
    val lastError: String get() = if (handle == 0L) {
        "KattPlay handle is not initialized"
    } else {
        nativeLastError(handle)
    }
    val version: String get() = nativeVersion()
    val abiVersion: Int get() = nativeAbiVersion()

    override fun close() {
        if (handle != 0L) {
            nativeDestroy(handle)
            handle = 0L
        }
    }

    private external fun nativeCreate(sampleRate: Int, channels: Int): Long
    private external fun nativeDestroy(handle: Long)
    private external fun nativeLoad(handle: Long, path: String): Boolean
    private external fun nativePlay(handle: Long): Boolean
    private external fun nativeRecoverOutput(handle: Long): Boolean
    private external fun nativePause(handle: Long)
    private external fun nativeStop(handle: Long)
    private external fun nativeSeek(handle: Long, seconds: Double): Boolean
    private external fun nativeState(handle: Long): Int
    private external fun nativePosition(handle: Long): Double
    private external fun nativeDuration(handle: Long): Double
    private external fun nativeLastError(handle: Long): String
    private external fun nativeVersion(): String
    private external fun nativeAbiVersion(): Int

    companion object {
        init { System.loadLibrary("kattplay") }
    }
}
