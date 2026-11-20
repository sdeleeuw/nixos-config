# NixOS module (not home-manager), imported by each host: Vibe Typer itself is an
# AppImage installed through Gear Lever, this only lets it type into other apps on Wayland.
{ pkgs, ... }:

{
  # Lets it create a virtual keyboard; replaces the udev rules its setup dialog suggests.
  hardware.uinput.enable = true;

  # Access to the input devices and to /dev/uinput.
  users.users.sander.extraGroups = [
    "input"
    "uinput"
  ];

  # It pastes text through the Wayland clipboard.
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];
}
