using KattPlaySample;

if (args.Length != 1)
{
    Console.Error.WriteLine("Usage: KattPlaySample <audio.wav|audio.flac|audio.mp3>");
    return 2;
}

using var player = new NativePlayer();
Console.WriteLine($"KatPlay {NativePlayer.Version}, ABI {NativePlayer.AbiVersion}");
player.Load(Path.GetFullPath(args[0]));
Console.WriteLine($"Duration: {player.DurationSeconds:F2} seconds");
player.Play();

while (player.State is not NativePlayer.PlaybackState.Finished and
       not NativePlayer.PlaybackState.Error)
{
    Console.Write($"\r{player.PositionSeconds,8:F2} / {player.DurationSeconds,8:F2}");
    Thread.Sleep(200);
}

Console.WriteLine();
if (player.State == NativePlayer.PlaybackState.Error)
{
    Console.Error.WriteLine(player.LastError);
    return 1;
}

return 0;
