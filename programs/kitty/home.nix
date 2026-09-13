{ ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = "include ./themes/noctalia.conf";
  };
}
