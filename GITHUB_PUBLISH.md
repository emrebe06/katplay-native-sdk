# Publish KatPlay Alpha 4 on GitHub

## Repository settings

- Repository name: `katplay-native-sdk`
- Visibility: `Public`
- GitHub license template: `None` — this repository uses its own proprietary
  `LICENSE.md`; do not select MIT, Apache, GPL or another template.
- Description:

  `FFmpeg-free native C++ audio runtime for Android, Windows and Linux — WAV, FLAC and MP3 with C ABI and five language integrations.`

- Topics:

  `audio`, `cpp`, `dsp`, `mp3`, `flac`, `wav`, `aaudio`, `wasapi`, `alsa`,
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
.\tools\package_release.ps1 -Version 0.4.0-alpha.1
```

Sign the manifest with the release key (the private key stays outside this
repository and is never committed):

```powershell
ssh-keygen -Y sign -f $HOME\.ssh\katplay-release-ed25519-2026-08 `
    -n katplay-release release\SHA256SUMS-0.4.0-alpha.1.txt
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
git commit -m "Release KatPlay 0.4.0 Alpha 4 SDK"
git push origin main
```

The included `.gitignore` keeps runtime binaries, release archives, debug
artifacts and private signing material out of Git history. Never force-add the
private signing key.

## Create the GitHub Release

1. Open `Releases` and choose `Draft a new release`.
2. Create tag `v0.4.0-alpha.1` targeting `main`.
3. Title it `KatPlay 0.4.0 Alpha 4`.
4. Enable `Set as a pre-release`.
5. Upload these files from the local `release/` directory:

   - `KatPlay-0.4.0-alpha.1-windows-x86_64.zip`
   - `KatPlay-0.4.0-alpha.1-android-arm64-v8a.zip`
   - `KatPlay-0.4.0-alpha.1-linux-x86_64.tar.gz`
   - `KatPlay-0.4.0-alpha.1-integration-examples.zip`
   - `SHA256SUMS-0.4.0-alpha.1.txt`
   - `SHA256SUMS-0.4.0-alpha.1.txt.sig`

6. Paste the release summary below.
7. Publish the release as a pre-release.

```text
KatPlay Alpha 4 is a binary-only native C++ audio runtime by Emre Demirbaş.

Fixes carried by this release:

- Offline retune assumed every source was tuned to A4 = 440 Hz. A mix sitting a
  few cents away landed the same few cents away from the requested target: on
  one test track a 432 Hz request produced 431.8 Hz. The source reference is now
  measured from the audio.
- Retuned output could exceed full scale, because shifting pitch changes the
  waveform and nothing constrained the result before the integer PCM write. A
  true-peak ceiling is now applied, never stricter than the source's own peak,
  and the source's integrated loudness is preserved, so a retune no longer
  re-masters the file.
- Sub-bass broke up on retuned material: the stretch spliced every 22 ms with a
  crossfade shorter than a bass period and a search range narrower than half of
  one, so splices landed out of phase. Measured against a pure-resample
  reference on two tracks, bass fine-structure error fell from 2.1-3.1 dB to
  0.3-0.6 dB with peak level and crest factor preserved.
- The top octave was periodically dulled by the length-fitting interpolation,
  which is gone: the resampler now runs at the exact fractional ratio.
- MP3 files carrying a Xing/Info header decoded one frame of silence at the
  start. Such frames are now recognised as metadata on both decode paths.

New in this release:

- kattplay_retune_file_ex() takes the source concert-pitch reference explicitly;
  0 measures it, which is what kattplay_retune_file() does.
- The retune target range is 110 to 1760 Hz, up from 220 to 880. Pitch accuracy
  measured across that range on a synthetic tone: worst case 0.10 cents.
- Encoded MP3 files carry a Xing/Info header with encoder delay and padding, so
  other decoders can trim them. The header names KatBalance as the encoder;
  decoders that only honour LAME's signature will not trim, and the iTunSMPB tag
  this SDK already wrote is unchanged.
- A 3.5 minute track retunes in 18 s where it previously took 106 s, with
  bit-identical output.

Unchanged: native WAV, FLAC and MP3 playback; Windows WASAPI, Android AAudio
with KatDirect/KatSafe negotiation, Linux ALSA; C ABI 2 with every Alpha 1,
Alpha 2 and Alpha 3 entry point intact; no FFmpeg runtime or linked binary
dependency.

Verification: the full native suite (163 tests) passes on Windows x86-64,
including new regression tests for sub-bass harmonic purity after a retune, for
the absence of a false room tail, for concert-pitch estimation and for chunked
loudness metering matching the single-threaded meter. The Linux and Android
binaries are cross-compiled from the same sources and were not executed on
target hardware for this release.

This technical update grants no new commercial or redistribution rights.
LICENSE.md is authoritative.

AAC, Ogg and Opus are not part of the advertised playback contract; see
KNOWN_ISSUES.md. Physical Android route/focus/soak checks and audible Linux
playback remain Alpha validation items.

Verify downloads with `SHA256SUMS-0.4.0-alpha.1.txt` and its SSH signature
`SHA256SUMS-0.4.0-alpha.1.txt.sig`. The signing-key fingerprint is
`SHA256:KQRIInURMNolBohsw8n9aNTsduSSFokUbad8CAEboWY`.
```
