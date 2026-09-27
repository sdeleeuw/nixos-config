{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  services.mullvad-vpn = {
    enable = true;
    package = unstable.mullvad-vpn;
  };
}
