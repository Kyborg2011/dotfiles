{ inputs, pkgs, ... } :

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    plugins = [
      #inputs.hy3.packages.${pkgs.system}.hy3
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];

    xwayland = {
      enable = true;
    };

    settings = {
      exec-once = [
        "hyprpanel"
        "systemctl --user start hyprshell.service"
        "systemctl --user start hypridle.service"
        "hyprctl setcursor Bibata-Ice-Modern 24"
      ];
      windowrulev2 = [
        # telegram media viewer
        "float, title:^(Media viewer)$"
        # gnome calculator
        "float, class:^(org.gnome.Calculator)$"
        "size 360 490, class:^(org.gnome.Calculator)$"
        # allow tearing in games
        "immediate, class:^(osu\!|cs2)$"
        # make Firefox/Zen PiP window floating and sticky
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^(Zen — Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
        # start Spotify and YouTube Music in ws9
        "workspace 9 silent, title:^(Spotify( Premium)?)$"
        "workspace 9 silent, title:^(YouTube Music)$"
        # idle inhibit while watching videos
        "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
        "idleinhibit focus, class:^(zen)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(zen)$"
        "dimaround, class:^(gcr-prompter)$"
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
        "dimaround, class:^(zen)$, title:^(File Upload)$"
        # fix xwayland apps
        "rounding 0, xwayland:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
        # Matlab
        "tile, title:MATLAB"
        "noanim on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "noblur on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "noborder on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "noshadow on, class:MATLAB, title:DefaultOverlayManager.JWindow"
      ];
    };

    extraConfig = ''
      plugin = ${inputs.hy3.packages.${pkgs.system}.hy3}/lib/libhy3.so
    '' + (builtins.readFile ./dotfiles/hypr/hyprland.conf);

    systemd = {
      enable = true;
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}