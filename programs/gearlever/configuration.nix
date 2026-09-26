{ pkgs, ... }:

{
  # `enable` alone only installs the appimage-run command; `binfmt` is what
  # actually registers the magic-byte handler so AppImages execute through
  # its FHS sandbox (with glib, fuse, etc.) instead of running raw and
  # failing to find libraries NixOS doesn't ship at standard FHS paths.
  programs.appimage = {
    enable = true;
    binfmt = true;

    # Add amixer so Vibe Typer's AppImage can mute speakers when recording.
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [ pkgs.alsa-utils ];
    };
  };

  environment.systemPackages = [
    pkgs.gearlever
  ];
}
