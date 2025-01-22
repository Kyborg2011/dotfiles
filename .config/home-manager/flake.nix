{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.46.0";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.46.0";
      inputs.hyprland.follows = "hyprland";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprsunset.url = "github:hyprwm/hyprsunset";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
    };
  };

  outputs = inputs@ {
    nixpkgs,
    home-manager,
    ...
  }: {
    # Replace with your own username
    homeConfigurations."anthony" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        ./home.nix
      ];
    };
  };
}
