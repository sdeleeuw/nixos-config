{ config, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../desktops/gnome/configuration.nix
      ../../games/dolphin-emu/configuration.nix
      ../../games/dosbox-staging/configuration.nix
      ../../games/luanti/configuration.nix
      ../../games/ppsspp/configuration.nix
      ../../games/retroarch/configuration.nix
      ../../games/supertuxkart/configuration.nix
      ../../programs/1password/configuration.nix
      ../../programs/audacity/configuration.nix
      ../../programs/build-essential/configuration.nix
      ../../programs/cursor/configuration.nix
      ../../programs/docker/configuration.nix
      ../../programs/ffmpeg/configuration.nix
      ../../programs/gearlever/configuration.nix
      ../../programs/google-chrome/configuration.nix
      ../../programs/libreoffice/configuration.nix
      ../../programs/librewolf/configuration.nix
      ../../programs/libvirt/configuration.nix
      ../../programs/mullvad-vpn/configuration.nix
      ../../programs/nix-ld/configuration.nix
      ../../programs/signal-desktop/configuration.nix
      ../../programs/slack/configuration.nix
      ../../programs/spotify/configuration.nix
      ../../programs/tailscale/configuration.nix
      ../../programs/tlp/configuration.nix
      ../../programs/uv/configuration.nix
      ../../programs/vibe-typer/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/d40d6d13-b471-4b97-be69-412983f41d8c";

  # Hibernate to the swap LV: the gauges misreport near empty, so "10% left" can mean seconds.
  boot.resumeDevice = "/dev/disk/by-uuid/c45eadb1-79eb-4afa-874b-bf0b3a9d41b7";

  services.upower = {
    enable = true;
    # Act at 10%, not the default 2%: the drop skips straight past the low end.
    criticalPowerAction = "Hibernate";
    percentageLow = 20;
    percentageCritical = 15;
    percentageAction = 10;
  };

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
