# Android Kotlin example

Requirements: Android API 26+, `arm64-v8a` device.

1. Copy `platforms/android-arm64-v8a/libkattplay.so` to:

   `app/src/main/jniLibs/arm64-v8a/libkattplay.so`

2. Copy `NativePlayer.kt` into the application's `com.kattplay` package. The package/class name must remain unchanged because it matches the compiled JNI exports.
3. Use `ExampleActivity.kt` as the lifecycle/URI pattern.

Gradle does not need Media3 or ExoPlayer for native playback. Your application still owns Android audio focus, MediaSession, notification and foreground-service behavior.

```kotlin
android {
    defaultConfig { minSdk = 26 }
}
```
