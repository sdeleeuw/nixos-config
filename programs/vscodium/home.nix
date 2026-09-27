{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  programs.vscodium = {
    enable = true;
    package = unstable.vscodium;
  };
}
