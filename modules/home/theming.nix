{ config, pkgs, lib, ...}:

let
  theme_name = "Nordic";
  theme_pkg = pkgs.nordic;
  home = config.home.homeDirectory;
  gtk_extra_config = {
    gtk-application-prefer-dark-theme = 1;
    gtk-enable-event-sounds = 1;
    gtk-enable-input-feedback-sounds = 0;
    gtk-xft-antialias = 1;
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
    gtk-xft-rgba = "rgb";
  };
in {
  # gtk settings
  gtk = {
    enable = true;
    
    theme = {
      name = theme_name;
      package = theme_pkg;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
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
        "file://${home}/.config Config"
        "file://${home}/Documents"      
        "file://${home}/Dropbox"
        "file://${home}/Music"
        "file://${home}/Pictures"
        "file://${home}/Videos"
        "file://${home}/Downloads"
        "file://${home}/Desktop"
        "file://${home}/dev Dev"
      ];
    };

    gtk4.extraConfig = gtk_extra_config;
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      disable-workarounds = false;
    };

    "org/gnome/desktop/input-sources" = with lib.hm.gvariant; {
      sources = [
        (mkTuple ["xkb" "ua"])
        (mkTuple ["xkb" "ru"])
        (mkTuple ["xkb" "us"])
      ];
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      monospace-font-name = "InputMono Nerd Font 10";
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Alt>q"];
      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      move-to-workspace-5 = ["<Shift><Super>5"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-right = ["<Super>l"];
      switch-to-workspace-left = ["<Super>h"];
      toggle-fullscreen = ["<Super>g"];
      toggle-maximized = ["<Super>f"];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
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
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    "org/gnome/TextEditor" = {
      keybindings = "vim";
    };
  };
}
