{ inputs, lib, ... }:

{
  home.file = {
    ".config/hyprpanel/config.json".source = 
      lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/hyprpanel.json";
  };
  programs.hyprpanel.enable = true;
}