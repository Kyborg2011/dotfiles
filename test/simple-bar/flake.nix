{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ags.url = "github:aylur/ags";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, ags, nixgl }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        nixgl.packages.${system}.nixGLIntel
        (ags.packages.${system}.default.override { 
          extraPackages = [
            ags.packages.${pkgs.system}.apps
            ags.packages.${pkgs.system}.hyprland
            ags.packages.${pkgs.system}.auth
            ags.packages.${pkgs.system}.battery
            ags.packages.${pkgs.system}.bluetooth
            ags.packages.${pkgs.system}.greet
            ags.packages.${pkgs.system}.mpris
            ags.packages.${pkgs.system}.network
            ags.packages.${pkgs.system}.notifd
            ags.packages.${pkgs.system}.tray
            ags.packages.${pkgs.system}.wireplumber
            ags.packages.${pkgs.system}.powerprofiles
          ];
        })
      ];
    };
  };
}
