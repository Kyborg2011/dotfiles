{ config, pkgs, inputs, ... }:

{
  home.file = {
    ".config/vifm/colors".source = "${inputs.vifm-colors}";
  };

  programs.vifm = {
    enable = true;
    extraConfig = ''
      colorscheme gruvbox
    '';
  };
}