{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Hyprland configs
  home.file.".config/hypr" = {
    source = ./config/hypr;
    recursive = true;
  };

  # Noctalia configs
  programs.noctalia = {
    enable = true;

    # Theme
    settings.theme.builtin = "Nord";
    settings.theme.templates.builtin_ids = [
      "gtk3"
      "gtk4"
      "qt"
      "kitty"
      "hyprland"
    ];

    # Bar
    settings.bar.default.margin_ends = 0;
    settings.bar.default.radius = 0;

    # Dock
    settings.dock.enabled = true;
    settings.dock.radius = 0;
    settings.dock.pinned = lib.mkDefault [
      "thunar"
      "kitty"
      "org.xfce.mousepad"
      "galculator"
    ];
  };

  # Required by Noctalia's Kitty template.
  programs.kitty = {
    enable = true;
    extraConfig = "include ./themes/noctalia.conf";
  };

  # Wayprompt configs
  home.file.".config/wayprompt" = {
    source = ./config/wayprompt;
    recursive = true;
  };

  # GTK configs
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Pointer cursor
  home.pointerCursor = {
    name = "Adwaita";
    size = 24;
    package = pkgs.adwaita-icon-theme;

    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  # Thunar default settings
  xfconf.settings.thunar = {
    "default-view" = "ThunarDetailsView";
    "last-view" = "ThunarDetailsView";
  };
}
