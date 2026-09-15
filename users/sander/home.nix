{ config, pkgs, ... }:

{
  imports =
    [
      ../../programs/hermes-agent/home.nix
      ../../programs/firefox/home.nix
      ../../programs/google-chrome/home.nix
      ../../programs/vscodium/home.nix
      ../../programs/claude-code/home.nix
      ../../programs/claude-desktop/home.nix
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

  # Fixed-path SSH agent (socket at $XDG_RUNTIME_DIR/ssh-agent) instead of a
  # password manager's agent. IdentityAgent overrides SSH_AUTH_SOCK for ssh
  # and git, so this works even without SSH_AUTH_SOCK exported in the shell.
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    settings."*".IdentityAgent = "\${XDG_RUNTIME_DIR}/ssh-agent";
  };

  home.stateVersion = "26.05";
}
