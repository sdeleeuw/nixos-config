{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  environment.systemPackages = [
    unstable.signal-desktop
  ];
}
