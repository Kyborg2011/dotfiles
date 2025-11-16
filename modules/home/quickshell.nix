{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
  ];

  # wayland.windowManager.hyprland.settings.exec-once = [
  #   "quickshell --config ${config.home.homeDirectory}/.config/quickshell/ii/shell.qml &"
  # ];
}