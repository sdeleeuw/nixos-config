{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  programs.cursor = {
    enable = true;
    package = unstable.code-cursor;
  };
}
