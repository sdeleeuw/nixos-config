{ inputs, ... }:

{
  # Stable nixpkgs lags; take this one package from unstable.
  nixpkgs.overlays = [
    (final: prev: {
      pi-coding-agent =
        (import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config = prev.config;
        }).pi-coding-agent;
    })
  ];
}
