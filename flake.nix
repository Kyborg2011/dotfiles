{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.51.0";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprsunset.url = "github:hyprwm/hyprsunset";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

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
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
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
              backupFileExtension = "bkp4";
            };
          }
        ];
      };
    };
}
