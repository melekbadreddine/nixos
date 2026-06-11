{
  description = "A custom, declarative, multi-profile NixOS dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://melek-nixos.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "melek-nixos.cachix.org-1:UdhKZAFc78C4ge9SFfgCtMcyBGVfJemC/dwjBaqonVs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    fresh,
    helium,
    zen-browser,
    stylix,
    mango,
    noctalia,
    ...
  } @ inputs: let
    system = "x86_64-linux"; # Primary system
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Global variables
    vars = import ./modules/core/variables.nix;

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
    mkNixosConfig = profile: let
      # Host mapping logic:
      # wsl -> wsl host
      # vm -> vm host
      # others -> default host
      host =
        if profile == "wsl"
        then "wsl"
        else if profile == "vm"
        then "vm"
        else "default";
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs fresh helium zen-browser stylix mango noctalia host profile vars;
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

            home-manager.extraSpecialArgs = {inherit inputs fresh helium zen-browser mango noctalia host profile vars;};
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

    homeConfigurations = builtins.listToAttrs (
      map (h: {
        name = "melek@${h}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit fresh helium zen-browser mango noctalia inputs;
            host = h;
            profile =
              if h == "wsl"
              then "wsl"
              else if h == "vm"
              then "vm"
              else "amd"; # Provide a default profile for standalone
            vars = vars;
          };
          modules = [
            stylix.homeModules.stylix
            ./home-manager/home.nix
          ];
        };
      }) ["default" "vm" "wsl"]
    );
  };
}
