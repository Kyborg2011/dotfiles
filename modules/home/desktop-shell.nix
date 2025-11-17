{ config, pkgs, lib, ... }:

{
  home.file = {
    ".config/quickshell".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/quickshell"
    );
    ".config/illogical-impulse/config.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/quickshell-config.json"
    );
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    # "hyprpanel"
    "qs --config ii"
  ];
}