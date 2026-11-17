# Publish KatPlay 0.4.2 on GitHub

## Repository settings

- Repository name: `katplay-native-sdk`
- Visibility: `Public`
- GitHub license template: `None` — this repository uses its own proprietary
  `LICENSE.md`; do not select MIT, Apache, GPL or another template.
- Description:

  `FFmpeg-free native C++ audio runtime for Android, Windows and Linux — WAV, FLAC, MP3 and Opus with C ABI and five language integrations.`

- Topics:

  `audio`, `cpp`, `dsp`, `mp3`, `flac`, `wav`, `opus`, `aaudio`, `wasapi`, `alsa`,
  `pipewire`, `jni`, `native-audio`, `ffmpeg-free`

## Build and package

The runtimes are built from the KattPlay tree beside this folder, which pulls
in the KatBalance engine sources:

```powershell
cmake -S <kattplay> -B <kattplay>\build_a4_win -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake -S <kattplay> -B <kattplay>\build_a4_linux -G Ninja -DCMAKE_BUILD_TYPE=Release `
      -DCMAKE_TOOLCHAIN_FILE=<kattplay>/tools/zig-linux-x86_64.cmake
cmake -S <kattplay> -B <kattplay>\build_a4_android -G Ninja -DCMAKE_BUILD_TYPE=Release `
      -DCMAKE_TOOLCHAIN_FILE=<ndk>/build/cmake/android.toolchain.cmake `
      -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-26
```

Then assemble the archives and checksums:

```powershell
.\tools\package_release.ps1 -Version 0.4.2-alpha.1
```

Sign the manifest with the release key (the private key stays outside this
repository and is never committed):

```powershell
ssh-keygen -Y sign -f $HOME\.ssh\katplay-release-ed25519-2026-08 `
    -n katplay-release release\SHA256SUMS-0.4.2-alpha.1.txt
```

The namespace must be `katplay-release`: it is what `docs/VERIFY_RELEASE.md`
tells downloaders to check, and a signature made under another namespace fails
verification even though the key is right.

Smoke-test the packaged Windows runtime before publishing:

```powershell
.\tools\smoke_retune.ps1 -Source <some.wav> -Target 432
```

## Push the repository

```powershell
cd "C:\Users\Emre Demirbaş\Desktop\kat-player"
git add .
git commit -m "Release KatPlay 0.4.2 SDK"
git push origin main
```

The included `.gitignore` keeps runtime binaries, release archives, debug
artifacts and private signing material out of Git history. Never force-add the
private signing key.

## Create the GitHub Release

1. Open `Releases` and choose `Draft a new release`.
2. Create tag `v0.4.2-alpha.1` targeting `main`.
3. Title it `KatPlay 0.4.2`.
4. Enable `Set as a pre-release`.
5. Upload these files from the local `release/` directory:

   - `KatPlay-0.4.2-alpha.1-windows-x86_64.zip`
   - `KatPlay-0.4.2-alpha.1-android-arm64-v8a.zip`
   - `KatPlay-0.4.2-alpha.1-linux-x86_64.tar.gz`
   - `KatPlay-0.4.2-alpha.1-integration-examples.zip`
   - `SHA256SUMS-0.4.2-alpha.1.txt`
   - `SHA256SUMS-0.4.2-alpha.1.txt.sig`

6. Paste the release summary below.
7. Publish the release as a pre-release.

```text
KatPlay 0.4.2 is a binary-only native C++ audio runtime by Emre Demirbaş.

New in this release:

- Ogg Opus playback. .opus and .ogg files, and extensionless descriptor paths
  such as Android's /proc/self/fd/<n>, play through a native fixed-point CELT
  decoder written from RFC 6716, RFC 7845 and RFC 8251. Playback streams like
  MP3 and FLAC, and a seek restarts the decoder 80 ms before the target rather
  than from the start of the file. Compared with libopus' own decoder on
  synthetic tones and two songs encoded at 96-192 kbps: identical length,
  66-71 dB SNR. The CELT layer matches the RFC 6716 fixed-point reference
  decoder's PCM bit for bit on the RFC 8251 conformance vectors.
- Opus files are accepted as offline retune input.

Fixes:

- WAV streaming playback read 8-bit PCM, 20-bit-in-24 PCM and 64-bit float
  files wrongly or not at all. Samples are now read by container width, and
  unsupported bit depths are refused when the file is opened.
- Lossy decoding overshoots full scale on loud masters (one test song reached
  1.39). Opus output bends each excursion onto full scale between its zero
  crossings instead of clipping it flat.

Opus scope: CELT-only streams, mono or stereo. Streams with SILK or hybrid
packets, which encoders use for speech and at low bitrates (libopus did so for
stereo at 24 and 32 kbps in our tests), and streams with more than two channels
are refused at load with an unsupported-format error. Opus cannot be written.
See KNOWN_ISSUES.md.

Unchanged: WAV, FLAC and MP3 playback; Windows WASAPI, Android AAudio with
KatDirect/KatSafe negotiation, Linux ALSA; C ABI 2 with every earlier entry
point intact; no FFmpeg runtime or linked binary dependency.

Verification: the native engine suite (187 tests) and the KattPlay runtime
tests pass on Windows x86-64, including Opus streaming, seeking, descriptor
sniffing and refusal of hybrid streams. 4,500 mutated Opus files decoded under
UndefinedBehaviorSanitizer without a crash or an out-of-range sample. The Linux
and Android binaries are cross-compiled from the same sources and were not
executed on target hardware for this release.

This technical update grants no new commercial or redistribution rights.
LICENSE.md is authoritative.

AAC is not part of the advertised playback contract. Physical Android
route/focus/soak checks and audible Linux playback remain Alpha validation
items.

Verify downloads with `SHA256SUMS-0.4.2-alpha.1.txt` and its SSH signature
`SHA256SUMS-0.4.2-alpha.1.txt.sig`. The signing-key fingerprint is
`SHA256:KQRIInURMNolBohsw8n9aNTsduSSFokUbad8CAEboWY`.
```
