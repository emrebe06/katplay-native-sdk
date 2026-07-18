# KatPlay C API — ABI 1

Include `include/kattplay/CApi.h` and load the platform runtime:

- Windows: `kattplay_runtime.dll`
- Linux: `libkattplay_runtime.so`
- Android: use the supplied JNI wrapper and `libkattplay.so`

## Lifecycle

```text
kattplay_create
  -> kattplay_load
  -> kattplay_play / pause / seek / stop
  -> kattplay_destroy
```

`kattplay_create(sample_rate, channels)` creates an opaque handle. Use 48000 Hz and 2 channels as a portable default. A non-null handle can still contain an initialization error when no platform output is available; the next operation returns failure and `kattplay_last_error` explains why.

Every successful `kattplay_create` must be paired with exactly one `kattplay_destroy`. Do not use a handle after destruction.

## Return rules

- `kattplay_load`, `kattplay_play`, `kattplay_recover_output` and `kattplay_seek_seconds`: `1` success, `0` failure.
- `kattplay_last_error`: UTF-8 message owned by the handle; copy it before the next control operation.
- `kattplay_state`: playback state as an integer.
- `kattplay_position_seconds` / `kattplay_duration_seconds`: seconds as `double`.

## Playback states

| Value | Meaning |
|---:|---|
| 0 | Uninitialized |
| 1 | Stopped |
| 2 | Playing |
| 3 | Paused |
| 4 | Finished |
| 5 | Error |

## ABI policy

Call `kattplay_abi_version()` before advanced integration. This package exposes ABI `1`. A future incompatible C interface must increment that number. `kattplay_version()` returns the human-readable engine version.

## Threading

KatPlay performs decode and device rendering on internal native threads. The application should serialize lifecycle and transport calls on one control thread. State, position and duration may be polled by the UI. Never destroy a handle while another application thread is using it.

## Output recovery

After a device route or stream failure, call `kattplay_recover_output(handle)`. On Android, audio focus and wired/Bluetooth route policy remain the responsibility of the application/service layer; the native runtime reopens the device while preserving playback position.
