# Changelog

All notable KatPlay SDK changes are recorded here. KatPlay is currently in
Alpha; ABI and behavior may change before the first stable release.

## [0.4.0-alpha.1] - 2026-09-20

### Fixed

- Offline retune assumed every source was tuned to A4 = 440 Hz. A mix that sits
  a few cents away from that landed the same few cents away from the requested
  target: on one test track a 432 Hz request produced 431.8 Hz. The source's own
  reference is now measured from the audio, and the shift is computed from the
  measurement.
- Retuned output could exceed full scale. Shifting pitch changes the waveform
  and therefore its peaks, and nothing constrained them before the integer PCM
  write. A true-peak ceiling is now applied, never stricter than the source's
  own peak level, and the source's integrated loudness is preserved so a retune
  no longer re-masters the file.
- Sub-bass broke up on retuned material. The time-domain stretch spliced every
  22 ms with a crossfade shorter than a bass period and a search range narrower
  than half of one, so splices landed out of phase and sprayed sidebands under
  the bass. Segments, crossfade and search range were re-tuned against a
  varispeed (pure resample) reference: bass fine-structure error on two test
  tracks fell from 2.1-3.1 dB to 0.3-0.6 dB, with peak level and crest factor
  preserved.
- The top octave was dulled periodically. The output length was fitted with a
  drifting linear interpolation whose response sweeps through a comb null; the
  resampler now runs at the exact fractional ratio and no fitting pass remains.
- MP3 files carrying a Xing/Info header decoded one frame of silence at the
  start, because the header frame was decoded as audio. Such frames are now
  recognised as metadata on both the buffered and streaming paths.

### Added

- `kattplay_retune_file_ex()` takes the source concert-pitch reference
  explicitly; `0` measures it, which is what `kattplay_retune_file()` does.
- The retune target range is now 110 to 1760 Hz, two octaves either side of
  the source, instead of 220 to 880. Pitch accuracy measured across that range
  on a synthetic tone: worst case 0.10 cents.
- Encoded MP3 files carry a Xing/Info header with the encoder delay and end
  padding, so other decoders can trim them exactly. The header names KatBalance
  as the encoder. Decoders that only honour LAME's signature will still not
  trim; the ID3 `iTunSMPB` tag this SDK already wrote is unchanged, and this
  SDK's own decode was and remains sample-exact.
- MP3 output keeps 1 dB of true-peak headroom, since lossy decoding overshoots
  the encoded peak (measured +0.34 dBFS at 320 kbps).

### Performance

- A 3.5 minute track retunes in 18 s where it previously took 106 s, with
  bit-identical output. The true-peak oversampler is now polyphase over
  contiguous history instead of zero-stuffed convolution with two modulo
  operations per tap, the limiter's lookahead maximum is O(1) per sample
  instead of a full window scan, loudness metering splits across cores on the
  gating grid, and the splice search runs through the SIMD dot product.

### Compatibility

- ABI 2 is unchanged. `kattplay_retune_file` keeps its signature;
  `kattplay_retune_file_ex` is a new symbol. Its behaviour changes as described
  above: the source reference is measured rather than assumed, and a true-peak
  ceiling is applied to the result.
- Alpha 1, Alpha 2 and Alpha 3 tags and release history remain intact.

### Verification

- The full native test suite passes on Windows x86-64: 163 tests, including new
  regression tests for sub-bass harmonic purity after a retune, for the absence
  of a false room tail, for concert-pitch estimation, and for chunked loudness
  metering matching the single-threaded meter.
- Retune quality was measured against a varispeed reference on two commercial
  tracks; the numbers above are from those measurements.
- The Linux and Android binaries are cross-compiled from the same sources and
  were not executed on target hardware for this release.

## [0.3.0-alpha.1] - 2026-08-29

### Fixed

- MP3 gapless delay and padding were never applied on the streaming decode
  path. The values live in the ID3v2 tag, which the incremental frame reader
  skipped on its way to the first audio frame, so gapless metadata was reported
  as absent and nothing was trimmed. Streamed output therefore carried one
  frame more than the buffered decode of the same file. Alpha 2 advertised this
  behaviour; it now holds on both paths.
- AAC ADTS streaming rebuilt its IMDCT overlap state for every packet, so each
  frame was overlap-added against silence instead of the previous frame's tail.
  Streamed AAC now matches the buffered decode sample for sample.
