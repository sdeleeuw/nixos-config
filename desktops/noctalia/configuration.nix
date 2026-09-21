{ inputs, pkgs, ... } :

{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
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

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };

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
  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      session.default = "Hyprland";
      user.default = "sander";
      appearance.scheme = "Nord";
    };
  };

  # The module above only wires PAM auto-unlock for the "login" service by
  # default; greetd needs it set explicitly.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # sander always gets this desktop's home-manager config on any host that
  # imports this module. Other users are unaffected.
  home-manager.users.sander.imports = [ ./home.nix ];
}
