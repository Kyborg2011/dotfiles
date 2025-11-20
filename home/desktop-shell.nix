{ config, pkgs, lib, params, ... }:

{
  home.file = {
    ".config/quickshell".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${params.config_base_path}/home/dotfiles/quickshell"
    );
    ".config/illogical-impulse/config.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${params.config_base_path}/home/dotfiles/quickshell-config.json"
    );
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    # "hyprpanel"
    "qs --config ii"
  ];
}