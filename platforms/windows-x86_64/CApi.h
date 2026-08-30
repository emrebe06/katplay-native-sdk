#pragma once

#include <stddef.h>
#include <stdint.h>

#if defined(_WIN32)
#define KATTPLAY_CAPI __declspec(dllexport)
#else
#define KATTPLAY_CAPI __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef void* kattplay_handle;

#define KATTPLAY_ABI_VERSION 2u

typedef enum kattplay_output_mode {
    KATTPLAY_OUTPUT_AUTO = 0,
    KATTPLAY_OUTPUT_SAFE = 1,
    KATTPLAY_OUTPUT_DIRECT = 2
} kattplay_output_mode;

typedef enum kattplay_output_data_path {
    KATTPLAY_DATA_PATH_UNKNOWN = 0,
    KATTPLAY_DATA_PATH_LEGACY = 1,
    KATTPLAY_DATA_PATH_MMAP_CONFIRMED = 2
} kattplay_output_data_path;

typedef enum kattplay_recovery_reason {
    KATTPLAY_RECOVERY_NONE = 0,
    KATTPLAY_RECOVERY_MANUAL = 1,
    KATTPLAY_RECOVERY_DEVICE_DISCONNECTED = 2,
    KATTPLAY_RECOVERY_STREAM_ERROR = 3
} kattplay_recovery_reason;

typedef struct kattplay_output_status {
    uint32_t struct_size;
    int32_t requested_mode;
    int32_t active_mode;
    int32_t data_path;
    int32_t format;
    int32_t sharing_mode;
    int32_t performance_mode;
    int32_t sample_rate;
    int32_t channel_count;
    int32_t frames_per_burst;
    int32_t buffer_size_frames;
    uint64_t xrun_count;
    uint64_t recovery_count;
    int32_t last_recovery_reason;
} kattplay_output_status;

KATTPLAY_CAPI uint32_t kattplay_abi_version(void);
KATTPLAY_CAPI const char* kattplay_version(void);

KATTPLAY_CAPI kattplay_handle kattplay_create(uint32_t sample_rate,
                                              uint16_t channels);
KATTPLAY_CAPI void kattplay_destroy(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_load(kattplay_handle handle, const char* utf8_path);
KATTPLAY_CAPI int kattplay_play(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_recover_output(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_set_output_mode(
    kattplay_handle handle, kattplay_output_mode mode);
KATTPLAY_CAPI int kattplay_get_output_status(
    kattplay_handle handle, kattplay_output_status* status);
KATTPLAY_CAPI void kattplay_pause(kattplay_handle handle);
KATTPLAY_CAPI void kattplay_stop(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_seek_seconds(kattplay_handle handle, double seconds);
KATTPLAY_CAPI int kattplay_state(kattplay_handle handle);
KATTPLAY_CAPI double kattplay_position_seconds(kattplay_handle handle);
KATTPLAY_CAPI double kattplay_duration_seconds(kattplay_handle handle);
KATTPLAY_CAPI const char* kattplay_last_error(kattplay_handle handle);

/*
 * Offline retune: decodes input_utf8, shifts it to the given concert-pitch
 * reference and writes output_utf8. The output container follows the output
 * file extension.
 *
 * reference_hz must be between 220 and 880. 440 is the standard reference and
 * leaves pitch untouched. The shift preserves duration, so the result lines up
 * with the source for A/B listening.
 *
 * This is a blocking, whole-file operation and must not be called from an
 * audio or UI thread. It takes no handle and touches no player, so it is safe
 * to run while playback is in progress.
 *
 * Returns 1 on success. On failure it returns 0 and, when error_size is not
 * zero, writes a null-terminated reason into error. Pass NULL and 0 to ignore
 * the message.
 */
KATTPLAY_CAPI int kattplay_retune_file(const char* input_utf8,
                                       const char* output_utf8,
                                       double reference_hz,
                                       char* error,
                                       size_t error_size);

#ifdef __cplusplus
}
#endif
