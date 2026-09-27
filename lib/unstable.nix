# Builds a nixpkgs-unstable package set that shares the running system's
# config (unfree policy, etc.), so a module can pull a single package from
# unstable without a global overlay:
#
#   { inputs, pkgs, ... }:
#   let unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
#   in { programs.cursor.package = unstable.code-cursor; }
#
# Passing `pkgs.config` is what keeps per-module `nixpkgs.config.allowUnfreePackages`
# declarations applying to the unstable package too.
{ inputs, pkgs }:
import inputs.nixpkgs-unstable {
  system = pkgs.stdenv.hostPlatform.system;
  config = pkgs.config;
}
