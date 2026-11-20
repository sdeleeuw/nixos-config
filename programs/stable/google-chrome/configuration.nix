{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

  environment.systemPackages = [
    pkgs.google-chrome
  ];
}
