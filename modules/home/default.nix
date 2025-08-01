{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./mimelist.nix
    ./shell.nix
    ./vim.nix
    ./vscode.nix
    ./kitty.nix
    ./theming.nix
    ./hyprland.nix
    ./hyprpanel.nix
    ./hyprshell.nix
    ./wallpaper-manager.nix
  ];

  news.display = "show";

  home = rec {
    username = "anthony";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";

    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

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
      hyprsysteminfo
      mc

      # Development:
      figma-linux
      github-desktop
      icon-library

      # Languages:
      bun
      gjs
      typescript
      eslint
      nodejs

      # Custom font (Input Mono):
      (pkgs.callPackage ./custom-fonts { })
    ];

    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      LEDGER_FILE = "$HOME/Dropbox/09 Business/06 Ledger/main.journal";
      HIST_STAMPS = "dd.mm.yyyy";
      ELECTRON_OZONE_PLATFORM_HINT = "auto"; 
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
      "$HOME/.yarn/bin"
      "/usr/local/go/bin"
      "$HOME/go/bin"
    ];

    file = {
      ".config/Code/User/settings.json".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/Code/settings.json"
      );
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
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

  programs = {
    home-manager.enable = true;
    qutebrowser.enable = true;
    ranger.enable = true;
    sagemath.enable = true;
    mpv.enable = true;
    lf.enable = true;
    go.enable = true;
    hexchat.enable = true;
    htop.enable = true;
    btop.enable = true;
    gpg.enable = true;
    joplin-desktop.enable = true;
    java.enable = true;
    git = {
      enable = true;
      package = pkgs.git;
      userName = "kyborg2011";
      userEmail = "wkyborgw@gmail.com";
    };
    eclipse = {
      enable = true;
      package = pkgs.eclipses.eclipse-sdk;
    };
    nheko.enable = true;
    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };
    superfile.enable = true;
    wofi = {
      enable = true;
      package = pkgs.wofi;
      settings = {
        gtk_dark = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
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

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  fonts.fontconfig.enable = true;
}
