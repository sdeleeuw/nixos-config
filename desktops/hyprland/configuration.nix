{ pkgs, ... } :

{
  programs.hyprland.enable = true;
  programs.waybar.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    git
    hyprpaper
    kitty
    vim
  ];

  fonts.packages = with pkgs; [
    font-awesome_4
  ];
}
