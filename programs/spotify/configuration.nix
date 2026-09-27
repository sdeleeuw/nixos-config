{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  nixpkgs.config.allowUnfreePackages = [ "spotify" ];

  environment.systemPackages = [
    unstable.spotify
  ];
}
