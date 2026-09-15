{ inputs, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Wayland-native ssh-askpass prompt, used by the SSH_ASKPASS env var set in
  # config/hyprland.lua.
  home.packages = [ pkgs.wayprompt ];

  home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  programs.noctalia = {
    enable = true;

    settings.theme.builtin = "Nord";
    settings.theme.templates.builtin_ids = [ "gtk3" "gtk4" "qt" "kitty" "hyprland" ];
    settings.bar.default.margin_ends = 0;
    settings.dock.enabled = true;
    settings.dock.pinned = [ "thunar" "kitty" "google-chrome" "firefox" "cursor" "codium" "slack" "1password" "spotify" "org.xfce.mousepad" "galculator" ];
  };
}
