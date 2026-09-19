{ lib, options, ... }:

{
  # Only when a desktop that imports Noctalia is active — overrides the
  # desktop's mkDefault dock pin list.
  config = lib.optionalAttrs (options.programs ? noctalia) {
    programs.noctalia.settings.dock.pinned = [
      "thunar"
      "kitty"
      "google-chrome"
      "firefox"
      "cursor"
      "codium"
      "com.anthropic.Claude"
      "slack"
      "1password"
      "spotify"
      "org.xfce.mousepad"
      "galculator"
    ];
  };
}
