{ inputs, ... }:

{
  # Stable nixpkgs lags; take this one package from unstable.
  nixpkgs.overlays = [
    (final: prev: {
      uv =
        (import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config = prev.config;
        }).uv;
    })
  ];
}
