{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Used to access newer versions of specific programs when the stable
    # channel is outdated.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations = {
        infinity = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/infinity/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.sander = import ./users/sander/home.nix;
              };
            }
          ];

          specialArgs = {
            inherit inputs;
          };
        };

        t480 = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/t480/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.sander = import ./users/sander/home.nix;
              };
            }
          ];

          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
