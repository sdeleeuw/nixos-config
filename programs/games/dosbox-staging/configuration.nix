{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.dosbox-staging
  ];
}
