{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [ rofi-wayland ];
  home.file = {
    ".config/rofi".source = "${inputs.rofi-theme}/files";
  };
}
