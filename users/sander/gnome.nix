{ lib, osConfig, pkgs, config, ... }:

{
  # Only applied on a host that runs the GNOME desktop. This must be an
  # `mkIf` on `osConfig`, not `lib.optionalAttrs config...`, otherwise
  # evaluating `config` recurses while the home-manager submodule type is
  # being resolved.
  config = lib.mkIf osConfig.services.desktopManager.gnome.enable {
    # Shell extensions: tray icons and a taskbar-style panel.
    programs.gnome-shell = {
      enable = true;

      extensions = [
        { package = pkgs.gnomeExtensions.appindicator; }
        { package = pkgs.gnomeExtensions.dash-to-panel; }
      ];
    };

    # Desktop look, written to dconf (manual changes win until the next switch).
    dconf.settings = {
      # Dark mode with Adwaita widgets, Papirus icons and the Adwaita cursor.
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita";
        icon-theme = "Papirus";
        cursor-theme = "Adwaita";
        cursor-size = 24;
      };

      # Same wallpaper for light and dark mode.
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.home.homeDirectory}/.wallpapers/nordic.jpg";
        picture-uri-dark = "file://${config.home.homeDirectory}/.wallpapers/nordic.jpg";
        picture-options = "zoom";
      };

      # GNOME only shows a close button by default; add minimize and maximize.
      "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";

      # Tighter dash-to-panel icon spacing so all favorites fit on the panel.
      "org/gnome/shell/extensions/dash-to-panel" = {
        appicon-margin = 2;
        appicon-padding = 2;
      };

      # Dock favorites, with GNOME apps in place of the Noctalia-era ones.
      "org/gnome/shell".favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "helium.desktop"
        "librewolf.desktop"
        "codium.desktop"
        "paseo.desktop"
        "com.nousresearch.hermes.desktop"
        "slack.desktop"
        "signal.desktop"
        "com.onepassword.OnePassword.desktop"
        "mullvad-vpn.desktop"
        "vibe_typer.desktop"
        "spotify.desktop"
        "writer.desktop"
        "calc.desktop"
        "org.gnome.TextEditor.desktop"
        "org.gnome.Calculator.desktop"
        "it.mijorus.gearlever.desktop"
      ];
    };

    # Papirus icon theme for GTK apps.
    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };

    # Apply the Adwaita cursor to GTK and X11/XWayland apps too.
    home.pointerCursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.adwaita-icon-theme;

      gtk.enable = true;
      x11.enable = true;
    };

    # Mutter auto-picks 125% for the t480's 14" 1080p panel and has no
    # gsettings key for the scale; it only reads monitors.xml. Seed it once
    # so Settings > Displays can still change it afterwards. The file names
    # the t480's panel, so mutter ignores it on any other machine.
    home.activation.seedMonitorsXml = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      monitors="$HOME/.config/monitors.xml"
      if [[ ! -e $monitors ]]; then
        mkdir -p "$(dirname "$monitors")"
        install -m 644 ${./monitors.xml} "$monitors"
      fi
    '';
  };
}
