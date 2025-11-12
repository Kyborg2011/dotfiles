{ config, inputs, pkgs, lib, ... } :

let
  hyprlayout-fix = pkgs.writeShellScriptBin "hyprlayout-fix" ''
    while ! hyprctl clients | grep "jetbrains-toolbox"
    do
      sleep 1
      echo "waiting for openning of windows..."
    done
    sleep 1
    hyprctl dispatch movetoworkspacesilent "special,floating"
    hyprctl dispatch resizewindowpixel "exact 38% 100%,class:org.telegram.desktop"
    hyprctl dispatch resizewindowpixel "exact 31% 100%,class:kitty"
    hyprctl dispatch focuswindow "class:kitty"
    hyprctl dispatch "hy3:movewindow" r
    hyprctl dispatch focuswindow "class:org.telegram.desktop"
    hyprctl dispatch "hy3:movewindow" r
  '';
in {
  home.packages = with pkgs; [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    inputs.hyprsunset.packages.${pkgs.system}.hyprsunset
    inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    hyprdim
    hyprprop
    hyprsysteminfo
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    plugins = [
      inputs.hy3.packages.${pkgs.system}.hy3
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];

    xwayland = {
      enable = true;
    };

    settings = {
      ################
      ### MONITORS ###
      ################
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        ",preferred,auto,auto"
      ];

      ###################
      ### MY PROGRAMS ###
      ###################
      # Set programs that you use
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";
      "$term" = "kitty";
      "$browser" = "firefox-dev";
      "$editor" = "vim";
      "$launcher" = "${pkgs.rofi-wayland}/bin/rofi -show drun -theme $HOME/.config/rofi-launcher.rasi";
      "$clipboard" = "cliphist list | wofi -S dmenu | cliphist decode | wl-copy";

      "$default_keyboard_device" = "at-translated-set-2-keyboard";

      #################
      ### AUTOSTART ###
      #################
      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:
      exec = [
        "wl-paste --watch cliphist store"
      ];
      
      exec-once = [
        #"hyprdim &"
        "systemctl --user start hyprshell.service"
        "systemctl --user start hypridle.service"
        "hyprctl setcursor Bibata-Ice-Modern 24"
        "nm-applet --indicator"
        "hyprpm reload -n"
        "dropbox"
        "jetbrains-toolbox"
        "[workspace 1 silent] $terminal"
        "[workspace 1 silent] $browser"
        "[workspace 2 silent] google-chrome-stable"
        "[workspace 2 silent] telegram-desktop"
        "[workspace 3 silent] ${config.home.homeDirectory}/.local/share/JetBrains/Toolbox/apps/android-studio/bin/studio"
        "[workspace 5 silent] QT_QPA_PLATFORM=wayland okular"
        "[workspace 5 silent] xdg-launch zen-twilight.desktop"
        "[workspace 6 silent] evolution"
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "nohup ${hyprlayout-fix}/bin/hyprlayout-fix &"
      ];

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################
      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "NIXOS_OZONE_WL,1"
        "NIXPKGS_ALLOW_UNFREE,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SDL_VIDEODRIVER,x11"
        "MOZ_ENABLE_WAYLAND,1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "MOZ_WEBRENDER,1"
      ];

      #####################
      ### LOOK AND FEEL ###
      #####################
      # Refer to https://wiki.hyprland.org/Configuring/Variables/
      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
        layout = "hy3";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 5;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
      # "Smart gaps" / "No gaps when only"
      # uncomment all if you wish to use that.
      # workspace = w[tv1], gapsout:0, gapsin:0
      # workspace = f[1], gapsout:0, gapsin:0
      # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
      # windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
      # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
      # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };

      binds = {
        allow_workspace_cycles = true;
      };

      #############
      ### INPUT ###
      #############
      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us,ru,ua";
        kb_variant = "";
        kb_model = "";
        kb_options = "grp:win_space_toggle";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        scroll_method = "2fg";
        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
        };
      };

      # "https://wiki.hypr.land/Configuring/Gestures/"
      gesture = [
        "3, horizontal, workspace,"
      ];

      ###################
      ### KEYBINDINGS ###
      ###################
      # See https://wiki.hyprland.org/Configuring/Keywords/
      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

      bind = [
        "$mainMod, SUPER_L, exec, $launcher"
        "ALT, F1, exec, $launcher"
        "$mainMod, W, exec, $browser"
        "$mainMod, F, exec, $fileManager"
        "$mainMod, T, exec, $term"
        "ALT, C, exec, $clipboard"
        
        "$mainMod, I, pin"
        "$mainMod+SHIFT, M, exit,"
        "$mainMod+SHIFT, Space, togglefloating,"
        "$mainMod+SHIFT, C, exec, hyprctl reload"
        
        "$mainMod+SHIFT, m, exit"
        
        "$mainMod, return, exec, $term"
        "$mainMod+SHIFT, q, hy3:killactive"
        
        "$mainMod, bracketleft, workspace, m-1"
        "$mainMod, bracketright, workspace, m+1"
        
        "$mainMod+SHIFT, f, fullscreen, 1"
        "$mainMod+CONTROL, f, fullscreen, 0"
        
        "$mainMod, h, hy3:makegroup, h"
        "$mainMod, v, hy3:makegroup, v"
        "$mainMod+SHIFT, w, hy3:changegroup, toggletab"
        "$mainMod, a, hy3:changefocus, raise"
        "$mainMod+SHIFT, a, hy3:changefocus, lower"
        "$mainMod, e, hy3:expand, expand"
        "$mainMod+SHIFT, e, hy3:expand, base"
        "$mainMod+SHIFT, z, movetoworkspacesilent, special"
        "$mainMod, z, togglespecialworkspace"

        "ALT, Tab, exec, hyprctl dispatch focuscurrentorlast; hyprctl dispatch alterzorder top"
        
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioStop, exec, playerctl -a stop"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
        
        "$mainMod, h, hy3:movefocus, l, nowarp"
        "$mainMod, j, hy3:movefocus, d, nowarp"
        "$mainMod, k, hy3:movefocus, u, nowarp"
        "$mainMod, l, hy3:movefocus, r, nowarp"
        "$mainMod, left, hy3:movefocus, l, nowarp"
        "$mainMod, down, hy3:movefocus, d, nowarp"
        "$mainMod, up, hy3:movefocus, u, nowarp"
        "$mainMod, right, hy3:movefocus, r, nowarp"
        
        "$mainMod+SHIFT, h, hy3:movewindow, l, once"
        "$mainMod+SHIFT, j, hy3:movewindow, d, once"
        "$mainMod+SHIFT, k, hy3:movewindow, u, once"
        "$mainMod+SHIFT, l, hy3:movewindow, r, once"
        "$mainMod+SHIFT, left, hy3:movewindow, l, once"
        "$mainMod+SHIFT, down, hy3:movewindow, d, once"
        "$mainMod+SHIFT, up, hy3:movewindow, u, once"
        "$mainMod+SHIFT, right, hy3:movewindow, r, once"
        
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        "$mainMod+SHIFT, 1, hy3:movetoworkspace, 1"
        "$mainMod+SHIFT, 2, hy3:movetoworkspace, 2"
        "$mainMod+SHIFT, 3, hy3:movetoworkspace, 3"
        "$mainMod+SHIFT, 4, hy3:movetoworkspace, 4"
        "$mainMod+SHIFT, 5, hy3:movetoworkspace, 5"
        "$mainMod+SHIFT, 6, hy3:movetoworkspace, 6"
        "$mainMod+SHIFT, 7, hy3:movetoworkspace, 7"
        "$mainMod+SHIFT, 8, hy3:movetoworkspace, 8"
        "$mainMod+SHIFT, 9, hy3:movetoworkspace, 9"
        "$mainMod+SHIFT, 0, hy3:movetoworkspace, 10"
        
        "$mainMod+CONTROL, 1, hy3:focustab, index, 1"
        "$mainMod+CONTROL, 2, hy3:focustab, index, 2"
        "$mainMod+CONTROL, 3, hy3:focustab, index, 3"
        "$mainMod+CONTROL, 4, hy3:focustab, index, 4"
        "$mainMod+CONTROL, 5, hy3:focustab, index, 5"
        "$mainMod+CONTROL, 6, hy3:focustab, index, 6"
        "$mainMod+CONTROL, 7, hy3:focustab, index, 7"
        "$mainMod+CONTROL, 8, hy3:focustab, index, 8"
        "$mainMod+CONTROL, 9, hy3:focustab, index, 9"
        "$mainMod+CONTROL, 0, hy3:focustab, index, 10"
        
        "$mainMod, n, exec, killall -q hyprsunset; hyprsunset -t 4900 &"
        "$mainMod+SHIFT, n, exec, killall -q hyprsunset; hyprsunset -t 6000 &"
        "$mainMod+SHIFT, p, exec, hyprpicker -a"
        
        "$mainMod, grave, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable

        # SCREENSHOT:
        ", Print, exec, grimblast --notify copysave area"
        "$mainMod, Print, exec, grimblast --notify copysave screen"
        "$mainMod+SHIFT, Print, exec, grimblast --notify copysave active"
        
        # RESET KEYBOARD LAYOUT TO DEFAULT (ENGLISH):
        "$mainMod+ALT, Space, exec, hyprctl switchxkblayout $default_keyboard_device 0"

        # Resize submap:
        # will switch to a submap called resize
        "$mainMod, R, submap, resize"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindn = [
        ", mouse:272, hy3:focustab, mouse"
        ", mouse_down, hy3:focustab, l, require_hovered"
        ", mouse_up, hy3:focustab, r, require_hovered"
      ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################
      
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
      
      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = [
        # telegram media viewer
        "float, title:^(Media viewer)$"
        # gnome calculator class:
        "float, class:^(org.gnome.Calculator)$"
        "size 360 490, class:^(org.gnome.Calculator)$"
        # qalculate float:
        "float, class:^(qalculate.*)$"
        # allow tearing in games
        "immediate, class:^(osu\!|cs2)$"
        # make Firefox/Zen PiP window floating and sticky
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "opacity 1.0 override 0.5 override, title:^(Picture-in-Picture)$"
        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^(Zen — Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
        # idle inhibit while watching videos
        "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
        "idleinhibit focus, class:^(zen)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(zen)$"
        "dimaround, class:^(gcr-prompter)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
        "dimaround, class:^(zen)$, title:^(File Upload)$"
        # fix xwayland apps
        "rounding 0, xwayland:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
        # fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "float, class:^(opensnitch_ui)$"
        "dimaround, class:^(opensnitch_ui)$"
        "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "dimaround, class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "float, class:^(gcr-prompter)$"
        "dimaround, class:^(gcr-prompter)$"
        "float, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "size 1000 700, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "center, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "dimaround, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        # Matlab
        "tile, title:MATLAB"
        "noanim on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "noblur on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "noborder on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "noshadow on, class:MATLAB, title:DefaultOverlayManager.JWindow"
        "suppressevent maximize, class:.*"
        # KeePassXC float:
        "float, class:^(org.keepassxc.KeePassXC)$"
        # Transmission float:
        "float, class:^(transmission.*)$"
        # Fix "Open file" dialogs in GTK apps:
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "float, class:^(xdg-desktop-portal-gtk)$"
        "center, class:^(xdg-desktop-portal-gtk)$"
        "size 900 550, class:^(xdg-desktop-portal-gtk)$"
        # Fix some "About" windows:
        "float, initialTitle:^((About|about|О|о|Select a|Выберите).*)$"
        "center, initialTitle:^((About|about|О|о|Select a|Выберите).*)$"
        # Fix KDEConnect windows:
        "float, class:^(org.kde.kdeconnect.daemon)$"
        "center, class:^(org.kde.kdeconnect.daemon)$"
        "float, class:^(org.kde.kdeconnect-indicator)$"
        "center, class:^(org.kde.kdeconnect-indicator)$"
        # Nautilus file manager properties window:
        "float, class:^(org.gnome.Nautilus)$"
        "center, class:^(org.gnome.Nautilus)$"
        "size 1200 720, class:^(org.gnome.Nautilus)$"
        # Firefox History/Downloads/Bookmarks windows:
        "float, class:^(firefox-devedition)$, title:Library"
        # Ristretto Image Viewer:
        "float, class:^(ristretto)$"
        # Mpv media player:
        "float, class:^(mpv)$"
        "center, class:^(mpv)$"
        # qBittorrent:
        "float, class:^(org.qbittorrent.qBittorrent)$"
        "center, class:^(org.qbittorrent.qBittorrent)$"
      ];

      layerrule = [
        "abovelock true, notifications-window"
        "order 100, notifications-window"
      ];

      plugin = {
        hy3 = {
          tabs = {
            height = 2;
            padding = 6;
            render_text = false;
          };
          autotile = {
            enable = true;
            trigger_width = 800;
            trigger_height = 500;
          };
        };
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1
          enable_gesture = true; # laptop touchpad
          gesture_fingers = 3; # 3 or 4
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
      };
    };

    extraConfig = ''
      # Resize submap:
      #
      # will switch to a submap called resize
      bind = $mainMod, R, submap, resize

      # will start a submap called "resize"
      submap = resize

      # sets repeatable binds for resizing the active window
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10

      # use reset to go back to the global submap
      bind = , escape, submap, reset 

      # will reset the submap, which will return to the global submap
      submap = reset
    '';

    systemd = {
      enable = true;
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
        no_fade_in = false;
        enable_fingerprint = false;
      };

      background = [
        { path = "${config.home.homeDirectory}/.config/home-manager/images/hyprlock_background.jpg"; }
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

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {
      general = {
        lock_cmd = "hyprlock";
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

  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
}