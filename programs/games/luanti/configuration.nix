{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.luanti
  ];
}
