{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.49.0";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.49.0";
      inputs.hyprland.follows = "hyprland";
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

    ags.url = "github:aylur/ags";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.anthony = import ./modules/home;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
