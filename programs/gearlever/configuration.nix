{ pkgs, ... }:

{
  programs.appimage.enable = true;

  environment.systemPackages = [
    pkgs.gearlever
  ];
}
