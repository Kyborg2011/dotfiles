{ config, pkgs, pkgs-unstable, inputs, lib, params, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.twilight
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
    ./typora.nix
    ./desktop-shell.nix
  ];

  news.display = "show";

  home = rec {
    username = params.default_username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";

    packages = with pkgs; [
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
      pavucontrol
      dmenu-wayland mc timg
      flameshot
      obsidian

      # Disk space management tools:
      ncdu dust pkgs.kdePackages.filelight

      # Dev tools:
      tldr wget curl
      jq killall ripgrep fd bat
      parallel-full

      # Development:
      github-desktop
      icon-library
      jetbrains-toolbox

      # Languages:
      bun
      gjs
      typescript yarn
      eslint
      nodejs
      nodePackages.prettier
      cargo rustc rustfmt rust-analyzer
      ccls
      cmake gcc gnumake gdb clang-tools
      autoconf automake autogen pkg-config
      libpkgconf autoconf-archive libtool m4
      ktlint quick-lint-js
      watchman
      qtox

      # Custom fonts (Input Mono + Rofi custom theme fonts):
      (pkgs.callPackage ./custom-fonts { inherit inputs; })
    ];

    sessionVariables = {
      BROWSER = params.default_browser;
      LEDGER_FILE = params.ledger_journal_path;
      HIST_STAMPS = "dd.mm.yyyy";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      _ZL_MATCH_MODE = 1;
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      QT_STYLE_OVERRIDE = "kvantum";
      QT_QPA_PLATFORMTHEME = "qt5ct";
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
      package = pkgs.kdePackages.kdeconnect-kde;
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
    zen-browser.enable = true; # Depends on inputs.zen-browser
    git = {
      enable = true;
      package = pkgs.git;
      userName = params.git_username;
      userEmail = params.git_email;
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

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvGnomish
    '';
  };
  
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
