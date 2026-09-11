{ inputs, pkgs, ... } :

{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    kitty
  ];

  programs.hyprland.enable = true;
  programs.firefox.enable = true;

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };
}
