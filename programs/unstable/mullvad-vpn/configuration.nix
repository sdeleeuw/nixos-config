{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  services.mullvad-vpn = {
    enable = true;

    # Unstable split Mullvad: `mullvad` is the daemon/CLI, `mullvad-vpn` only the GUI.
    # The 26.05 module has one `package` option, so the GUI is installed separately;
    # from 26.11, use `gui.enable` and `gui.package` instead.
    package = unstable.mullvad;
  };

  environment.systemPackages = [ unstable.mullvad-vpn ];
}
