# KatPlay Native Runtime SDK — 0.3.0-alpha.1

**By Emre Demirbaş**

KatPlay is the native playback-runtime branch of the KatBalance entropy-aware DSP architecture. This folder is a **binary-only SDK**: it contains compiled runtimes, the stable C API header, integration examples and documentation. KatBalance/KatPlay engine source code is intentionally not included.

## Platform packages

| Platform | Runtime | Native output | Architecture |
|---|---|---|---|
| Windows | `kattplay_runtime.dll` | WASAPI shared/event-driven float PCM | x86-64 |
| Android | `libkattplay.so` | AAudio low-latency float PCM | arm64-v8a, API 26+ |
| Linux | `libkattplay_runtime.so` | ALSA default PCM; PipeWire through ALSA compatibility | x86-64 |

The engine plays native WAV, FLAC and MP3 sources. No FFmpeg, ExoPlayer or Media3 binary, source tree or runtime dependency is included.

## Alpha 3 highlights

- MP3 gapless trimming now holds on the streaming path as well as the buffered
  one. Alpha 2 advertised this behaviour, but the encoder delay and padding live
  in the ID3v2 tag, which the incremental reader skipped; streamed output
  carried one frame more than the buffered decode.
- AAC streaming no longer rebuilds its IMDCT overlap for every packet, so each
  frame is overlap-added with the previous frame's tail instead of silence.
- `kattplay_retune_file` converts a file to a different concert-pitch reference
  offline, preserving duration. It takes no handle and does not disturb
  playback; see [docs/C_API.md](docs/C_API.md).
- The codec core is now verified on ARM64 hardware with the NEON dispatch level
  confirmed active, not merely compiled for it.

Carried over from Alpha 2 and unchanged:

- ABI 2 keeps the Alpha 1 transport calls and adds output-mode control and an allocation-free output-status snapshot.
- Android Auto/KatDirect requests try exclusive low-latency AAudio first, then shared low-latency, then KatSafe.
- The runtime reports negotiated sample rate, channels, format, sharing/performance mode, buffer geometry, xruns and recovery count.
- KatDirect is reported active only when AAudio actually returns exclusive + low-latency. MMAP remains Unknown unless it can be confirmed; the SDK does not make a hardware-bypass or bit-perfect claim.

## Downloads

Compiled runtimes are published as versioned GitHub Release assets rather than committed as large binary blobs in Git history. Download the archive matching your platform. Alpha 3 uses `release/SHA256SUMS-0.3.0-alpha.1.txt`; earlier manifests remain unchanged.

## Folder map

```text
include/kattplay/CApi.h        Backward-compatible ABI=2 public interface
platforms/windows-x86_64/      Windows runtime
platforms/android-arm64-v8a/   Android JNI runtime
platforms/linux-x86_64/        Linux runtime
examples/android-kotlin/       Kotlin/JNI integration
examples/android-java/         Java/JNI integration
examples/python/               ctypes desktop integration
examples/dotnet/               C# P/Invoke integration
examples/javascript/           Node.js/Koffi integration
docs/                          ABI and platform notes
release/                       Separate distributable archives
keys/                          Public release-verification key only
LICENSE.md                     Alpha 1 personal/non-commercial terms
COMMERCIAL_USE.md              Commercial-use boundary and Alpha notice
CHANGELOG.md                   Version history
SECURITY.md                    Private vulnerability reporting policy
THIRD_PARTY_NOTICES.md         Toolchain, system and example notices
KNOWN_ISSUES.md                Current Alpha limitations
```

## Fast start

1. Select the platform runtime under `platforms/`.
2. Open the matching example under `examples/`.
3. Load a WAV, FLAC or MP3 file.
4. Keep transport calls (`load`, `play`, `pause`, `seek`, `stop`) serialized on the application's control thread.
5. Read `lastError` whenever an operation returns false/zero.

## License status

KatPlay 0.3.0-alpha.1 remains proprietary software. This technical update does not grant new commercial or redistribution rights; [LICENSE.md](LICENSE.md) is authoritative.

Read [LICENSE.md](LICENSE.md) and [COMMERCIAL_USE.md](COMMERCIAL_USE.md) before downloading or using the runtime.

## Integrity and security

The Alpha 1 checksum manifest is signed by the original KatPlay Ed25519 release key (`SHA256:izX4xT8KNnsRqXiQ9j18CwlW04dUGsprDpoukR7vQeU`). The signing key was rotated on 30 August 2026 after the original private key was lost; Alpha 3 is signed by the replacement key (`SHA256:KQRIInURMNolBohsw8n9aNTsduSSFokUbad8CAEboWY`). Both public keys remain committed so historical signatures continue to verify. Read [SECURITY.md](SECURITY.md), [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), [KNOWN_ISSUES.md](KNOWN_ISSUES.md) and [docs/VERIFY_RELEASE.md](docs/VERIFY_RELEASE.md) before distribution or security testing.

## Alpha notice

This is an Alpha release. Report reproducible problems, device/OS details and a minimal test file description to `emrebe06@gmail.com`. Do not attach copyrighted audio unless you have permission to share it.
