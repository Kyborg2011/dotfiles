{
  inputs,
  pkgs,
  ...
}: inputs.ags.lib.bundle {
  inherit pkgs;
  src = ./.;
  name = "simple-bar"; # name of executable
  entry = "app.ts";
  gtk4 = false;

  extraPackages = [
    inputs.ags.packages.${pkgs.system}.apps
    inputs.ags.packages.${pkgs.system}.hyprland
    inputs.ags.packages.${pkgs.system}.auth
    inputs.ags.packages.${pkgs.system}.battery
    inputs.ags.packages.${pkgs.system}.bluetooth
    inputs.ags.packages.${pkgs.system}.greet
    inputs.ags.packages.${pkgs.system}.mpris
    inputs.ags.packages.${pkgs.system}.network
    inputs.ags.packages.${pkgs.system}.notifd
    inputs.ags.packages.${pkgs.system}.tray
    inputs.ags.packages.${pkgs.system}.wireplumber
    inputs.ags.packages.${pkgs.system}.powerprofiles
  ];
}