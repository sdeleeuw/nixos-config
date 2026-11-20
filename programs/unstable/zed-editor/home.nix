{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  programs.zed-editor = {
    enable = true;
    package = unstable.zed-editor;
  };
}
