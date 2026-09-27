{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  environment.systemPackages = [
    unstable.libreoffice
  ];
}
