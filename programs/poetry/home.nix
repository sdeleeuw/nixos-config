{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  programs.poetry = {
    enable = true;
    package = unstable.poetry;
  };
}
