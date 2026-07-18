# Android arm64-v8a runtime

Files:

- `libkattplay.so` — KatPlay JNI runtime, AAudio output.
- `SHA256SUMS.txt` — package file checksum.

Copy the `.so` to `app/src/main/jniLibs/arm64-v8a/`. Minimum Android API is 26. Use the Kotlin or Java wrapper under `examples/`; its package/class must remain `com.kattplay.NativePlayer`.

License: Alpha 1 is limited to free personal, non-commercial use. Publishing an APK/AAB, public beta or store application is not licensed, even when the application is free. Read the `LICENSE.md` included at the archive root.
