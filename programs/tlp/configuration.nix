{ lib, ... }:

{
  # GNOME enables power-profiles-daemon by default; it conflicts with TLP.
  services.power-profiles-daemon.enable = lib.mkForce false;

  services.tlp = {
    enable = true;
    settings = {
      # The t480 has an internal (BAT0) and a hot-swappable (BAT1) battery.
      # Capping both at 80% slows cell wear; the start threshold keeps tiny
      # top-ups from cycling the batteries.
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };
}
