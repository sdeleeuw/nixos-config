# Claude Desktop, pinned ahead of the `claude-desktop` flake input.
#
# The upstream flake (heytcass/claude-desktop-linux-flake) only bumps its
# packaged version on a weekly CI run, so a `nix flake update` can leave us on
# a release that's too old for the current models. Repackage the newest deb
# from Anthropic's apt repo ourselves, reusing upstream's package definition so
# all the rpath/desktop-file handling stays in one place.
{ inputs, lib, pkgs }:

let
  system = pkgs.stdenv.hostPlatform.system;
  upstream = inputs.claude-desktop.packages.${system};

  # Source of truth: the last stanza of
  #   ${aptRepo}/dists/stable/main/binary-{amd64,arm64}/Packages
  # Convert its SHA256 with `nix hash convert --hash-algo sha256 --to sri`.
  aptRepo = "https://downloads.claude.ai/claude-desktop/apt/stable";
  pinnedVersion = "2.9939.4";
  pinnedSrc = {
    x86_64-linux = pkgs.fetchurl {
      url = "${aptRepo}/pool/main/c/claude-desktop/claude-desktop_${pinnedVersion}_amd64.deb";
      hash = "sha256-PP3bI78pEeBeJ7TtOFa455XflGQ7LDW1nesxfPmVvKA=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "${aptRepo}/pool/main/c/claude-desktop/claude-desktop_${pinnedVersion}_arm64.deb";
      hash = "sha256-EI7XnqFksIxPoLtDh97vR3mVez8Pmy2YmONZ82Pr8bw=";
    };
  };

  # Mirror upstream's `claude-desktop-with-fhs`, which bundles docker/node/uv
  # so MCP servers launched via npx/uvx/docker actually find those tools. We
  # have to rebuild it against the pinned binary because symlinking the
  # prebuilt FHS env would keep pointing at the old version.
  withFhs = claudeDesktop: pkgs.symlinkJoin {
    name = "claude-desktop-with-fhs";
    paths = [
      claudeDesktop
      (pkgs.buildFHSEnv {
        name = "claude-desktop-bwrap";
        targetPkgs = p: with p; [
          docker
          glibc
          openssl
          nodejs
          uv
          glib
          gvfs
          xdg-utils
        ];
        runScript = "${claudeDesktop}/bin/claude-desktop";
      })
    ];
    postBuild = ''
      # Replace the regular binary with the FHS wrapped one
      rm -f $out/bin/claude-desktop
      ln -sf $out/bin/claude-desktop-bwrap $out/bin/claude-desktop
    '';
  };

  pinned = upstream.claude-desktop.overrideAttrs {
    version = pinnedVersion;
    src = pinnedSrc.${system};
  };
in
# Only use the pin while the input lags, so a later flake update transparently
# takes over instead of freezing Claude Desktop at this version.
if lib.versionOlder upstream.claude-desktop.version pinnedVersion then
  withFhs pinned
else
  upstream.claude-desktop-with-fhs
