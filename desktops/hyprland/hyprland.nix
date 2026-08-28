{ pkgs, ... } :

{
  programs.hyprland.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    git
    kitty
    vim
  ];
}
