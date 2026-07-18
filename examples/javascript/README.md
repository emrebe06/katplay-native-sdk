# JavaScript / Node.js example

Node.js does not provide a built-in native C FFI. This example uses the small `koffi` bridge; the audio engine remains KatPlay.

```powershell
npm install
node index.js "..\..\platforms\windows-x86_64\kattplay_runtime.dll" "C:\Music\song.mp3"
```

```bash
npm install
node index.js ../../platforms/linux-x86_64/libkattplay_runtime.so ~/Music/song.flac
```

`koffi` only marshals C calls. It does not decode, process or render audio.
