# Alpha 2 preview release check

- [x] Backward-compatible C API header, ABI 2
- [x] Auto/KatSafe/KatDirect mode control and output-status snapshot
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
- [x] Existing license included without silently granting new rights
- [x] Changelog, security policy, third-party notices and known-issues list
- [x] Ed25519 release-signing public key and verification guide
- [ ] Alpha 2 checksum manifest signed with the private release key
- [ ] Audible ALSA/PipeWire playback checked on a physical Linux machine
- [ ] KatDirect/KatSafe fallback checked on physical Android devices
- [ ] Android route/focus and long-running soak matrix completed
- [ ] Final public GitHub Release/tag approved by Emre Demirbaş

Windows tests pass and all three platform binaries compile with the expected
architecture and ABI exports. Physical-device checks remain explicit release
gates; this package is an Alpha 2 preview, not a production certification.
