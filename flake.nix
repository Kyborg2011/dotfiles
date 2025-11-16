{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.51.0";
      # inputs.nixpkgs.follows = "nixpkgs"; # Uncomment this line if you want to pin Hyprland to the same nixpkgs version
    };
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.51.0";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "git+https://github.com/hyprwm/hyprland-plugins?submodules=1&ref=refs/tags/v0.51.0";
      inputs.hyprland.follows = "hyprland";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.hyprland.follows = "hyprland";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs"; # Mismatched system dependencies will lead to crashes and other issues.
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    firefox-mod-blur = {
      url = "github:datguypiko/Firefox-Mod-Blur";
      flake = false;
    };
    rofi-theme = {
      url = "github:adi1090x/rofi";
      flake = false;
    };
    vifm-colors = {
      url = "github:vifm/vifm-colors";
      flake = false;
    };
    vifm-devicons = {
      url = "github:thimc/vifm_devicons";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs: 
    let
      system = "x86_64-linux";
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      specialArgs = { inherit inputs pkgs-unstable; };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.anthony = import ./modules/home;
              extraSpecialArgs = specialArgs;
              backupFileExtension = "bkp7";
            };
          }
        ];
      };
    };
}
