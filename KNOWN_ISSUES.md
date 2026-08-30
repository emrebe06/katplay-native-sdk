# Known issues and Alpha limitations

This list applies to KatPlay `0.3.0-alpha.1`.

## Linux output validation

- The Linux x86-64 ELF, C ABI exports and ALSA backend markers have been
  verified, but physical audible playback has not yet been tested on a Linux
  machine.
- PipeWire is reached through its ALSA compatibility layer. Alpha 2 does not
  contain a direct native `libpipewire` backend.
- Selecting a raw ALSA `hw:` device may fail when that device cannot accept the
  requested float format, channel count or sample rate. Prefer the `default`
  PCM unless direct hardware access is required.

## Platform and architecture scope

- Android: arm64-v8a only, API 26 or newer.
- Windows: x86-64 only.
- Linux: x86-64 only.
- macOS, iOS, Windows ARM64, Linux ARM and Android x86/x86-64 binaries are not
  included in Alpha 2.

## Format scope

- Advertised playback formats are WAV, FLAC and MP3.
- AAC is decodable but deliberately not advertised. The native AAC-LC decoder
  is under incremental conformance development and currently handles only a
  narrow slice of the spectral codebooks, so most real-world AAC files are
  rejected with an unsupported-format error rather than played. Do not build on
  it yet. ADTS is the only AAC container recognised; `.m4a`/MP4 is not read.
- Ogg and Opus are not playable. Alpha 3 adds an Ogg container parser, an Opus
  range decoder and the CELT pulse-vector codebook to the engine, but no Opus
  decoder exists yet and no Opus audio can be produced.
- Retuned output is written as FLAC regardless of the source container.
- Unusual, corrupted or deliberately adversarial files have not yet completed
  a broad public fuzzing campaign.

## Application integration

- Android applications still own Audio Focus, MediaSession, notification,
  foreground-service and lifecycle policy. KatPlay owns native decoding,
  transport and audio output.
- KatDirect is a negotiated AAudio preview, not a hardware-bypass promise.
  Active mode may truthfully report KatSafe after fallback, and MMAP remains
  Unknown when Android cannot prove the data path.
- The JavaScript example targets Node.js. A web browser cannot directly load a
  native `.dll` or `.so`.
- ABI 2 retains all ABI 1 entry points, but Alpha APIs may still grow before
  the first stable release.
- `kattplay_retune_file` is a blocking, whole-file operation. It must be called
  from a worker thread; calling it from a UI thread will stall that thread for
  the length of the conversion.

## License scope

- This technical update grants no new commercial or redistribution rights.
- LICENSE.md is authoritative for all permitted and prohibited uses.

Report reproducible issues to `emrebe06@gmail.com` or use the GitHub issue
tracker for non-sensitive bugs. Security issues must follow `SECURITY.md`.
