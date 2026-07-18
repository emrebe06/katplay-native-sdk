# Alpha 1 release check

- [x] Stable C API header, ABI 1
- [x] Windows x86-64 WASAPI runtime
- [x] Android arm64-v8a AAudio/JNI runtime
- [x] Linux x86-64 ALSA/PipeWire-compatible runtime rebuilt from the current backend source
- [x] Kotlin example
- [x] Java example
- [x] Python example
- [x] .NET example
- [x] JavaScript example
- [x] Per-platform checksums
- [x] No engine `.cpp`/`.hpp`, static library or build directory in the public SDK
- [x] Alpha 1 personal/non-commercial license selected and included
- [x] Commercial and organizational use explicitly reserved for Alpha 2 terms
- [x] Changelog, security policy, third-party notices and known-issues list
- [x] Ed25519 release-signing public key and verification guide
- [ ] Audible ALSA/PipeWire playback checked on a physical Linux machine
- [ ] Final public GitHub Release/tag approved by Emre Demirbaş

The Linux ELF is present and its x86-64 architecture, ABI exports and ALSA backend markers are verified. Colab/CI can verify headless codec/transport behavior; audible output must still be checked on a physical Linux machine.
