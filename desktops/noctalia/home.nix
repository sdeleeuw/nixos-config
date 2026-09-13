{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings.theme.builtin = "Nord";
    settings.theme.templates.builtin_ids = [ "gtk3" "gtk4" "qt" "kitty" "hyprland" ];
    settings.dock.enabled = true;
    settings.dock.pinned = [ "kitty" "firefox" "cursor" ];
    settings.bar.default.margin_ends = 0;
  };
}
