{ pkgs, ... }:

{
  # Vibe Typer (run as an AppImage via gearlever) types text by creating
  # virtual input devices and pasting through the clipboard on Wayland.
  # Its own setup dialog suggests udev rules for this; on NixOS the
  # `uinput` group + wl-clipboard cover the same requirements.
  hardware.uinput.enable = true;

  users.users.sander.extraGroups = [ "input" "uinput" ];

  environment.systemPackages = [ pkgs.wl-clipboard ];
}
