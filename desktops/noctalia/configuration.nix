{ inputs, pkgs, ... } :

{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    # Theme Noctalia's gtk3 template switches to; apply.sh skips without it.
    adw-gtk3
    galculator
    kitty
    mousepad
    # Wayland-native ssh-askpass, used by SSH_ASKPASS in config/hyprland.lua.
    wayprompt
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

  # Required for the home-manager xfconf module (programs/thunar/home.nix)
  # to apply Thunar's settings without a systemd activation error.
  programs.xfconf.enable = true;

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

  # sander always gets this desktop's home-manager config on any host that
  # imports this module. Other users are unaffected.
  home-manager.users.sander.imports = [
    ./home.nix
    ../../programs/kitty/home.nix
    ../../programs/thunar/home.nix
  ];
}
