{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [ "cursor" ];

  environment.systemPackages = [
    pkgs.code-cursor
  ];
}
