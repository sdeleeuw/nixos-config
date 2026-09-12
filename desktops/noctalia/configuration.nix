{ inputs, pkgs, ... } :

{
  imports = [
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
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

  # Graphical login via greetd, replacing manual TTY + start-hyprland.
  programs.noctalia-greeter = {
    enable = true;

    settings = {
      session.default = "Hyprland";
      user.default = "sander";
    };
  };

  # sander always gets this desktop's home-manager config on any host that
  # imports this module. Other users are unaffected.
  home-manager.users.sander.imports = [
    ./home.nix
    ../../programs/hyprland/home.nix
    ../../programs/kitty/home.nix
  ];
}
