{ config, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../desktops/gnome/configuration.nix
      ../../programs/games/dolphin-emu/configuration.nix
      ../../programs/games/dosbox-staging/configuration.nix
      ../../programs/games/luanti/configuration.nix
      ../../programs/games/ppsspp/configuration.nix
      ../../programs/games/retroarch/configuration.nix
      ../../programs/games/supertuxkart/configuration.nix
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
      ../../programs/stable/tlp/configuration.nix
      ../../programs/stable/vlc/configuration.nix
      ../../programs/unstable/1password/configuration.nix
      ../../programs/unstable/mullvad-vpn/configuration.nix
      ../../programs/unstable/signal-desktop/configuration.nix
      ../../programs/unstable/slack/configuration.nix
      ../../programs/unstable/spotify/configuration.nix
      ../../programs/unstable/tailscale/configuration.nix
      ../../users/sander/1password.nix
      ../../users/sander/vibe-typer.nix
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
