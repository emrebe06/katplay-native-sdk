# Platform support

## Windows x86-64

- Native output: WASAPI shared mode, event-driven float PCM.
- Runtime file: `kattplay_runtime.dll`.
- Supported integrations in this SDK: Python `ctypes`, .NET P/Invoke and Node.js/Koffi.
- The DLL should be placed beside the executable/script or referenced by an absolute path.

## Android arm64-v8a

- Minimum Android version: API 26 / Android 8.
- Native output: AAudio with Auto, KatDirect preview and KatSafe modes.
- Runtime file: `libkattplay.so`.
- Put it under `app/src/main/jniLibs/arm64-v8a/`.
- Kotlin and Java wrappers must use package/class name `com.kattplay.NativePlayer`, matching the exported JNI bridge.
- KatDirect is active only when AAudio returns exclusive + low-latency output.
  Rejected requests fall back to shared low-latency and then KatSafe.
- Android audio focus, media session, notification and foreground-service policy stay in the application layer.

## Linux x86-64

- Native output: ALSA interleaved float PCM.
- Runtime file: `libkattplay_runtime.so`.
- The runtime dynamically loads `libasound.so.2`.
- On PipeWire distributions, install/enable the PipeWire ALSA compatibility plugin; the ALSA `default` PCM then routes into PipeWire.
- Override the PCM device with `KATTPLAY_ALSA_DEVICE`, for example `KATTPLAY_ALSA_DEVICE=hw:0,0`.
- Keep the `.so` beside the application, add its directory to `LD_LIBRARY_PATH`, or install it in an application-private library directory.

## Codec scope

Playback scope for this Alpha package is WAV, FLAC and MP3.

AAC is not advertised. The native AAC-LC decoder is still under incremental
conformance development and rejects most real-world files; only ADTS is
recognised as a container. It will be advertised once its streaming and player
paths pass the same release tests as the three formats above.

Ogg and Opus are not playable. The engine gained Ogg container parsing, an
Opus range decoder and the CELT pulse-vector codebook in Alpha 3, but the Opus
decoder itself does not exist yet.

## Offline retuning

`kattplay_retune_file` converts a file to a different concert-pitch reference
and writes the result as FLAC. It reads every container the engine can decode
and is independent of playback; see `docs/C_API.md`.

## License scope

This technical update grants no new commercial or redistribution rights.
LICENSE.md is authoritative.

## Not included

- FFmpeg or FFmpeg-derived binaries.
- KatBalance/KatPlay C++ engine source.
- C++ static libraries or private C++ headers.
- Commercial or public redistribution rights.
