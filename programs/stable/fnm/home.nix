{ pkgs, ... }:

{
  home.packages = [ pkgs.fnm ];

  # fnm has no NixOS/home-manager module, so set up its shell integration
  # manually. --use-on-cd auto-switches Node versions when entering a
  # directory with .node-version / .nvmrc. Use the store path so it works
  # regardless of PATH ordering.
  programs.bash.initExtra = ''
    eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd --shell bash)"
  '';
}
