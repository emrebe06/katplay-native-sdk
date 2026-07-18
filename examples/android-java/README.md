# Android Java example

Requirements: Android API 26+, `arm64-v8a` device.

1. Copy `platforms/android-arm64-v8a/libkattplay.so` to `app/src/main/jniLibs/arm64-v8a/`.
2. Copy `NativePlayer.java` without changing its `com.kattplay.NativePlayer` package/class name.
3. Follow `ExampleActivity.java` for URI and lifecycle handling.

No Media3 or ExoPlayer dependency is required for KatPlay decoding/rendering. Android audio focus, MediaSession and notification controls remain application responsibilities.
