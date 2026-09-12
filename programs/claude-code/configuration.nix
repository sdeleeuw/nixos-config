{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePackages = [ "claude-code" ];

  environment.systemPackages = [
    pkgs.claude-code
  ];
}
