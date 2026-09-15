{ inputs, pkgs, ... } :

{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    kitty
    mousepad
    galculator
    adw-gtk3
  ];

  services.gvfs.enable = true;

  # Needed for Noctalia's gtk3/gtk4 templates: without the dconf GSettings
  # backend, its gsettings/dconf writes (gtk-theme, color-scheme) are inert
  # and GTK apps stay on stock Adwaita light. adw-gtk3 above is the theme it
  # switches to (its apply.sh skips the switch entirely if that's missing).
  programs.dconf.enable = true;

  programs.hyprland.enable = true;
  programs.thunar.enable = true;

  # Required for the home-manager xfconf module (programs/thunar/home.nix)
  # to apply Thunar's settings without a systemd activation error.
  programs.xfconf.enable = true;

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };

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
    ../../programs/hyprland/home.nix
    ../../programs/kitty/home.nix
    ../../programs/thunar/home.nix
  ];
}
