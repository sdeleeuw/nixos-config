{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  # programs.gh only exists in home-manager, not NixOS. It also makes gh
  # git's credential helper for github.com, so HTTPS pushes use `gh auth login`.
  programs.gh.package = unstable.gh;
  programs.gh.enable = true;
}
