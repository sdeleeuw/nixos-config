{ pkgs, ... }:

{
  # GNOME is Wayland-first: GDM provides the login screen and mutter the
  # compositor, so there is no separate Hyprland/greetd setup here.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Qt apps don't pick up the GTK theme the way Noctalia's qt template did;
  # these plugins give them an Adwaita-ish titlebar and colours instead (see
  # the "Qt integration for GNOME" section of the NixOS wiki).
  environment.systemPackages = with pkgs; [
    qadwaitadecorations
    qadwaitadecorations-qt6
    qgnomeplatform
    qgnomeplatform-qt6
  ];

  # The GNOME app suite (Files, Console, Text Editor, Calculator, ...) is the
  # desktop's own equivalent of what Noctalia shipped, so only drop the pure
  # onboarding/documentation apps.
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # sander always gets this desktop's home-manager config on any host that
  # imports this module. Other users are unaffected.
  home-manager.users.sander.imports = [ ./home.nix ];
}
