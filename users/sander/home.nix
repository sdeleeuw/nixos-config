{ config, pkgs, ... }:

{
  imports =
    [
      ../../programs/hermes-agent/home.nix
      ../../programs/firefox/home.nix
      ../../programs/google-chrome/home.nix
      ../../programs/vscodium/home.nix
      ../../programs/claude-code/home.nix
      ../../programs/cursor/home.nix
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

  programs.vim.enable = true;

  home.stateVersion = "26.05";
}
