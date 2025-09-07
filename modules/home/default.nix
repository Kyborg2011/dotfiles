{ config, pkgs, pkgs-unstable, inputs, lib, ... }:

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
    ./wallpaper-manager.nix
    ./browser.nix
    ./rofi.nix
    ./vifm.nix
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
      hyprdim

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
      kdePackages.filelight
      timg

      # Development:
      figma-linux
      github-desktop
      icon-library
      jetbrains-toolbox

      # Languages:
      bun
      gjs
      typescript
      eslint
      nodejs
      nodePackages.prettier
      cargo rustc rustfmt rust-analyzer
      ccls
      cmake gcc

      # Custom fonts (Input Mono + Rofi custom theme fonts):
      (pkgs.callPackage ./custom-fonts { inherit inputs; })
    ];

    sessionVariables = {
      BROWSER = "firefox-dev";
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      LEDGER_FILE = "$HOME/Dropbox/09 Business/06 Ledger/main.journal";
      HIST_STAMPS = "dd.mm.yyyy";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      _ZL_MATCH_MODE = 1;
    };

    sessionPath = [
      "/usr/local/bin"
      "/usr/local/go/bin"
      "$HOME/.local/share/JetBrains/Toolbox/scripts"
      "$HOME/.npm/bin"
      "$HOME/.yarn/bin"
      "$HOME/go/bin"
    ];
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
    udiskie.enable = true;
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
    aerc.enable = true;
    superfile.enable = true;
    nheko.enable = true;
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
    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };
    wofi = {
      enable = true;
      package = pkgs.wofi;
      settings = {
        gtk_dark = true;
      };
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;  # Emacs with pure GTK support. Better for Wayland.
      extraConfig = ''
        (setq standard-indent 2)
      '';
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
