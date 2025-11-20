{ config, pkgs, inputs, ... }:

{
  home.file = {
    ".config/vifm/colors".source = "${inputs.vifm-colors}";
  };

  programs.vifm = {
    enable = true;
    extraConfig = (builtins.readFile ./dotfiles/vifmrc) + ''
      source ${inputs.vifm-devicons}/favicons.vifm
    '';
  };
}