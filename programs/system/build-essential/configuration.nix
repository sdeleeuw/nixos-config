{ pkgs, ... }:

{
  # Add a global compiler toolchain, much like build-essential on Debian.
  environment.systemPackages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.pkg-config
  ];
}
