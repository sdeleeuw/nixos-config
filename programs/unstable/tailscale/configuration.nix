{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  services.tailscale = {
    enable = true;
    package = unstable.tailscale;
  };
}
