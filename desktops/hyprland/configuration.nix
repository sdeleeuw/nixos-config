{ pkgs, ... } :

{
  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    hyprlauncher
    hyprpaper
    kitty
  ];

  fonts.packages = with pkgs; [
    font-awesome_4
  ];
}
