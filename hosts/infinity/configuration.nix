{ config, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../desktops/noctalia/configuration.nix
      ../../programs/stable/audacity/configuration.nix
      ../../programs/stable/build-essential/configuration.nix
      ../../programs/stable/docker/configuration.nix
      ../../programs/stable/ffmpeg/configuration.nix
      ../../programs/stable/gearlever/configuration.nix
      ../../programs/stable/google-chrome/configuration.nix
      ../../programs/stable/libreoffice/configuration.nix
      ../../programs/stable/librewolf/configuration.nix
      ../../programs/stable/libvirt/configuration.nix
      ../../programs/stable/nix-ld/configuration.nix
      ../../programs/stable/vlc/configuration.nix
      ../../programs/unstable/1password/configuration.nix
      ../../programs/unstable/mullvad-vpn/configuration.nix
      ../../programs/unstable/signal-desktop/configuration.nix
      ../../programs/unstable/slack/configuration.nix
      ../../programs/unstable/spotify/configuration.nix
      ../../programs/unstable/tailscale/configuration.nix
      ../../users/sander/vibe-typer.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/838dee72-0e92-40bc-a08a-e59055930dd2";

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "infinity";
  networking.networkmanager.enable = true;

  users.users = {
    sander = {
      isNormalUser = true;
      home = "/home/sander";
      description = "Sander";
      extraGroups = [
        "docker"
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
