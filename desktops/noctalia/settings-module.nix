# home-manager 26.05 has no Noctalia module, so this provides the one option we
# use from it. Drop this in favour of the upstream module once it's in a
# home-manager release.
{ config, lib, pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
  rawConfig = tomlFormat.generate "config.toml" config.programs.noctalia.settings;
in
{
  options.programs.noctalia.settings = lib.mkOption {
    type = tomlFormat.type;
    default = { };
    description = "Default Noctalia settings, written to ~/.config/noctalia/config.toml.";
  };

  # Fail the build on an invalid config instead of at login.
  config.xdg.configFile."noctalia/config.toml".source =
    pkgs.runCommand "noctalia-config.toml" { } ''
      ${lib.getExe pkgs.noctalia} config validate ${rawConfig}
      cp ${rawConfig} $out
    '';
}
