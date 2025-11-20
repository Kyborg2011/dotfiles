{
  inputs,
  pkgs,
  stdenv,
  ...
}: 
stdenv.mkDerivation {
  name = "simple-bar";
  src = ./.;
  nativeBuildInputs = with pkgs; [
    wrapGAppsHook
    gobject-introspection
    inputs.ags.packages.${pkgs.system}.default
  ];
  buildInputs = [
    pkgs.glib
    pkgs.gjs
    inputs.astal.packages.${pkgs.system}.io
    inputs.astal.packages.${pkgs.system}.astal4
    inputs.astal.packages.${pkgs.system}.apps
    inputs.astal.packages.${pkgs.system}.hyprland
    inputs.astal.packages.${pkgs.system}.auth
    inputs.astal.packages.${pkgs.system}.battery
    inputs.astal.packages.${pkgs.system}.bluetooth
    inputs.astal.packages.${pkgs.system}.greet
    inputs.astal.packages.${pkgs.system}.mpris
    inputs.astal.packages.${pkgs.system}.network
    inputs.astal.packages.${pkgs.system}.notifd
    inputs.astal.packages.${pkgs.system}.tray
    inputs.astal.packages.${pkgs.system}.wireplumber
    inputs.astal.packages.${pkgs.system}.powerprofiles
  ];
  installPhase = ''
    mkdir -p $out/bin
    ags bundle --gtk 3 app.ts $out/bin/simple-bar
  '';
}