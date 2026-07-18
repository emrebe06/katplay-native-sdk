# Python example

Python uses only the standard-library `ctypes` module.

```powershell
python play.py "..\..\platforms\windows-x86_64\kattplay_runtime.dll" "C:\Music\song.mp3"
```

```bash
python3 play.py ../../platforms/linux-x86_64/libkattplay_runtime.so ~/Music/song.flac
```

The example waits until the state becomes `Finished` or `Error`. Press Ctrl+C to stop and destroy the native handle safely.
