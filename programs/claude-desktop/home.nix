{ inputs, lib, pkgs, ... }:

{
  # Bundles docker/node/uv so MCP servers launched via npx/uvx/docker from
  # Claude Desktop actually find those tools. Pinned to the current release in
  # ./package.nix because the flake input's CI lags behind the apt repo.
  home.packages = [
    (import ./package.nix { inherit inputs lib pkgs; })
  ];
}
