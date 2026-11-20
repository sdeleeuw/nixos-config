{ lib, ... }:

{
  # GNOME enables power-profiles-daemon by default; it conflicts with TLP.
  services.power-profiles-daemon.enable = lib.mkForce false;

  services.tlp = {
    enable = true;
    settings = {
      # 80% cap slows cell wear; the start threshold stops small top-up cycles.
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };
}
