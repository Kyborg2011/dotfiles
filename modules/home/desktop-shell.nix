{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    # "hyprpanel"
    "qs --config ii"
  ];
}