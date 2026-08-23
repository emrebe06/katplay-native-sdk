# Android arm64-v8a runtime

Files:

- `libkattplay.so` — KatPlay JNI runtime, AAudio output.
- `CApi.h` — ABI 2 public header.
- `SHA256SUMS.txt` — package file checksum.

Copy the `.so` to `app/src/main/jniLibs/arm64-v8a/`. Minimum Android API is 26. Use the Kotlin or Java wrapper under `examples/`; its package/class must remain `com.kattplay.NativePlayer`. Auto/KatDirect requests fall back to KatSafe when exclusive low-latency output is unavailable.

License: this update grants no new commercial or redistribution rights. Read the `LICENSE.md` included at the archive root.
