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
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    fresh,
    helium,
    stylix,
    plasma-manager,
    ...
  }: let
    system = "x86_64-linux";
    host = "laptop";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.Melek = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit fresh helium stylix host plasma-manager;
      };
      modules = [
        { nixpkgs.hostPlatform = system; }
        stylix.nixosModules.stylix
        ./hosts/laptop/default.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.melek = import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = {inherit fresh helium host plasma-manager;};
          home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
        }
      ];
    };

    homeConfigurations."melek" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit fresh helium host plasma-manager;};
      modules = [
        ./home-manager/home.nix
        plasma-manager.homeManagerModules.plasma-manager
      ];
    };
  };
}
