{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fresh.url = "github:sinelaw/fresh";
    helium = {url = "github:schembriaiden/helium-browser-nix-flake"; inputs.nixpkgs.follows = "nixpkgs";};
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    fresh,
    helium,
    stylix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.Melek = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit fresh helium stylix;
        host = "laptop";
      };
      modules = [
        stylix.nixosModules.stylix
        ./hosts/laptop/default.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.melek = import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = {inherit fresh helium;};
        }
      ];
    };

    homeConfigurations."melek" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit fresh helium;};
      modules = [./home-manager/home.nix];
    };
  };
}
