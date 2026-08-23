# KatPlay C API — ABI 2

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

## Output modes and diagnostics

ABI 2 adds kattplay_set_output_mode and kattplay_get_output_status. Initialize
kattplay_output_status.struct_size to sizeof(kattplay_output_status) before
calling the snapshot function.

KATTPLAY_OUTPUT_AUTO tries the best supported native path.
KATTPLAY_OUTPUT_DIRECT requests KatDirect but safely falls back when the device
rejects it. Always inspect active_mode: a request is not proof that the direct
path opened. KATTPLAY_OUTPUT_SAFE explicitly selects the shared, compatible
path.

The snapshot reports negotiated sample rate, channel count, PCM format,
sharing/performance modes, frames per burst, buffer size, xruns, recovery count
and last recovery reason. KATTPLAY_DATA_PATH_MMAP_CONFIRMED is emitted only
when the runtime can prove MMAP use; otherwise the value remains UNKNOWN or
LEGACY.

Changing mode rebuilds the output while preserving the loaded source, position
and paused/playing intent. It is a control-thread operation, not an
audio-callback operation.

## ABI policy

Call kattplay_abi_version() before advanced integration. This package exposes
ABI 2; all ABI 1 functions remain available. A future incompatible C interface
must increment that number. kattplay_version() returns the human-readable
engine version.

## Threading

KatPlay performs decode and device rendering on internal native threads. The application should serialize lifecycle and transport calls on one control thread. State, position and duration may be polled by the UI. Never destroy a handle while another application thread is using it.

## Output recovery

After a device route or stream failure, call `kattplay_recover_output(handle)`. On Android, audio focus and wired/Bluetooth route policy remain the responsibility of the application/service layer; the native runtime reopens the device while preserving playback position.
