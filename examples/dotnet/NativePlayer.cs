using System.Runtime.InteropServices;

namespace KattPlaySample;

public sealed class NativePlayer : IDisposable
{
    public enum PlaybackState
    {
        Uninitialized = 0,
        Stopped = 1,
        Playing = 2,
        Paused = 3,
        Finished = 4,
        Error = 5
    }

    private const string Library = "kattplay_runtime";
    private nint _handle;

    public NativePlayer(uint sampleRate = 48_000, ushort channels = 2)
    {
        _handle = Native.kattplay_create(sampleRate, channels);
        if (_handle == 0) throw new InvalidOperationException("kattplay_create returned null");
    }

    public static uint AbiVersion => Native.kattplay_abi_version();
    public static string Version => Utf8(Native.kattplay_version());
    public PlaybackState State => (PlaybackState)Native.kattplay_state(RequireHandle());
    public double PositionSeconds => Native.kattplay_position_seconds(RequireHandle());
    public double DurationSeconds => Native.kattplay_duration_seconds(RequireHandle());
    public string LastError => Utf8(Native.kattplay_last_error(RequireHandle()));

    public void Load(string path) => Require(
        Native.kattplay_load(RequireHandle(), path), "load");
    public void Play() => Require(Native.kattplay_play(RequireHandle()), "play");
    public void RecoverOutput() => Require(
        Native.kattplay_recover_output(RequireHandle()), "recover output");
    public void Pause() => Native.kattplay_pause(RequireHandle());
    public void Stop() => Native.kattplay_stop(RequireHandle());
    public void Seek(double seconds) => Require(
        Native.kattplay_seek_seconds(RequireHandle(), seconds), "seek");

    private nint RequireHandle() => _handle != 0
        ? _handle
        : throw new ObjectDisposedException(nameof(NativePlayer));

    private void Require(int result, string operation)
    {
        if (result == 0) throw new InvalidOperationException($"KatPlay {operation}: {LastError}");
    }

    private static string Utf8(nint pointer) =>
        Marshal.PtrToStringUTF8(pointer) ?? string.Empty;

    public void Dispose()
    {
        if (_handle == 0) return;
        Native.kattplay_destroy(_handle);
        _handle = 0;
        GC.SuppressFinalize(this);
    }

    private static class Native
    {
        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern uint kattplay_abi_version();

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern nint kattplay_version();

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern nint kattplay_create(uint sampleRate, ushort channels);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern void kattplay_destroy(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern int kattplay_load(
            nint handle,
            [MarshalAs(UnmanagedType.LPUTF8Str)] string path);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern int kattplay_play(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern int kattplay_recover_output(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern void kattplay_pause(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern void kattplay_stop(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern int kattplay_seek_seconds(nint handle, double seconds);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern int kattplay_state(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern double kattplay_position_seconds(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern double kattplay_duration_seconds(nint handle);

        [DllImport(Library, CallingConvention = CallingConvention.Cdecl)]
        internal static extern nint kattplay_last_error(nint handle);
    }
}
