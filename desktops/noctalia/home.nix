{ lib, pkgs, ... }:

{
  imports = [
    ./settings-module.nix
  ];

  # Hyprland configs
  home.file.".config/hypr" = {
    source = ./config/hypr;
    recursive = true;
  };

  # Niri configs. Linked as a single file, not the whole directory, because
  # Noctalia's niri theme template writes noctalia.kdl next to it.
  home.file.".config/niri/config.kdl".source = ./config/niri/config.kdl;

  # Noctalia configs
  programs.noctalia = {
    # Sounds are off by default in the stable release.
    settings.audio.enable_sounds = true;

    # Theme
    settings.theme.builtin = "Nord";
    settings.theme.templates.builtin_ids = [
      "gtk3"
      "gtk4"
      "qt"
      "kitty"
      "hyprland"
      "niri"
    ];

    # Bar
    settings.bar.default.margin_ends = 0;
    settings.bar.default.radius = 0;

    # Dock
    settings.dock.enabled = true;
    settings.dock.radius = 0;
    settings.dock.icon_size = 40;
    settings.dock.main_axis_padding = 8;
    settings.dock.cross_axis_padding = 4;
    settings.dock.item_spacing = 4;
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
