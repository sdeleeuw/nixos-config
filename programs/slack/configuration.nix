{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [ "slack" ];

  environment.systemPackages = [
    pkgs.slack
  ];
}
