{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.ppsspp
  ];
}
