{ config, pkgs, inputs, ... }:

let
  colors_theme = "gruvbox"; # gruvbox, nord, onedark, solarized, catppuccin, adapta, cyberpunk, everforest, navy, paper, black, dracula, lovelace, yousai
  rofi_main_config = builtins.replaceStrings [
    "shared/colors.rasi"
    "shared/fonts.rasi"
  ] [
    "~/.config/rofi/colors/${colors_theme}.rasi"
    "~/.config/rofi/launchers/type-1/shared/fonts.rasi"
  ] (builtins.readFile "${inputs.rofi-theme}/files/launchers/type-1/style-5.rasi");
in {
  home.packages = with pkgs; [ rofi-wayland ];
  home.file = {
    ".config/rofi".source = "${inputs.rofi-theme}/files";
    ".config/rofi-launcher.rasi".text = rofi_main_config + ''
      button {
        padding: 5px 12px 5px 8px;
      }
      textbox-prompt-colon {
        padding: 5px 5px;
      }
    '';
  };
}
