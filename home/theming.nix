{ config, pkgs, lib, params, ... }:

let
  theme_name = "Nordic";
  icon_theme_name = "Papirus-Dark";
  cursor_theme_name = "Bibata-Modern-Ice";
  cursor_theme_pkg = pkgs.bibata-cursors;
  theme_pkg = pkgs.nordic;
  icon_theme_pkg = pkgs.papirus-icon-theme;
  home_dir = config.home.homeDirectory;
  gtk_extra_config = {
    gtk-application-prefer-dark-theme = 1;
    gtk-enable-event-sounds = 1;
    gtk-enable-input-feedback-sounds = 0;
    gtk-xft-antialias = 1;
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
    gtk-xft-rgba = "rgb";
  };
in
{
  home = {
    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      name = cursor_theme_name;
      package = cursor_theme_pkg;
      size = 24;
    };

    packages = with pkgs; [
      icon_theme_pkg
      theme_pkg
      cursor_theme_pkg
    ] ++ (with pkgs.gnomeExtensions; [
      dash-to-dock applications-menu workspace-indicator clipboard-indicator caffeine
    ]);
  };

  # gtk settings
  gtk = {
    enable = true;

    theme = {
      name = theme_name;
      package = theme_pkg;
    };

    iconTheme = {
      name = icon_theme_name;
      package = icon_theme_pkg;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
      gtk-enable-event-sounds = 1
      gtk-enable-input-feedback-sounds = 0
      gtk-xft-antialias = 1
      gtk-xft-hinting = 1
      gtk-xft-hintstyle = "hintslight"
      gtk-xft-rgba = "rgb"
    '';

    gtk3 = {
      extraConfig = gtk_extra_config;
      bookmarks = [
        "file://${home_dir}/.config Config"
        "file://${home_dir}/Documents"
        "file://${home_dir}/Dropbox"
        "file://${home_dir}/Music"
        "file://${home_dir}/Pictures"
        "file://${home_dir}/Videos"
        "file://${home_dir}/Downloads"
        "file://${home_dir}/Desktop"
        "file://${home_dir}/dev Dev"
        "file://${params.config_base_path} NixOS Config"
        "file:///etc/profiles/per-user/${config.home.username}/share/applications HM .desktop files"
        "file:///run/current-system/sw/share/applications NixOS .desktop files"
      ];
    };

    gtk4.extraConfig = gtk_extra_config;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      # Gnome Shell extensions to enable:
      enabled-extensions = [
        "gsconnect@andyholmes.github.io"
        "clipboard-indicator@tudmotu.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/desktop/wm/preferences" = {
      disable-workarounds = false;
    };

    "org/gnome/desktop/input-sources" = with lib.hm.gvariant; {
      sources = [
        (mkTuple [
          "xkb"
          "ua"
        ])
        (mkTuple [
          "xkb"
          "ru"
        ])
        (mkTuple [
          "xkb"
          "us"
        ])
      ];
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = false;
      monospace-font-name = "InputMono Nerd Font 10";
      color-scheme = "prefer-dark";
      gtk-theme = theme_name;
      icon-theme = icon_theme_name;
      cursor-theme = cursor_theme_name;  # requires Bibata cursor theme to be installed
      scaling-factor = 1;
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/applications/terminal" = {
      exec = "kitty";
      exec-arg = "";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = theme_name;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Alt>q" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-right = [ "<Super>l" ];
      switch-to-workspace-left = [ "<Super>h" ];
      toggle-fullscreen = [ "<Super>g" ];
      toggle-maximized = [ "<Super>f" ];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      mouse-button-modifier = "<Super>";
      resize-with-right-button = true;
      focus-mode = "sloppy"; # focus follows mouse hover
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    "system/locale" = {
      region = "ru_UA.UTF-8";
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/gnome/TextEditor" = {
      keybindings = "vim";
    };
  };
}
