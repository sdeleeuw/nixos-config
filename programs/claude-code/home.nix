{ inputs, lib, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };

  # nixpkgs-unstable occasionally lags behind the latest claude-code release,
  # and Claude refuses to serve too-old clients. Pin the upstream release
  # manifest here, but fall back to the nixpkgs package as soon as it catches
  # up so a future flake update isn't frozen on this version.
  pinnedManifest = builtins.fromJSON (builtins.readFile ./manifest-2.1.288.json);
  unstableClaude = unstable.claude-code;

  package =
    if lib.versionOlder unstableClaude.version pinnedManifest.version then
      unstableClaude.override { manifest = pinnedManifest; }
    else
      unstableClaude;
in
{
  programs.claude-code = {
    enable = true;
    inherit package;
  };
}
