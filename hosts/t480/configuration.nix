{ config, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../desktops/gnome/configuration.nix
      ../../programs/1password/configuration.nix
      ../../programs/claude-code/configuration.nix
      ../../programs/claude-desktop/configuration.nix
      ../../programs/cursor/configuration.nix
      ../../programs/docker/configuration.nix
      ../../programs/gearlever/configuration.nix
      ../../programs/google-chrome/configuration.nix
      ../../programs/libreoffice/configuration.nix
      ../../programs/librewolf/configuration.nix
      ../../programs/libvirt/configuration.nix
      ../../programs/mullvad-vpn/configuration.nix
      ../../programs/signal-desktop/configuration.nix
      ../../programs/slack/configuration.nix
      ../../programs/spotify/configuration.nix
      ../../programs/uv/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/d40d6d13-b471-4b97-be69-412983f41d8c";

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "t480";
  networking.networkmanager.enable = true;

  users.users = {
    sander = {
      isNormalUser = true;
      home = "/home/sander";
      description = "Sander";
      extraGroups = [
        "docker"
        "input"
        "libvirtd"
        "networkmanager"
        "wheel"
      ];
    };
  };

  programs.git.enable = true;
  programs.vim.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
