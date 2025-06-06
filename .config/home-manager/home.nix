{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  nixGL = {
    packages = inputs.nixGL.packages; # you must set this or everything will be a noop
    defaultWrapper = "mesa"; # choose from nixGL options depending on GPU
  };

  home = {
    username = "anthony";
    homeDirectory = "/home/anthony";
    stateVersion = "24.05";
    packages = with pkgs; [
      (config.lib.nixGL.wrap inputs.hyprland-contrib.packages.${pkgs.system}.grimblast) 
      (config.lib.nixGL.wrap inputs.hyprpicker.packages.${pkgs.system}.hyprpicker) 
      (config.lib.nixGL.wrap inputs.hyprsunset.packages.${pkgs.system}.hyprsunset) 
      (config.lib.nixGL.wrap inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent) 
      (config.lib.nixGL.wrap inputs.hyprpaper.packages.${pkgs.system}.hyprpaper) 
    ];
  };

  home.pointerCursor = {
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  programs.home-manager.enable = true;

  programs.hyprlock = {
    enable = true;
    package = config.lib.nixGL.wrap inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
        no_fade_in = false;
        enable_fingerprint = false;
      };

      background = [
        {
          path = "/home/anthony/.config/home-manager/images/hyprlock_background.jpg";
        }
      ];

      input-field = [
        {
          size = "300, 50";
          valign = "bottom";
          position = "0%, 200px";

          outline_thickness = 1;

          outer_color = "rgba(0, 0, 0, 1.0)";
          inner_color = "rgb(f2f3f4)";
          font_color = "rgba(0, 0, 0, 1.0)";
          check_color = "rgba(0, 0, 0, 1.0)";
          fail_color = "rgba(255, 0, 0, 0.8)";

          fade_on_empty = false;
          placeholder_text = "Enter Password";

          dots_spacing = 0.2;
          dots_center = true;
          dots_fade_time = 100;

          shadow_color = "rgba(0, 0, 0, 0.1)";
          shadow_size = 7;
          shadow_passes = 1;
        }
      ];

      label = [
        {
          text = "$TIME";
          font_size = 150;
          color = "rgb(b6c4ff)";

          position = "0%, 200px";

          valign = "center";
          halign = "center";
        }
        {
          text = "cmd[update:3600000] date +'%a %b %d'";
          font_size = 20;
          color = "rgb(b6c4ff)";

          position = "0%, 0";

          valign = "center";
          halign = "center";
        }
      ];
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  #systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {
      general = {
        lock_cmd = "/usr/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 150;                                  # 2.5min.
          on-timeout = "brightnessctl -s set 10";         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r";                 # monitor backlight restore.
        }

        {
          timeout = 150;                                            # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
        }

        {
          timeout = 300;                                    # 5min
          on-timeout = "loginctl lock-session";             # lock screen when timeout has passed
        }

        {
          timeout = 330;                                    # 5.5min
          on-timeout = "hyprctl dispatch dpms off";         # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on";           # screen on when activity is detected after timeout has fired.
        }
      ];
    };
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [ inputs.hy3.packages.${pkgs.system}.hy3 ];
    xwayland = {
      enable = true;
    };
    settings = {
      exec-once = [
        "systemctl --user start hypridle.service"
        "hyprctl setcursor Bibata-Ice-Modern 24"
      ];
      xwayland.force_zero_scaling = true;
      bind = [
        #", Print, exec, grimblast --notify copysave area"
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
    extraConfig = (builtins.readFile ./dotfiles/hypr/hyprland.conf);
    systemd = {
      enable = false;
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
