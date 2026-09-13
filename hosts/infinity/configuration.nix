{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../desktops/noctalia/configuration.nix
      ../../programs/1password/configuration.nix
      ../../programs/claude-code/configuration.nix
      ../../programs/cursor/configuration.nix
      ../../programs/google-chrome/configuration.nix
      ../../programs/spotify/configuration.nix
      ../../programs/slack/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/838dee72-0e92-40bc-a08a-e59055930dd2";

  networking.hostName = "infinity";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    sander = {
      isNormalUser = true;
      home = "/home/sander";
      description = "Sander";
      extraGroups = [
        "input"
        "networkmanager"
        "wheel"
      ];
    };
  };

  programs.vim.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
