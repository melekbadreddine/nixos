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
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
    };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    vars = import ./modules/core/variables.nix;

    profiles = [
      "amd"
      "intel"
      "nvidia"
      "intel-nvidia"
      "amd-nvidia"
      "vm"
      "wsl"
    ];

    mkNixosConfig = profile: let
      host =
        if profile == "wsl"
        then "wsl"
        else if profile == "vm"
        then "vm"
        else "default";
    in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs host profile vars;
          fresh = inputs.fresh;
          helium = inputs.helium;
          zen-browser = inputs.zen-browser;
          mango = inputs.mango;
          noctalia = inputs.noctalia;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          inputs.stylix.nixosModules.stylix
          ./profiles/${profile}

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.melek = import ./home-manager/home.nix;

            home-manager.extraSpecialArgs = {
              inherit inputs host profile vars;
              fresh = inputs.fresh;
              helium = inputs.helium;
              zen-browser = inputs.zen-browser;
              mango = inputs.mango;
              noctalia = inputs.noctalia;
            };
          }
        ];
      };
  in {
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
        value = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            host = h;
            profile =
              if h == "wsl"
              then "wsl"
              else if h == "vm"
              then "vm"
              else "amd-nvidia";
            vars = vars;
            fresh = inputs.fresh;
            helium = inputs.helium;
            zen-browser = inputs.zen-browser;
            mango = inputs.mango;
            noctalia = inputs.noctalia;
          };
          modules = [
            inputs.stylix.homeModules.stylix
            ./home-manager/home.nix
          ];
        };
      }) ["default" "vm" "wsl"]
    );
  };
}
