{ config, pkgs, ...}:
let
  theme_name = "Nordic";
  theme_pkg = pkgs.nordic;
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
      '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk3.bookmarks = let
      home = config.home.homeDirectory;
    in [
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
}
