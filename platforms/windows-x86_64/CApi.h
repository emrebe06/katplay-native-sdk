#pragma once

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

#define KATTPLAY_ABI_VERSION 1u

KATTPLAY_CAPI uint32_t kattplay_abi_version(void);
KATTPLAY_CAPI const char* kattplay_version(void);

KATTPLAY_CAPI kattplay_handle kattplay_create(uint32_t sample_rate,
                                              uint16_t channels);
KATTPLAY_CAPI void kattplay_destroy(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_load(kattplay_handle handle, const char* utf8_path);
KATTPLAY_CAPI int kattplay_play(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_recover_output(kattplay_handle handle);
KATTPLAY_CAPI void kattplay_pause(kattplay_handle handle);
KATTPLAY_CAPI void kattplay_stop(kattplay_handle handle);
KATTPLAY_CAPI int kattplay_seek_seconds(kattplay_handle handle, double seconds);
KATTPLAY_CAPI int kattplay_state(kattplay_handle handle);
KATTPLAY_CAPI double kattplay_position_seconds(kattplay_handle handle);
KATTPLAY_CAPI double kattplay_duration_seconds(kattplay_handle handle);
KATTPLAY_CAPI const char* kattplay_last_error(kattplay_handle handle);

#ifdef __cplusplus
}
#endif
