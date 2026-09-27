{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  programs.gh.package = unstable.gh;
  programs.gh.enable = true;
}
