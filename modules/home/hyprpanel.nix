{ inputs, config, lib, pkgs, ... }:

{
  home.file = {
    ".config/hyprpanel/config.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/hyprpanel.json"
    );
  };
  home.packages = with pkgs; [ hyprpanel ];
  wayland.windowManager.hyprland.settings.exec-once = [ "hyprpanel" ];
  #programs.hyprpanel.enable = true;
}