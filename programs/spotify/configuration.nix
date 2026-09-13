{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [ "spotify" ];

  environment.systemPackages = [
    pkgs.spotify
  ];
}
