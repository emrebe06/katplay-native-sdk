# Changelog

All notable KatPlay SDK changes are recorded here. KatPlay is currently in
Alpha; ABI and behavior may change before the first stable release.

## [0.2.0-alpha.1] - 2026-08-23

### Added

- ABI 2 output control with Auto, KatSafe and KatDirect modes.
- Truthful output-status snapshots for negotiated format, sharing mode,
  performance mode, buffer geometry, xruns and recovery history.
- Android KatDirect preview with exclusive/low-latency AAudio negotiation and
  ordered KatSafe fallback.
- JNI/Kotlin output-mode and Output Inspector bindings.
- Current KatBalance WAV, FLAC and MP3 codec core, including MP3 gapless
  delay/padding behavior.

### Compatibility

- All ABI 1 lifecycle and transport entry points remain present.
- Existing callers work without using the new ABI 2 functions and receive the
  safe automatic output policy.
- Alpha 1 was not renamed or moved into a legacy tree; its Git tag and release
  history remain intact.

### Verification

- Windows x86-64 native runtime tests passed.
- Windows x86-64, Android ARM64/API 26 and Linux x86-64 runtimes compiled.
- Android AArch64 and Linux x86-64 ELF architecture/export tables were checked.
- Physical Android route, focus and long-running soak tests remain required
  before calling this preview production-ready.

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
