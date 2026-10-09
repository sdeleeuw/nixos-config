{ inputs, pkgs, ... }:

let
  unstable = import ../../lib/unstable.nix { inherit inputs pkgs; };
in
{
  # These cores carry non-commercial licenses.
  nixpkgs.config.allowUnfreePackages = [
    "libretro-genesis-plus-gx"
    "libretro-snes9x"
  ];

  # A bare `retroarch` ships without cores, so list the ones to include.
  environment.systemPackages = [
    (unstable.retroarch.withCores (cores: with cores; [
      flycast # Sega Dreamcast
      gambatte # Game Boy / Game Boy Color
      genesis-plus-gx # Sega Mega Drive / Master System / Game Gear / Mega-CD
      mgba # Game Boy Advance
      mupen64plus # Nintendo 64
      nestopia # Nintendo NES / Famicom
      pcsx_rearmed # Sony PlayStation
      snes9x # Super Nintendo
    ]))
  ];
}
