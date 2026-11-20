{ ... }:

{
  programs.uv.enable = true;

  # uv also ships shell completions, but they need `uv` on PATH at shell
  # startup. Add them to the interactive shell via the bash module instead.
  programs.bash.initExtra = ''
    if command -v uv >/dev/null; then
      eval "$(uv generate-shell-completion bash)"
    fi
  '';
}
