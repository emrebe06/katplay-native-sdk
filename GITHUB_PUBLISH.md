# Publish KatPlay Alpha 3 on GitHub

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
git commit -m "Release KatPlay 0.3.0 Alpha 3 SDK"
git remote add origin https://github.com/<GITHUB_USERNAME>/katplay-native-sdk.git
git push -u origin main
```

The included `.gitignore` keeps runtime binaries, release archives, debug
artifacts and private signing material out of Git history. Never force-add the
private signing key.

## Create the GitHub Release

1. Open `Releases` and choose `Draft a new release`.
2. Create tag `v0.3.0-alpha.1` targeting `main`.
3. Title it `KatPlay 0.3.0 Alpha 3`.
4. Enable `Set as a pre-release`.
5. Upload these files from the local `release/` directory:

   - `KatPlay-0.3.0-alpha.1-windows-x86_64.zip`
   - `KatPlay-0.3.0-alpha.1-android-arm64-v8a.zip`
   - `KatPlay-0.3.0-alpha.1-linux-x86_64.tar.gz`
   - `KatPlay-0.3.0-alpha.1-integration-examples.zip`
   - `SHA256SUMS-0.3.0-alpha.1.txt`

6. Paste the following release summary:

```text
KatPlay Alpha 3 is a binary-only native C++ audio runtime by Emre Demirbaş.

Fixes carried by this release:

- MP3 gapless delay and padding are now applied on the streaming decode path.
  The values live in the ID3v2 tag, which the incremental reader skipped, so
  streamed output previously carried one frame more than the buffered decode.
  Alpha 2 advertised this behaviour; it now holds on both paths.
- AAC streaming no longer rebuilds its IMDCT overlap per packet, so frames are
  overlap-added with the previous frame's tail instead of silence.
- The incremental reader and the buffered parser now agree on ID3v2 tag length.

New in this release:

- kattplay_retune_file() converts a file to a different concert-pitch
  reference offline, preserving duration. It takes no handle and does not
  disturb playback.

Unchanged: native WAV, FLAC and MP3 playback; Windows WASAPI, Android AAudio
with KatDirect/KatSafe negotiation, Linux ALSA; C ABI 2 with every Alpha 1 and
Alpha 2 entry point intact; no FFmpeg runtime or linked binary dependency.

The codec core is now verified on ARM64 hardware with the NEON dispatch level
confirmed active, not merely compiled for it.

This technical update grants no new commercial or redistribution rights.
LICENSE.md is authoritative.

AAC, Ogg and Opus are not part of the advertised playback contract; see
KNOWN_ISSUES.md. Physical Android route/focus/soak checks and audible Linux
playback remain Alpha validation items.

Verify downloads with SHA256SUMS-0.3.0-alpha.1.txt. The manifest is unsigned
until the private KatPlay release key signs it.
```

7. Publish the release as a pre-release.
