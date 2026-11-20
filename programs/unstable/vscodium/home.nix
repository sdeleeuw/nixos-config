{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  programs.vscodium = {
    enable = true;
    package = unstable.vscodium;
  };
}
