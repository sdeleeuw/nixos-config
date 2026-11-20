{ pkgs, ... }:

{
  # Ships both the ffmpeg and ffprobe binaries.
  environment.systemPackages = [
    pkgs.ffmpeg
  ];
}
