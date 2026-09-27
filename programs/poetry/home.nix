{
  pkgs,
  ...
}:

{
  # Deliberately the stable package rather than nixpkgs-unstable: unstable's
  # poetry is built against Python 3.14, but projects pinning older
  # pydantic-core (e.g. 2.27.x) only publish wheels up to cp313, so Poetry
  # falls back to compiling them from source and fails without a toolchain in
  # PATH. Stable poetry ships Python 3.13, matching those wheels, and is only
  # a patch version behind anyway.
  programs.poetry = {
    enable = true;
    package = pkgs.poetry;
  };
}
