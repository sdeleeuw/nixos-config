{ config, lib, pkgs, ... }:

{
  # GNOME Shell extensions. AppIndicator restores the legacy tray icons that
  # several of the shared apps (Slack, Signal, 1Password, Mullvad, Spotify)
  # still use, which GNOME otherwise hides. Enabling this module also acts as
  # the marker users/sander/gnome-overrides.nix uses to detect a GNOME host.
  programs.gnome-shell = {
    enable = true;

    extensions = [
      { package = pkgs.gnomeExtensions.appindicator; }
    ];
  };

  # Desktop look, seeded into the user's dconf database. The GNOME Settings
  # UI writes to the same database, so a manual change wins until the next
  # `home-manager switch`.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita";
      icon-theme = "Papirus";
      cursor-theme = "Adwaita";
      cursor-size = 24;
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/.wallpapers/nordic.jpg";
      picture-uri-dark = "file://${config.home.homeDirectory}/.wallpapers/nordic.jpg";
      picture-options = "zoom";
    };

    # GNOME only shows a close button by default; this is what GNOME Tweaks'
    # "Titlebar Buttons" toggles write.
    "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";

    # Apps that ship with the desktop. sander's full list of favorites lives
    # in gnome-overrides.nix and replaces this list.
    "org/gnome/shell".favorite-apps = lib.mkDefault [
      "org.gnome.Nautilus.desktop"
      "org.gnome.Console.desktop"
      "org.gnome.TextEditor.desktop"
      "org.gnome.Calculator.desktop"
    ];
  };

  # Same icon set and cursor as the Noctalia setup.
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    size = 24;
    package = pkgs.adwaita-icon-theme;

    gtk.enable = true;
    x11.enable = true;
  };
}
