{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  home.packages = [
    unstable.pi-coding-agent
  ];
}
