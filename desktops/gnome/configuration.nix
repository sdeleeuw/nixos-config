{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Drop the onboarding/documentation apps; keep the rest of the GNOME suite.
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # Give Qt apps an Adwaita-style titlebar and colours so they match GNOME.
  environment.systemPackages = with pkgs; [
    qadwaitadecorations
    qadwaitadecorations-qt6
    qgnomeplatform
    qgnomeplatform-qt6
  ];
}
