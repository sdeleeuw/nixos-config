{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  programs.gh.package = unstable.gh;
  programs.gh.enable = true;
}
