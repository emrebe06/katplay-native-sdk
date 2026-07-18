# Linux x86-64 runtime

Files:

- `libkattplay_runtime.so` — KatPlay C ABI runtime.
- `CApi.h` — ABI 1 public header.
- `SHA256SUMS.txt` — package file checksums.

The backend writes interleaved float PCM to ALSA. On PipeWire systems, install the PipeWire ALSA compatibility plugin so the `default` ALSA PCM routes into PipeWire. Set `KATTPLAY_ALSA_DEVICE` to override the PCM name.

Runtime requirement: `libasound.so.2`. It is loaded dynamically, so it will not appear as a direct `ldd` dependency.

License: Alpha 1 is limited to free personal, non-commercial use. Company use, public redistribution and product embedding require rights that are not offered for Alpha 1. Read the `LICENSE.md` included at the archive root.
