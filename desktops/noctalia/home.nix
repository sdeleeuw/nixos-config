{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings.theme.builtin = "Nord";
    settings.theme.templates.builtin_ids = [ "gtk3" "gtk4" "qt" "kitty" "hyprland" ];
    settings.bar.default.margin_ends = 0;
    settings.dock.enabled = true;
    settings.dock.pinned = [ "kitty" "google-chrome" "firefox" "cursor" "codium" "slack" "1password" "spotify" ];
  };
}
