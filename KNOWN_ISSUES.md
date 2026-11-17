# Known issues and Alpha limitations

This list applies to KatPlay `0.4.2-alpha.1`.

## Linux output validation

- The Linux x86-64 ELF, C ABI exports and ALSA backend markers have been
  verified, but physical audible playback has not yet been tested on a Linux
  machine.
- PipeWire is reached through its ALSA compatibility layer. This release does
  not contain a direct native `libpipewire` backend.
- Selecting a raw ALSA `hw:` device may fail when that device cannot accept the
  requested float format, channel count or sample rate. Prefer the `default`
  PCM unless direct hardware access is required.

## Platform and architecture scope

- Android: arm64-v8a only, API 26 or newer.
- Windows: x86-64 only.
- Linux: x86-64 only.
- macOS, iOS, Windows ARM64, Linux ARM and Android x86/x86-64 binaries are not
  included in this release.

## Format scope

- Advertised playback formats are WAV, FLAC, MP3 and Ogg Opus (CELT-only,
  mono or stereo; see below).
- AAC is decodable but deliberately not advertised. The native AAC-LC decoder
  is under incremental conformance development and currently handles only a
  narrow slice of the spectral codebooks, so most real-world AAC files are
  rejected with an unsupported-format error rather than played. Do not build on
  it yet. ADTS is the only AAC container recognised; `.m4a`/MP4 is not read.
- Opus is decoded for CELT-only streams. Streams containing SILK or hybrid
  packets are refused at load with an unsupported-format error rather than
  played with gaps. Encoders produce those packets for speech and at low
  bitrates: libopus used them for stereo at 24 and 32 kbps in our
  tests, and plain CELT for music at 96 kbps and above. Voice recordings and low-bitrate
  podcasts are therefore likely to be refused.
- Opus with more than two channels (mapping family 1 beyond stereo, or any
  multistream layout) is refused. `.ogg` files that hold Vorbis rather than
  Opus are not playable.
- Opus frames of zero or one byte (discontinuous transmission or lost frames)
  decode as silence; there is no packet-loss concealment.
- Opus is decode-only. A retune can read an Opus file but cannot write one.
- Opus decoder overshoot above full scale is soft-limited between zero
  crossings, not passed through. libopus' float decoder uses a different
  curve, so on brickwalled masters the two differ in those peaks (50-55 dB SNR
  on one test song, against 66-71 dB elsewhere).
- An Opus seek decodes 80 ms before the target from a fresh state, as
  RFC 7845 recommends. The first few milliseconds after a seek therefore
  differ slightly from a straight-through decode.
- An Opus file is read into memory whole (its compressed size, not PCM) when
  it is loaded and again on each seek.
- A retune writes the container its output file extension names. The encoders
  available are WAV, FLAC, MP3, AIFF, AU and raw PCM; playback of the result is
  only advertised for WAV, FLAC and MP3.
- A retune measures the source's concert pitch from the audio. On material
  whose own tuning drifts between sections, two measurements of the same track
  can differ by a cent or two; pass the reference explicitly through
  `kattplay_retune_file_ex` when it is known.
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
