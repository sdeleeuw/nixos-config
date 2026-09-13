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

  # Creates ~/Downloads, ~/Documents, ~/Pictures, ~/Music, ~/Videos and
  # ~/Projects (home-manager's default set, which conveniently already
  # includes Projects) so the Thunar bookmarks in programs/thunar/home.nix
  # resolve to real directories instead of dangling shortcuts.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
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
