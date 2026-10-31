{ config, lib, pkgs, ... } :

let
  greeterConfig = (pkgs.formats.toml { }).generate "greeter.toml" {
    session.default = "Hyprland";
    user.default = "sander";
    appearance.scheme = "Nord";
  };
  greeterUser = config.services.greetd.settings.default_session.user;
  greeterGroup = config.users.users.${greeterUser}.group;
in
{
  environment.systemPackages = with pkgs; [
    noctalia
    noctalia-greeter
    # Required for Noctalia's GTK3 template
    adw-gtk3
    galculator
    kitty
    mousepad
    # Wayland-native ssh-askpass
    wayprompt
    # Wayland clipboard CLI
    wl-clipboard
  ];

  programs.hyprland.enable = true;

  # Services Noctalia's integrations talk to.
  networking.networkmanager.enable = lib.mkDefault true;
  hardware.bluetooth.enable = lib.mkDefault true;
  services.upower.enable = lib.mkDefault true;
  services.power-profiles-daemon.enable = lib.mkDefault true;

  programs.thunar.enable = true;

  # Noctalia's gtk templates write theme/color-scheme via dconf; without this
  # those writes are inert and GTK apps stay on Adwaita light.
  programs.dconf.enable = true;

  # Required for the home-manager xfconf module (Thunar settings in home.nix)
  # to apply without a systemd activation error.
  programs.xfconf.enable = true;

  # General-purpose secret-service daemon (libsecret) for storing app secrets.
  services.gnome.gnome-keyring.enable = true;

  # Thunar needs gvfs for trash, removable media, and network mounts.
  services.gvfs.enable = true;

  # Graphical login via greetd, replacing manual TTY + start-hyprland.
  # NixOS 26.05 has no noctalia-greeter module, so this is wired up by hand.
  services.greetd = {
    enable = true;

    # Sessions aren't linked into /run/current-system/sw, so the greeter only
    # finds Hyprland through XDG_DATA_DIRS.
    settings.default_session.command =
      "${lib.getExe' pkgs.coreutils "env"} "
      + "XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share "
      + "${pkgs.noctalia-greeter}/bin/noctalia-greeter-session --";
  };

  # The greeter reads the user list from accounts-daemon.
  services.accounts-daemon.enable = lib.mkDefault true;
  security.polkit.enable = lib.mkDefault true;

  systemd.tmpfiles.settings."10-noctalia-greeter" = {
    "/var/lib/noctalia-greeter".d = {
      user = greeterUser;
      group = greeterGroup;
      mode = "0750";
    };

    "/var/lib/noctalia-greeter/greeter.toml"."L+" = {
      argument = "${greeterConfig}";
      user = greeterUser;
      group = greeterGroup;
    };
  };

  # gnome-keyring only wires PAM auto-unlock for the "login" service by
  # default; greetd needs it set explicitly.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # sander always gets this desktop's home-manager config on any host that
  # imports this module. Other users are unaffected.
  home-manager.users.sander.imports = [ ./home.nix ];
}
