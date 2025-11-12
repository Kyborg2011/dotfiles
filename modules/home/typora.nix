{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  home = {
    file = {
      ".config/typora-flags.conf".text = ''
        --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3
      '';
    };
    packages = [ pkgs-unstable.typora ];
  };
}