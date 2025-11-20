{ inputs, config, lib, pkgs, params, ... }:

{
  home.file = {
    ".config/hyprpanel/config.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${params.config_base_path}/home/dotfiles/hyprpanel.json"
    );
  };
  home.packages = with pkgs; [ hyprpanel ];
}