{ inputs, config, ... }:

{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  # The hermes CLI on PATH and the Electron desktop app, both sharing state
  # with services.hermes-agent below.
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;

    # The OpenRouter key itself lives in the environmentFiles secret below.
    settings.model = {
      provider = "openrouter";
      default = "qwen/qwen3.8-27b";
    };

    # A plain runtime path, not a Nix path literal: the latter would copy
    # the secret into the world-readable Nix store. Create this file
    # yourself (chmod 600) with e.g. ANTHROPIC_API_KEY=... — it is never
    # managed by Nix or committed to this repo.
    environmentFiles = [ "${config.home.homeDirectory}/.config/hermes-agent/env" ];
  };
}
