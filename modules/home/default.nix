{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {

  imports = [
    ./zsh.nix
    ./vim.nix
    ./vscode.nix
    ./kitty.nix
    ./theming.nix
    ./hyprpanel.nix
  ];

  services.gnome-keyring.enable = true;

  home = {
    username = "anthony";
    homeDirectory = "/home/anthony";
    stateVersion = "24.05";
    packages = with pkgs; [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast 
      inputs.hyprpicker.packages.${pkgs.system}.hyprpicker 
      inputs.hyprsunset.packages.${pkgs.system}.hyprsunset 
      inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
      inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
      wofi
      wl-clipboard
      wf-recorder
      cliphist
      catppuccin-gtk
      z-lua
      d2
      apacheHttpdPackages.subversion
      killall
      gnome-control-center
      brightnessctl
      filezilla
      tree
      freecad
      youtube-music
      pavucontrol
      nerd-fonts.jetbrains-mono
      dmenu-wayland
      (pkgs.callPackage ./custom-fonts { })
    ];
    sessionVariables = {
      GTK_THEME = "catppuccin-mocha-blue-standard";
    };
  };

  home.file.".config/Code/User/settings.json".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/Code/settings.json"
  );

  home.pointerCursor = {
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  programs.home-manager.enable = true;
  programs.mpv.enable = true;

  programs.wofi = {
    enable = true;
    package = pkgs.wofi;
    settings = {
      gtk_dark = true;
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

  programs.qutebrowser.enable = true;
  programs.ranger.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "kyborg2011";
    userEmail = "wkyborgw@gmail.com";
  };

  programs.gpg = {
    enable = true;
  };

  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";

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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  fonts.fontconfig.enable = true;

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      disable-workarounds = false;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

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
      exec-once = [
        "hyprpanel"
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
