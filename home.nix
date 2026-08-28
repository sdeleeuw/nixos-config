{ config, pkgs, ... }:

{
  home.username = "sander";
  home.homeDirectory = "/home/sander";

  programs.git = {
    enable = true;
    userName = "Sander de Leeuw";
    userEmail = "s.deleeuw@gmail.com";
  };

  home.stateVersion = "26.05";
}
