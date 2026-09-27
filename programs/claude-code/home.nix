{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  programs.claude-code = {
    enable = true;
    package = unstable.claude-code;
  };
}
