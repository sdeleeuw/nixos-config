# Package set from nixpkgs-unstable, for modules that need a newer version than stable.
# Usage: `unstable = import ../helpers.nix { inherit inputs pkgs; };`

{ inputs, pkgs }:
import inputs.nixpkgs-unstable {
  # Build for the same platform as this host (x86_64-linux, from nixpkgs.hostPlatform).
  system = pkgs.stdenv.hostPlatform.system;

  # Reuse this host's nixpkgs config, so each module's allowUnfreePackages also applies here.
  config = pkgs.config;
}
