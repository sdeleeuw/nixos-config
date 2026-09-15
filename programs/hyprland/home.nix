{ pkgs, ... }:

{
  # Wayland-native ssh-askpass prompt, used by the SSH_ASKPASS env var set in
  # config/hyprland.lua.
  home.packages = [ pkgs.wayprompt ];

  home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
  };
}
