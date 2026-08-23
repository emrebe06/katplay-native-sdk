from __future__ import annotations

import ctypes
from pathlib import Path


class KattPlayError(RuntimeError):
    pass


class OutputStatus(ctypes.Structure):
    _fields_ = [
        ("struct_size", ctypes.c_uint32),
        ("requested_mode", ctypes.c_int32),
        ("active_mode", ctypes.c_int32),
        ("data_path", ctypes.c_int32),
        ("format", ctypes.c_int32),
        ("sharing_mode", ctypes.c_int32),
        ("performance_mode", ctypes.c_int32),
        ("sample_rate", ctypes.c_int32),
        ("channel_count", ctypes.c_int32),
        ("frames_per_burst", ctypes.c_int32),
        ("buffer_size_frames", ctypes.c_int32),
        ("xrun_count", ctypes.c_uint64),
        ("recovery_count", ctypes.c_uint64),
        ("last_recovery_reason", ctypes.c_int32),
    ]


class NativePlayer:
    UNINITIALIZED = 0
    STOPPED = 1
    PLAYING = 2
    PAUSED = 3
    FINISHED = 4
    ERROR = 5
    OUTPUT_AUTO = 0
    OUTPUT_SAFE = 1
    OUTPUT_DIRECT = 2

    def __init__(self, library: str | Path, sample_rate: int = 48_000,
                 channels: int = 2) -> None:
        self._lib = ctypes.CDLL(str(Path(library).resolve()))
        self._bind()
        self._handle = self._lib.kattplay_create(sample_rate, channels)
        if not self._handle:
            raise KattPlayError("kattplay_create returned null")

    def _bind(self) -> None:
        lib = self._lib
        lib.kattplay_abi_version.restype = ctypes.c_uint32
        lib.kattplay_version.restype = ctypes.c_char_p
        lib.kattplay_create.argtypes = [ctypes.c_uint32, ctypes.c_uint16]
        lib.kattplay_create.restype = ctypes.c_void_p
        lib.kattplay_destroy.argtypes = [ctypes.c_void_p]
        lib.kattplay_load.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
        lib.kattplay_load.restype = ctypes.c_int
        lib.kattplay_play.argtypes = [ctypes.c_void_p]
        lib.kattplay_play.restype = ctypes.c_int
        lib.kattplay_recover_output.argtypes = [ctypes.c_void_p]
        lib.kattplay_recover_output.restype = ctypes.c_int
        lib.kattplay_set_output_mode.argtypes = [ctypes.c_void_p, ctypes.c_int]
        lib.kattplay_set_output_mode.restype = ctypes.c_int
        lib.kattplay_get_output_status.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(OutputStatus)
        ]
        lib.kattplay_get_output_status.restype = ctypes.c_int
        lib.kattplay_pause.argtypes = [ctypes.c_void_p]
        lib.kattplay_stop.argtypes = [ctypes.c_void_p]
        lib.kattplay_seek_seconds.argtypes = [ctypes.c_void_p, ctypes.c_double]
        lib.kattplay_seek_seconds.restype = ctypes.c_int
        lib.kattplay_state.argtypes = [ctypes.c_void_p]
        lib.kattplay_state.restype = ctypes.c_int
        lib.kattplay_position_seconds.argtypes = [ctypes.c_void_p]
        lib.kattplay_position_seconds.restype = ctypes.c_double
        lib.kattplay_duration_seconds.argtypes = [ctypes.c_void_p]
        lib.kattplay_duration_seconds.restype = ctypes.c_double
        lib.kattplay_last_error.argtypes = [ctypes.c_void_p]
        lib.kattplay_last_error.restype = ctypes.c_char_p

    @property
    def version(self) -> str:
        return self._lib.kattplay_version().decode("utf-8")

    @property
    def abi_version(self) -> int:
        return int(self._lib.kattplay_abi_version())

    @property
    def state(self) -> int:
        return int(self._lib.kattplay_state(self._handle))

    @property
    def position(self) -> float:
        return float(self._lib.kattplay_position_seconds(self._handle))

    @property
    def duration(self) -> float:
        return float(self._lib.kattplay_duration_seconds(self._handle))

    @property
    def last_error(self) -> str:
        value = self._lib.kattplay_last_error(self._handle)
        return value.decode("utf-8") if value else "Unknown KattPlay error"

    def _require(self, result: int, operation: str) -> None:
        if result == 0:
            raise KattPlayError(f"{operation}: {self.last_error}")

    def load(self, audio_path: str | Path) -> None:
        encoded = str(Path(audio_path).resolve()).encode("utf-8")
        self._require(self._lib.kattplay_load(self._handle, encoded), "load")

    def play(self) -> None:
        self._require(self._lib.kattplay_play(self._handle), "play")

    def pause(self) -> None:
        self._lib.kattplay_pause(self._handle)

    def stop(self) -> None:
        self._lib.kattplay_stop(self._handle)

    def seek(self, seconds: float) -> None:
        self._require(
            self._lib.kattplay_seek_seconds(self._handle, seconds), "seek"
        )

    def recover_output(self) -> None:
        self._require(
            self._lib.kattplay_recover_output(self._handle), "recover_output"
        )

    def set_output_mode(self, mode: int) -> None:
        self._require(
            self._lib.kattplay_set_output_mode(self._handle, mode),
            "set_output_mode",
        )

    def output_status(self) -> OutputStatus:
        status = OutputStatus()
        status.struct_size = ctypes.sizeof(OutputStatus)
        self._require(
            self._lib.kattplay_get_output_status(
                self._handle, ctypes.byref(status)
            ),
            "get_output_status",
        )
        return status

    def close(self) -> None:
        if self._handle:
            self._lib.kattplay_destroy(self._handle)
            self._handle = None

    def __enter__(self) -> "NativePlayer":
        return self

    def __exit__(self, *_: object) -> None:
        self.close()
