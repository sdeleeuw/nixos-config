{ config, lib, options, ... }:

{
  # Only when a desktop that imports Noctalia is active.
  config = lib.optionalAttrs (options.programs ? noctalia) {
    programs.noctalia.settings = {
      wallpaper.directory = "${config.home.homeDirectory}/.wallpapers";
      wallpaper.default.path = "${config.home.homeDirectory}/.wallpapers/nordic.jpg";

      dock.pinned = [
        "kitty"
        "thunar"
        "google-chrome"
        "librewolf"
        "cursor"
        "codium"
        "com.anthropic.Claude"
        "slack"
        "signal"
        "1password"
        "mullvad-vpn"
        "spotify"
        "writer"
        "calc"
        "org.xfce.mousepad"
        "galculator"
        "it.mijorus.gearlever"
      ];
    };
  };
}
