{ config, pkgs, ... }:

{
  imports =
    [
      ../../programs/waybar/home.nix
    ];

  home.username = "sander";
  home.homeDirectory = "/home/sander";

  programs.git = {
    enable = true;
    settings.user = {
      name = "Sander de Leeuw";
      email = "s.deleeuw@gmail.com";
    };
  };

  home.stateVersion = "26.05";
}
