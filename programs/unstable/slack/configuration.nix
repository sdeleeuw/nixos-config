{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  nixpkgs.config.allowUnfreePackages = [ "slack" ];

  environment.systemPackages = [ unstable.slack ];
}
