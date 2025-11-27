{ config, pkgs, pkgs-unstable, inputs, lib, params, ... }:

{
  home.file = {
    ".config/quickshell".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${params.config_base_path}/home/dotfiles/quickshell"
    );
    ".config/illogical-impulse/config.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${params.config_base_path}/home/dotfiles/quickshell-config.json"
    );
  };

  home.packages = with pkgs; [
    # For Quickshell usage:
    swappy tesseract imagemagick translate-shell libnotify libcava libdbusmenu-gtk3 playerctl matugen

    # Quickshell with Qt dependencies bundled:
    (pkgs-unstable.callPackage ./quickshell.nix { inherit inputs pkgs-unstable; })
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    # "hyprpanel"
    "qs --config ii"
  ];
}