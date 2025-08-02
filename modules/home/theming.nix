{ config, pkgs, ...}:

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
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
