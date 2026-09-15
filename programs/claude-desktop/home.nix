{ inputs, pkgs, ... }:

{
  # FHS variant: bundles docker/node/uv so MCP servers launched via
  # npx/uvx/docker from Claude Desktop actually find those tools.
  home.packages = [
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs
  ];
}
