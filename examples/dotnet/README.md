# .NET / C# example

Requires .NET 8 or newer.

Copy the native runtime beside the executable after building:

```powershell
dotnet build -c Release
Copy-Item ..\..\platforms\windows-x86_64\kattplay_runtime.dll bin\Release\net8.0\
dotnet run -c Release -- "C:\Music\song.mp3"
```

Linux uses `libkattplay_runtime.so`; copy it beside the application and run with `LD_LIBRARY_PATH` pointing at that directory when necessary.
