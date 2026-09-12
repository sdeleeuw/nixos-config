{ config, pkgs, ... }:

{
  imports =
    [
      ../../programs/hermes-agent/home.nix
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
