# Changelog

All notable KatPlay SDK changes are recorded here. KatPlay is currently in
Alpha; ABI and behavior may change before the first stable release.

## [0.1.0-alpha.1] - 2026-07-18

### Added

- Initial binary-only KatPlay Native Runtime SDK release.
- Native WAV, FLAC and MP3 playback paths without an FFmpeg runtime or linked
  binary dependency.
- Windows x86-64 WASAPI shared/event-driven float PCM runtime.
- Android arm64-v8a AAudio/JNI runtime for API 26 and newer.
- Linux x86-64 ALSA float PCM runtime with PipeWire routing through the ALSA
  compatibility layer.
- Stable public C API version 1.
- Kotlin and Java JNI integration examples.
- Python `ctypes`, .NET P/Invoke and Node.js/Koffi integration examples.
- Per-platform SHA-256 checksums and an Ed25519 SSH release signature.
- Alpha 1 personal and non-commercial license.

### Security and packaging

- Release binaries are stripped of engine source and debug artifacts.
- Windows GCC/MinGW runtime components are linked into the runtime package;
  no extra non-system runtime DLL is required.
- Linux loads `libasound.so.2` dynamically.
- Android exports only the intended JNI/C ABI surface through its version
  script.

### Known limitations

- Linux physical ALSA/PipeWire playback has not yet been audibly validated on
  a physical Linux installation.
- AAC is not part of the advertised Alpha 1 playback scope.
- Only the architectures listed in `docs/PLATFORM_SUPPORT.md` are packaged.
- Alpha 1 does not grant commercial, organizational or redistribution rights.

See `KNOWN_ISSUES.md` for the current detailed limitation list.

