# Known issues and Alpha limitations

This list applies to KatPlay `0.1.0-alpha.1`.

## Linux output validation

- The Linux x86-64 ELF, C ABI exports and ALSA backend markers have been
  verified, but physical audible playback has not yet been tested on a Linux
  machine.
- PipeWire is reached through its ALSA compatibility layer. Alpha 1 does not
  contain a direct native `libpipewire` backend.
- Selecting a raw ALSA `hw:` device may fail when that device cannot accept the
  requested float format, channel count or sample rate. Prefer the `default`
  PCM unless direct hardware access is required.

## Platform and architecture scope

- Android: arm64-v8a only, API 26 or newer.
- Windows: x86-64 only.
- Linux: x86-64 only.
- macOS, iOS, Windows ARM64, Linux ARM and Android x86/x86-64 binaries are not
  included in Alpha 1.

## Format scope

- Advertised playback formats are WAV, FLAC and MP3.
- AAC/M4A, OGG and Opus are not part of the public Alpha 1 playback contract.
- Unusual, corrupted or deliberately adversarial files have not yet completed
  a broad public fuzzing campaign.

## Application integration

- Android applications still own Audio Focus, MediaSession, notification,
  foreground-service and lifecycle policy. KatPlay owns native decoding,
  transport and audio output.
- The JavaScript example targets Node.js. A web browser cannot directly load a
  native `.dll` or `.so`.
- Alpha 1 does not promise stable ABI compatibility with future Alpha builds,
  although this package reports C ABI version 1.

## License scope

- Alpha 1 is limited to personal, non-commercial use by individual natural
  persons.
- Company use, client work, monetization, public beta/store distribution and
  embedding in a publicly distributed product are not licensed.
- Signed commercial product entitlements are planned for Alpha 2.

Report reproducible issues to `emrebe06@gmail.com` or use the GitHub issue
tracker for non-sensitive bugs. Security issues must follow `SECURITY.md`.

