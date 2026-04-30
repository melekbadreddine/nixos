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
    mango.url = "github:mangowm/mango";
    mango.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    fresh,
    helium,
    stylix,
    mango,
    ...
  } @ inputs: let
    system = "x86_64-linux";
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
    ];

    # Function to create a NixOS configuration for a given profile
    mkNixosConfig = profile: nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit fresh helium stylix host mango profile;
      };
      modules = [
        { 
          nixpkgs.hostPlatform = system;
          nixpkgs.overlays = [
            (final: prev: {
              xorg = prev.xorg // {
                libxcb = prev.libxcb;
                xcbutilwm = prev.libxcb-wm;
              };
            })
          ];
        }
        stylix.nixosModules.stylix
        ./profiles/${profile}
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.users.melek = import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = {inherit fresh helium host mango inputs profile;};
        }
      ];
    };
  in {
    # Create a configuration for each profile
    nixosConfigurations = builtins.listToAttrs (
      map (profile: {
        name = profile;
        value = mkNixosConfig profile;
      }) profiles
    );

    homeConfigurations."melek" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit fresh helium host mango inputs;};
      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
