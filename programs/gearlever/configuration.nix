{ pkgs, ... }:

{
  # `enable` alone only installs the appimage-run command; `binfmt` is what
  # actually registers the magic-byte handler so AppImages execute through
  # its FHS sandbox (with glib, fuse, etc.) instead of running raw and
  # failing to find libraries NixOS doesn't ship at standard FHS paths.
  programs.appimage = {
    enable = true;
    binfmt = true;

    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        # amixer, so Vibe Typer's AppImage can mute speakers when recording.
        pkgs.alsa-utils
        # libnghttp2, for the libsoup that Unsloth Studio bundles without it.
        pkgs.nghttp2.lib
      ];
    };
  };

  environment.systemPackages = [
    pkgs.gearlever
  ];
}
