{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  nixpkgs.config.allowUnfreePackages = [
    "1password-cli"
    "1password"
  ];

  programs._1password = {
    enable = true;
    package = unstable._1password-cli;
  };

  programs._1password-gui = {
    enable = true;
    package = unstable._1password-gui;
    polkitPolicyOwners = [ "sander" ];
  };
}
