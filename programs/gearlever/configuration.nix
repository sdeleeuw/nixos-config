{ pkgs, ... }:

{
  # `enable` alone only installs the appimage-run command; `binfmt` is what
  # actually registers the magic-byte handler so AppImages execute through
  # its FHS sandbox (with glib, fuse, etc.) instead of running raw and
  # failing to find libraries NixOS doesn't ship at standard FHS paths.
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = [
    pkgs.gearlever
  ];
}
