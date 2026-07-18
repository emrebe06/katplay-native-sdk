from __future__ import annotations

import argparse
import time

from kattplay import NativePlayer


def main() -> None:
    parser = argparse.ArgumentParser(description="Play audio through KatPlay")
    parser.add_argument("library", help="Path to KattPlay DLL or .so")
    parser.add_argument("audio", help="Path to WAV, FLAC or MP3")
    args = parser.parse_args()

    with NativePlayer(args.library) as player:
        print(f"KatPlay {player.version}, ABI {player.abi_version}")
        player.load(args.audio)
        print(f"Duration: {player.duration:.2f} seconds")
        player.play()
        while player.state not in (NativePlayer.FINISHED, NativePlayer.ERROR):
            print(
                f"\r{player.position:8.2f} / {player.duration:8.2f}",
                end="",
                flush=True,
            )
            time.sleep(0.2)
        print()
        if player.state == NativePlayer.ERROR:
            raise RuntimeError(player.last_error)


if __name__ == "__main__":
    main()
