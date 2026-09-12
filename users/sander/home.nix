{ config, pkgs, ... }:

{
  imports =
    [
      ../../desktops/noctalia/home.nix
      ../../programs/hermes-agent/home.nix
      ../../programs/hyprland/home.nix
      ../../programs/kitty/home.nix
    ];

  home.username = "sander";
  home.homeDirectory = "/home/sander";

  home.file.".wallpapers" = {
    source = ../../wallpapers;
    recursive = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Sander de Leeuw";
      email = "s.deleeuw@gmail.com";
    };
  };

  home.stateVersion = "26.05";
}
