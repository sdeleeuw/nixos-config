{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/838dee72-0e92-40bc-a08a-e59055930dd2";

  networking.networkmanager.enable = true;

  users.users = {
    sander = {
      isNormalUser = true;
      home = "/home/sander";
      description = "Sander";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };

  programs.hyprland.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
  ];

  system.stateVersion = "26.05";
}
