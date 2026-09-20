{ config, lib, options, ... }:

{
  # Only when a desktop that imports Noctalia is active.
  config = lib.optionalAttrs (options.programs ? noctalia) {
    programs.noctalia.settings = {
      wallpaper.directory = "${config.home.homeDirectory}/.wallpapers";
      wallpaper.default.path = "${config.home.homeDirectory}/.wallpapers/nordic.jpg";

      dock.pinned = [
        "thunar"
        "kitty"
        "google-chrome"
        "firefox"
        "cursor"
        "codium"
        "com.anthropic.Claude"
        "slack"
        "signal"
        "1password"
        "spotify"
        "it.mijorus.gearlever"
        "writer"
        "calc"
        "org.xfce.mousepad"
        "galculator"
      ];
    };
  };
}
