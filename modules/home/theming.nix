{ config, pkgs, ...}:
let
  catppuccin_name = "Catppuccin-Mocha";
  catppuccin = pkgs.catppuccin-gtk.override {
    size = "standard";
    variant = "mocha";
  };
in {
  # gtk settings
  gtk = {
    enable = true;
    theme = {
      name = catppuccin_name;
      package = catppuccin;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.bookmarks = let
      home = config.home.homeDirectory;
    in [
      "file://${home}/Documents"
      "file://${home}/Music"
      "file://${home}/Pictures"
      "file://${home}/Videos"
      "file://${home}/Downloads"
      "file://${home}/Desktop"
      "file://${home}/Dropbox"
      "file://${home}/.config Config"
    ];
  };
}
