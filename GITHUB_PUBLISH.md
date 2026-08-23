# Publish KatPlay Alpha 2 Preview on GitHub

## Repository settings

- Recommended repository name: `katplay-native-sdk`
- Visibility: `Public`
- Initialize with GitHub README: `No`
- GitHub license template: `None` — this repository uses its own proprietary
  `LICENSE.md`; do not select MIT, Apache, GPL or another template.
- Recommended description:

  `FFmpeg-free native C++ audio runtime for Android, Windows and Linux — WAV, FLAC and MP3 with C ABI and five language integrations.`

- Suggested topics:

  `audio`, `cpp`, `dsp`, `mp3`, `flac`, `wav`, `aaudio`, `wasapi`, `alsa`,
  `pipewire`, `jni`, `native-audio`, `ffmpeg-free`

## Push the repository

Create an empty public repository on GitHub, then run:

```powershell
cd "C:\Users\Emre Demirbaş\Desktop\kat-player"
git init
git branch -M main
git add .
git commit -m "Release KatPlay 0.2.0 Alpha 2 Preview SDK"
git remote add origin https://github.com/<GITHUB_USERNAME>/katplay-native-sdk.git
git push -u origin main
```

The included `.gitignore` keeps runtime binaries, release archives, debug
artifacts and private signing material out of Git history. Never force-add the
private signing key.

## Create the GitHub Release

1. Open `Releases` and choose `Draft a new release`.
2. Create tag `v0.2.0-alpha.1` targeting `main`.
3. Title it `KatPlay 0.2.0 Alpha 2 — KatDirect Preview`.
4. Enable `Set as a pre-release`.
5. Upload these files from the local `release/` directory:

   - `KatPlay-0.2.0-alpha.1-windows-x86_64.zip`
   - `KatPlay-0.2.0-alpha.1-android-arm64-v8a.zip`
   - `KatPlay-0.2.0-alpha.1-linux-x86_64.tar.gz`
   - `KatPlay-0.2.0-alpha.1-integration-examples.zip`
   - `SHA256SUMS-0.2.0-alpha.1.txt`

6. Paste the following release summary:

```text
KatPlay Alpha 2 is a binary-only native C++ audio runtime by Emre Demirbaş.

- Native WAV, FLAC and MP3 playback
- Windows x86-64 WASAPI
- Android arm64-v8a AAudio/JNI with KatDirect/KatSafe negotiation (API 26+)
- Linux x86-64 ALSA with PipeWire ALSA compatibility
- Backward-compatible C ABI 2 plus Kotlin, Java, Python, .NET and Node.js examples
- No FFmpeg runtime or linked binary dependency

This technical update grants no new commercial or redistribution rights.
LICENSE.md is authoritative.

Physical Android route/focus/soak checks and audible Linux playback remain
Alpha validation items.

Verify downloads with SHA256SUMS-0.2.0-alpha.1.txt. The preview manifest is
unsigned until the private KatPlay release key signs it.
```

7. Publish the release as a pre-release.
