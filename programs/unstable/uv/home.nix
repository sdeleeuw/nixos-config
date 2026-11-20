{ inputs, pkgs, ... }:

let
  unstable = import ../helpers.nix { inherit inputs pkgs; };
in
{
  # Stable nixpkgs lags behind uv's frequent releases.
  programs.uv = {
    enable = true;
    package = unstable.uv;
  };

  # uv also ships shell completions, but they need `uv` on PATH at shell
  # startup. Add them to the interactive shell via the bash module instead.
  programs.bash.initExtra = ''
    if command -v uv >/dev/null; then
      eval "$(uv generate-shell-completion bash)"
    fi
  '';
}
