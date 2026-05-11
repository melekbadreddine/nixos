{
  description = "Modular multi-profile NixOS + Home Manager flake";

  nixConfig = {
    extra-substituters = ["https://melek-nixos.cachix.org"];
    extra-trusted-public-keys = ["melek-nixos.cachix.org-1:UdhKZAFc78C4ge9SFfgCtMcyBGVfJemC/dwjBaqonVs="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    fresh.url = "github:sinelaw/fresh";
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    plasma-manager,
    fresh,
    helium,
    zen-browser,
    stylix,
    nixos-wsl,
    ...
  } @ inputs: let
    system = "x86_64-linux"; # Primary system (can be overridden per profile)
    host = "default";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Supported profiles
    profiles = [
      "amd"
      "intel"
      "nvidia"
      "intel-nvidia"
      "amd-nvidia"
      "vm"
      "wsl"
    ];

    # Function to create a NixOS configuration for a given profile
    mkNixosConfig = profile:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs fresh helium zen-browser stylix host profile plasma-manager;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          stylix.nixosModules.stylix
          ./profiles/${profile}

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.melek = import ./home-manager/home.nix;

            home-manager.extraSpecialArgs = {inherit inputs fresh helium zen-browser host profile plasma-manager;};
          }
        ];
      };
  in {
    # Create a configuration for each profile
    nixosConfigurations = builtins.listToAttrs (
      map (profile: {
        name = profile;
        value = mkNixosConfig profile;
      })
      profiles
    );

    homeConfigurations."melek" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit fresh helium zen-browser host inputs plasma-manager;};
      modules = [
        stylix.homeModules.stylix
        ./home-manager/home.nix
      ];
    };
  };
}