- The incremental frame reader and the buffered parser disagreed on ID3v2 tag
  length: the reader counted a footer without requiring tag version 4. Both now
  interpret the same tag identically, which matters because they read the same
  gapless values.

### Added

- `kattplay_retune_file()` converts a file to a different concert-pitch
  reference offline and writes the result as FLAC. Pitch shifts by
  12*log2(reference/440) semitones with duration held constant, so the output
  lines up in time with its source. The call takes no handle, does not touch
  the player, and reports failures through a caller-supplied buffer rather than
  shared state.
- AAC (ADTS) is reachable through the native container dispatch. It stays
  unadvertised: the decoder handles only a narrow slice of the spectral
  codebooks and rejects most real-world files. See `KNOWN_ISSUES.md`.

### Compatibility

- ABI 2 is unchanged. `kattplay_retune_file` is a new symbol; every existing
  entry point keeps its signature and behaviour.
- Alpha 1 and Alpha 2 tags and release history remain intact.

### Verification

- The full native test suite passes on Windows x86-64.
- The same suite passes with runtime SIMD dispatch disabled, which checks the
  scalar fallbacks against the vector paths.
- The same suite was executed on ARM64 hardware, with the active dispatch level
  confirmed to be NEON rather than a scalar fallback. Alpha 2 could only state
  that the ARM64 code compiled.
- Streaming and buffered decode are now compared against each other by test for
  both AAC and MP3, which is what the two fixes above were missing.
- Physical Android route/focus/soak checks and audible Linux playback remain
  Alpha validation items, unchanged from Alpha 2.

## [0.2.0-alpha.1] - 2026-08-23

### Added

- ABI 2 output control with Auto, KatSafe and KatDirect modes.
- Truthful output-status snapshots for negotiated format, sharing mode,
  performance mode, buffer geometry, xruns and recovery history.
- Android KatDirect preview with exclusive/low-latency AAudio negotiation and
  ordered KatSafe fallback.
- JNI/Kotlin output-mode and Output Inspector bindings.
- Current KatBalance WAV, FLAC and MP3 codec core, including MP3 gapless
  delay/padding behavior.

### Compatibility

- All ABI 1 lifecycle and transport entry points remain present.
- Existing callers work without using the new ABI 2 functions and receive the
  safe automatic output policy.
- Alpha 1 was not renamed or moved into a legacy tree; its Git tag and release
  history remain intact.

### Verification

- Windows x86-64 native runtime tests passed.
- Windows x86-64, Android ARM64/API 26 and Linux x86-64 runtimes compiled.
- Android AArch64 and Linux x86-64 ELF architecture/export tables were checked.
- Physical Android route, focus and long-running soak tests remain required
  before calling this preview production-ready.

## [0.1.0-alpha.1] - 2026-07-18

### Added

- Initial binary-only KatPlay Native Runtime SDK release.
- Native WAV, FLAC and MP3 playback paths without an FFmpeg runtime or linked
  binary dependency.
- Windows x86-64 WASAPI shared/event-driven float PCM runtime.
- Android arm64-v8a AAudio/JNI runtime for API 26 and newer.
- Linux x86-64 ALSA float PCM runtime with PipeWire routing through the ALSA
  compatibility layer.
- Stable public C API version 1.
- Kotlin and Java JNI integration examples.
- Python `ctypes`, .NET P/Invoke and Node.js/Koffi integration examples.
- Per-platform SHA-256 checksums and an Ed25519 SSH release signature.
- Alpha 1 personal and non-commercial license.

### Security and packaging

- Release binaries are stripped of engine source and debug artifacts.
- Windows GCC/MinGW runtime components are linked into the runtime package;
  no extra non-system runtime DLL is required.
- Linux loads `libasound.so.2` dynamically.
- Android exports only the intended JNI/C ABI surface through its version
  script.

### Known limitations

- Linux physical ALSA/PipeWire playback has not yet been audibly validated on
  a physical Linux installation.
- AAC is not part of the advertised Alpha 1 playback scope.
- Only the architectures listed in `docs/PLATFORM_SUPPORT.md` are packaged.
- Alpha 1 does not grant commercial, organizational or redistribution rights.

See `KNOWN_ISSUES.md` for the current detailed limitation list.
