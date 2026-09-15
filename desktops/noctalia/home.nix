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

  # wayprompt has no Noctalia integration to inherit a theme from (Noctalia
  # itself has no ssh-agent/askpass feature), so it's styled by hand to match
  # the Nord scheme set below.
  home.file.".config/wayprompt/config.ini".text = ''
    [general]
    corner-radius = 12;
    border = 2;

    [colours]
    background        = 0x2E3440;
    border            = 0x4C566A;
    text              = 0xECEFF4;
    error-text        = 0xBF616A;
    pin-background    = 0x3B4252;
    pin-border        = 0x4C566A;
    pin-square        = 0x88C0D0;
    ok-button         = 0xA3BE8C;
    ok-button-border  = 0x4C566A;
    ok-button-text    = 0x2E3440;
    not-ok-button        = 0xEBCB8B;
    not-ok-button-border = 0x4C566A;
    not-ok-button-text   = 0x2E3440;
    cancel-button        = 0xBF616A;
    cancel-button-border = 0x4C566A;
    cancel-button-text   = 0x2E3440;
  '';

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
    settings.bar.default.radius = 0;
    settings.dock.enabled = true;
    settings.dock.radius = 0;
    settings.dock.pinned = [ "thunar" "kitty" "google-chrome" "firefox" "cursor" "codium" "com.anthropic.Claude" "slack" "1password" "spotify" "org.xfce.mousepad" "galculator" ];
  };
}
