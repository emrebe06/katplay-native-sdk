# KatPlay Native Runtime SDK — 0.1.0-alpha.1

**By Emre Demirbaş**

KatPlay is the native playback-runtime branch of the KatBalance entropy-aware DSP architecture. This folder is a **binary-only SDK**: it contains compiled runtimes, the stable C API header, integration examples and documentation. KatBalance/KatPlay engine source code is intentionally not included.

## Platform packages

| Platform | Runtime | Native output | Architecture |
|---|---|---|---|
| Windows | `kattplay_runtime.dll` | WASAPI shared/event-driven float PCM | x86-64 |
| Android | `libkattplay.so` | AAudio low-latency float PCM | arm64-v8a, API 26+ |
| Linux | `libkattplay_runtime.so` | ALSA default PCM; PipeWire through ALSA compatibility | x86-64 |

The engine currently plays native WAV, FLAC and MP3 sources. No FFmpeg binary, source tree or runtime dependency is included.

## Downloads

Compiled runtimes are published as versioned GitHub Release assets rather than committed as large binary blobs in Git history. Download the archive matching your platform and verify it using `release/SHA256SUMS.txt`, `release/SHA256SUMS.txt.sig` and [the verification guide](docs/VERIFY_RELEASE.md).

## Folder map

```text
include/kattplay/CApi.h        Stable ABI=1 public interface
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
COMMERCIAL_USE.md              Commercial-use boundary and Alpha 2 notice
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

KatPlay `0.1.0-alpha.1` is proprietary software released at no charge only for personal, non-commercial use by individual natural persons. Company use, client work, monetization, production deployment, public redistribution and embedding in any publicly distributed product are not licensed, even when that product is free.

Read [LICENSE.md](LICENSE.md) before downloading or using the runtime. Commercial licensing is intentionally unavailable for Alpha 1 and is planned for Alpha 2 with signed product entitlements. See [COMMERCIAL_USE.md](COMMERCIAL_USE.md).

## Integrity and security

The release checksum manifest is signed with the KatPlay Ed25519 release key. The public-key fingerprint is `SHA256:izX4xT8KNnsRqXiQ9j18CwlW04dUGsprDpoukR7vQeU`. Read [SECURITY.md](SECURITY.md), [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), [KNOWN_ISSUES.md](KNOWN_ISSUES.md) and [docs/VERIFY_RELEASE.md](docs/VERIFY_RELEASE.md) before distribution or security testing.

## Alpha notice

This is an Alpha release. Report reproducible problems, device/OS details and a minimal test file description to `emrebe06@gmail.com`. Do not attach copyrighted audio unless you have permission to share it.
