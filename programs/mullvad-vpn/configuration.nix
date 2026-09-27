{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  services.mullvad-vpn = {
    enable = true;
    # nixpkgs-unstable split the app in two: `mullvad` is the daemon/CLI
    # (including `mullvad-exclude`, which the security wrapper sources) and
    # `mullvad-vpn` is only the GUI. The 26.05 module has a single `package`
    # option, so point it at the daemon and install the GUI alongside it.
    package = unstable.mullvad;
  };

  environment.systemPackages = [ unstable.mullvad-vpn ];
}
