{
  pkgs,
  lib,
  ...
}:

# Build tooling for the local oudommen-backend checkout only. Some of its
# Python dependencies have no NixOS wheels, so `poetry install` compiles their
# C/C++ extensions from source:
#   - insightface / onnxruntime: need a C++ compiler (and make)
#   - mysqlclient: needs pkg-config + libmysqlclient's .pc file
#   - psycopg2: needs pg_config + the libpq headers
#   - av: needs the ffmpeg headers/libraries
# libpq.pg_config is a separate derivation from the default output of libpq,
# and the .pc files live in the split -dev outputs of each library. This lives
# here rather than in programs/poetry so the shared poetry module stays
# generic and no other user inherits this project's dependencies.
let
  nativeBuildInputs = with pkgs; [
    gcc
    gnumake
    pkg-config
    libmysqlclient
    libpq
    libpq.pg_config
    ffmpeg
  ];

  # Poetry spawns cc/pkg-config/pg_config while building wheels, so those have
  # to be on the poetry process' PATH. Merely adding the libraries to
  # home.packages is not enough: pkg-config only searches PKG_CONFIG_PATH, and
  # the -dev outputs holding the .pc files aren't picked up by default.
  # Wrapping the poetry binary keeps this build environment out of every other
  # interactive shell.
  poetry = pkgs.symlinkJoin {
    name = "poetry-with-native-build-toolchain";
    paths = [ pkgs.poetry ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/poetry \
        --prefix PATH : ${lib.makeBinPath nativeBuildInputs} \
        --prefix PKG_CONFIG_PATH : ${lib.makeSearchPathOutput "dev" "lib/pkgconfig" nativeBuildInputs} \
        --prefix PKG_CONFIG_PATH : ${lib.makeSearchPathOutput "dev" "share/pkgconfig" nativeBuildInputs}
    '';
  };
in
{
  programs.poetry.package = poetry;
}
