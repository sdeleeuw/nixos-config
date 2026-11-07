{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  programs.zed-editor = {
    enable = true;
    # Zed ships weekly; stable nixpkgs lags far behind.
    package = unstable.zed-editor;
  };
}
