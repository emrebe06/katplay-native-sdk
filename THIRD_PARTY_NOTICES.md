# Third-party notices

KatPlay's audio decoder, DSP and playback-runtime implementation is developed
independently. The distributed KatPlay runtime binaries do not include or link
against FFmpeg, libavcodec, libavformat, libswresample, LAME, libFLAC,
minimp3, dr_flac or stb_vorbis.

The absence of an FFmpeg dependency does not mean that every byte in a compiled
runtime was authored by KatPlay. Normal operating-system interfaces and C/C++
toolchain runtime components are used as described below.

## Windows build/runtime components

- Microsoft Windows system APIs and libraries, including WASAPI/COM, AVRT and
  the Windows C runtime, are provided by the operating system.
- The Windows runtime is built with GCC/MinGW-w64. GCC runtime and GNU
  libstdc++ portions are statically linked under GPLv3 with the GCC Runtime
  Library Exception 3.1, which permits eligible proprietary target code.
- MinGW-w64 runtime/header components retain their upstream notices and terms.

References:

- GCC Runtime Library Exception: https://gcc.gnu.org/onlinedocs/libstdc++/manual/license.html
- MinGW-w64 licensing material: https://github.com/mingw-w64/mingw-w64/blob/master/COPYING

## Android build/runtime components

- Android system libraries such as AAudio, `libandroid`, `liblog`, Bionic libc
  and `libm` are provided by Android.
- The Android binary is built with Android NDK/LLVM. Static C++ runtime portions
  may include LLVM libc++, libc++abi and libunwind components under the Apache
  License 2.0 with LLVM Exceptions and their upstream notices.

References:

- Android NDK: https://developer.android.com/ndk
- LLVM project license: https://github.com/llvm/llvm-project/blob/main/LICENSE.TXT

## Linux build/runtime components

- The Linux runtime dynamically uses system `libc`, `libm`, `libpthread`,
  `libdl` and `libasound.so.2`.
- The Linux x86-64 release is produced with the Zig/LLVM toolchain. Compiler
  runtime, libc++, libc++abi or libunwind portions included in the resulting
  object retain their upstream licenses and notices.

References:

- Zig: https://ziglang.org/
- LLVM project license: https://github.com/llvm/llvm-project/blob/main/LICENSE.TXT
- ALSA project: https://www.alsa-project.org/

## Integration examples

- The JavaScript example declares Koffi as an npm dependency. Koffi is not
  bundled in the KatPlay SDK archives and is installed separately by the user.
  Koffi is distributed under the MIT License:
  https://www.npmjs.com/package/koffi
- Python `ctypes`, .NET P/Invoke, Android JNI, Kotlin and Java platform APIs are
  used through their normal platform/runtime distributions.

## Audio standards and names

WAV, FLAC and MP3 names identify interoperable formats. KatPlay's copyright and
license cover its original implementation, not third-party standards,
trademarks, patents or platform APIs. Users remain responsible for rights that
may apply to their jurisdiction and use case.

This notice is informational and does not replace the complete upstream license
terms applicable to each component.

