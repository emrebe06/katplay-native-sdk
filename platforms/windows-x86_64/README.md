# Windows x86-64 runtime

Files:

- `kattplay_runtime.dll` — KatPlay C ABI runtime, WASAPI output.
- `CApi.h` — ABI 2 public header; ABI 1 transport calls remain available.
- `SHA256SUMS.txt` — package file checksums.

Put the DLL beside your executable or pass its absolute path to Python/Node integration. Supported playback formats: WAV, FLAC, MP3 and Ogg Opus (CELT-only).

License: this update grants no new commercial or redistribution rights. Read the `LICENSE.md` included at the archive root.
