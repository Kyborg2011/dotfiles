# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, pkgs, pkgs-unstable, params, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ###################### HARDWARE ###########################
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        intel-vaapi-driver
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false; # For old GPUs like Nvidia Quadro M1200
      nvidiaSettings = true;
      # Force Intel GPU for display:
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        # Use one of the following options:
        sync.enable = true;  # for perfomance
        offload.enable = false;  # for powersave
      };
    };
    alsa.enablePersistence = true;
    enableAllFirmware = true;
  };

  ##################### BOOTLOADER ##########################
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_stable;
    kernelParams = [
      "usbcore.autosuspend=-1"
      "snd-intel-dspcfg.dsp_driver=1"
      # "systemd.log_level=debug" 
      # "systemd.log_target=console"
    ];
    kernelModules = [
      "snd-hda-intel"
      "usbnet"
      "cdc_ether"
      "r8152"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ virtualbox ];
    kernel.sysctl = {
      "vm.swappiness" = 180; # zram is relatively cheap, prefer swap
      "vm.page-cluster" = 0; # zram is in memory, no need to readahead
      "vm.dirty_background_bytes" = 128 * 1024 * 1024; # Start asynchronously writing at 128 MiB dirty memory
      "vm.dirty_ratio" = 50; # Start synchronously writing at 50% dirty memory
      "vm.dirty_bytes" = 64 * 1024 * 1024;
      "vm.vfs_cache_pressure" = 500;
    };
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 4;
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };
  };
  
  documentation.nixos.enable = true;

  # Allow unfree packages:
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "ventoy-gtk3-1.1.05"
        "ventoy-1.1.05"
        "olm-3.2.16"
        "libsoup-2.74.3"
        "python3.12-youtube-dl-2021.12.17"
      ];
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 8080 631 7236 7250 ];
      allowedUDPPorts = [ 53 631 7236 5353 ];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
      trustedInterfaces = [ "p2p-wl+" ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_UA.UTF-8";
    LC_IDENTIFICATION = "ru_UA.UTF-8";
    LC_MEASUREMENT = "ru_UA.UTF-8";
    LC_MONETARY = "ru_UA.UTF-8";
    LC_NAME = "ru_UA.UTF-8";
    LC_NUMERIC = "ru_UA.UTF-8";
    LC_PAPER = "ru_UA.UTF-8";
    LC_TELEPHONE = "ru_UA.UTF-8";
    LC_TIME = "ru_UA.UTF-8";
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    podman.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    # unlock keyring on login
    pam.services = {
      astal-auth = {};
      gdm.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
      passwd.enableGnomeKeyring = true;
    };
  };

  programs = {
    nm-applet.enable = true;
    gamemode.enable = true;
    system-config-printer.enable = true;
    dconf.enable = true;
    xfconf.enable = true;
    file-roller.enable = true;
    zsh.enable = true;
    mtr.enable = true;
    virt-manager.enable = true;
    ydotool.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # npm = {
    #   enable = true;
    #   package = pkgs.nodejs;
    # };
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          # missing libraries here, e.g.: `pkgs.libepoxy`
        ];
      };
    };
    # steam = {
    #   enable = true;
    #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
  };

  # List services that you want to enable:
  services = {
    fwupd.enable = true;
    thermald.enable = true;
    gvfs.enable = true;
    envfs.enable = true;
    timesyncd.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    tumbler.enable = true;
    libinput.enable = true;
    flatpak.enable = true;
    pulseaudio.enable = false;
    blueman.enable = true;
    sysprof.enable = true;
    yubikey-agent.enable = true;
    pcscd.enable = true;
    userborn.enable = true;
    dbus.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        # PermitRootLogin = "yes";
      };
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      localsearch.enable = true;
      tinysparql.enable = true;
      core-developer-tools.enable = true;
      gnome-browser-connector.enable = true;
      sushi.enable = true;
    };
    # nginx = {
    #   enable = true;
    #   virtualHosts.localhost = {
    #     locations."/" = {
    #       return = "200 '<html><body>It works</body></html>'";
    #       extraConfig = ''
    #         default_type text/html;
    #       '';
    #     };
    #   };
    # };
    # mysql = {
    #  enable = true;
    #  package = pkgs.mariadb;
    # };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us,ru,ua";
        options = "grp:win_space_toggle";
      };
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      videoDrivers = [ "modesetting" "nvidia" ];
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      enableJIT = true;
    };
  };

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Configuring KDE Plasma 6:
  # services = {
  #   desktopManager.plasma6.enable = true;
  #   displayManager.sddm.enable = true;
  #   displayManager.sddm.wayland.enable = true;
  # };
  # To resolve "programs.ssh.askPassword":
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  services = {
    # Enable the NixOS printing service for HP printers:
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip gutenprint ];
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      logLevel = "debug";
      browsedConf = ''
        BrowseDNSSDSubTypes _cups,_print
        BrowseLocalProtocols all
        BrowseRemoteProtocols all
        CreateIPPPrinterQueues All
        BrowseProtocols all
      '';
    };
    # For all IPP printers (printing without installing drivers):
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      allowPointToPoint = true;
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anthony = {
    isNormalUser = true;
    description = "Anthony";
    extraGroups = [
      "wheel"
      "networkmanager"
      "adbusers"
      "kvm"
      "video"
      "render"
      "input"
      "uinput" # Needed for Ydotool
      "libvirtd" # Needed for Virt Manager
      "vboxusers" # Needed for Virtualbox
      "docker"
    ];
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  xdg = {
    menus.enable = true;
    icons.enable = true;
    autostart.enable = true;
    mime = {
      enable = true;
      defaultApplications = params.xdg-mime-default-apps;
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
        hyprland = {
          default = [ "hyprland" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        };
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      antialias = true;
      useEmbeddedBitmaps = true;
      # Improve rendering sharpness
      hinting = {
        enable = true;
        autohint = true;
        # Amount of font reshaping
        # slight will make the font more fuzzy to line up to the grid but will be better in retaining font shape
        style = "slight";
      };
      subpixel = {
        lcdfilter = "light";
        rgba = "rgb";
      };
    };
    packages = with pkgs; [
      noto-fonts
      ubuntu_font_family
      liberation_ttf
      winePackages.fonts
      google-fonts
      pkgs-unstable.material-symbols roboto-flex rubik twemoji-color-font # Fonts for Quickshell
      corefonts
      nerd-fonts.jetbrains-mono
    ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  environment = {
    localBinInPath = true;
    homeBinInPath = true;
    # System-level ZSH configuration
    shells = with pkgs; [ zsh nushell ];
    pathsToLink = [ "/share/zsh" ];
    # System-wide session environment variables:
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      GNOME_KEYRING_CONTROL = "/run/user/$UID/keyring";
      SSH_AUTH_SOCK = "/run/user/$UID/keyring/ssh";
      GNOME_KEYRING_PID = "";
      TERMINAL = "kitty";
      NVD_BACKEND = "direct";
      # LIBVA_DRIVER_NAME = "nvidia";
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      NIXOS_OZONE_WL = "1";
      EDITOR = "vim";
      VISUAL = "vim";
      GDM_LANG = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      XDG_RUNTIME_DIR = "/run/user/$UID";
      GTK_USE_PORTAL = "1";
      PATH = [
        "/home/anthony/.local/share/JetBrains/Toolbox/scripts"
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    usbutils sysstat bandwhich hwinfo lm_sensors lsof
    pciutils inetutils ethtool dnsutils unixtools.netstat
    ddcutil libva-utils
    lshw-gui lshw
    telegram-desktop
    ffmpeg-full sox vlc libreoffice-fresh tor-browser
    wine winetricks keepassxc seahorse krusader
    calibre mu dropbox yt-dlp zip unzip
    hledger hledger-ui hledger-web gnucash
    obs-studio fontforge jadx ghidra
    gnome-builder puffin mullvad-vpn
    blueman ventoy-full
    wayland-utils egl-wayland vulkan-tools mesa-demos
    ffuf protonvpn-cli protonvpn-gui
    dconf-editor util-linux networkmanagerapplet
    gimp3-with-plugins inkscape
    loupe sushi code-nautilus
    discord vesktop fractal signal-desktop
    rhythmbox darktable pidgin audacity sublime4
    libsecret xorg.xhost polkit_gnome
    desktop-file-utils iotop iftop
    qalculate-gtk poppler
    yubikey-manager yubikey-personalization yubioath-flutter yubico-piv-tool
    lynx universal-ctags ddd
    wirelesstools
    e2fsprogs
    tinc # "https://www.tinc-vpn.org/"
    opentracker # "https://erdgeist.org/arts/software/opentracker/"
    hardinfo2
    easyeffects

    qbittorrent digikam

    maltego burpsuite zap nmap aircrack-ng john johnny hashcat apktool gparted

    # Additional Nix tools:
    nurl nix-init nix-index nixfmt-rfc-style
    nix-tree nix-du
    inputs.nix-alien.packages.${system}.nix-alien

    # XDG related tools:
    xdg-launch xdg-utils # A set of command line tools that assist apps with a variety of desktop integration tasks
    xdg-user-dirs # Tool to help manage well known user directories like the desktop folder and the music folder
    xdg-dbus-proxy # DBus proxy for Flatpak and others
    d-spy # A viewer and debugger for D-Bus messages

    # Virtualization:
    distrobox boxbuddy
    # Markdown editors:
    apostrophe

    # Gnome related apps:
    gnome-control-center gnome-tweaks gnome-shell-extensions evolution
    gnome-themes-extra gnome-remote-desktop
  ] ++ (with pkgs.kdePackages; [
    marble qtwayland okular ghostwriter
    kcharselect kclock isoimagewriter
  ]) ++ (with pkgs-unstable; [
    gnome-network-displays
    microsoft-edge
    google-chrome
    # Python3 environment (latest) with some other pkgs (including jupyterlab):
    (python3.withPackages (
      ps: with ps; [
        python-lsp-server
        pylsp-mypy
        pyls-isort
        pydocstyle
        pylint
        jupyterlab
        jupyterlab-lsp
        numpy
        pandas
        matplotlib
        scipy
        sympy
        plotly
      ]
    ))
  ]);

  # Android (adb) setup
  programs.adb.enable = true;
  services.udev.extraRules =
    let
      # nix-shell -p usbutils --run "lsusb"
      idVendor = "04e8"; # Change according to the guide above
      idProduct = "6860"; # Change according to the guide above
    in
    ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", MODE="[]", GROUP="adbusers", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", ATTR{idProduct}=="${idProduct}", SYMLINK+="android_adb"
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", ATTR{idProduct}=="${idProduct}", SYMLINK+="android_fastboot"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TAG+="mutter-device-preferred-primary"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TAG+="mutter-device-preferred-primary"
    '';

  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Reduce timeouts for faster completion:
  # LogLevel=debug
  # LogTarget=console
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=30s
    DefaultTimeoutStartSec=30s
    UserStopDelaySec=10s
  '';
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=30s
    DefaultTimeoutStartSec=30s
  '';

  # Polkit starting systemd service - needed for apps requesting root access
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      uutils-coreutils-noprefix
      gtk3
      libglibutil
      glibc
      fuse
      libpkgconf
      # For Android Studio through JetBrains Toolbox:
      libsecret
      gnome-keyring
      glib
      dbus
      libGL
      libxkbcommon
      wayland
      fontconfig
      freetype
      e2fsprogs
      # For Android emulator:
      libpulseaudio
      libpng
      nss
      libtiff
      libuuid
      zlib
      libbsd
      ncurses5
      libdrm
      expat
      nspr
      alsa-lib
      llvmPackages_15.libllvm.lib
      llvmPackages_15.libcxx
      waylandpp.lib
      # For swiftly:
      binutils
      icu # libicu-dev
      curl # libcurl4-openssl-dev
      libedit # libedit-dev
      sqlite # libsqlite3-dev
      ncurses # libncurses-dev
      python311 # libpython3-dev
      libxml2 # libxml2-dev
      pkg-config # pkg-config (same name)
      util-linux # uuid-dev (provides libuuid)
      tzdata # tzdata (same name)
      gcc # gcc (same name)
      stdenv.cc.cc.lib # libstdc++-12-dev (included with gcc)
    ] ++ (with pkgs.xorg; [
      libX11
      libXext
      libXdamage
      libXfixes
      libxcb
      libXcomposite
      libXcursor
      libXi
      libXrender
      libXtst
      libICE
      libSM
      libxkbfile
      libxshmfence
      libXrandr
      xorgserver
    ]);
  };

  users.defaultUserShell = pkgs.zsh;

  # Config taken from here: https://github.com/pfaj/nixos-config/blob/master/modules/nixos/zram.nix
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  systemd.oomd.enable = false; # With 32 GiB of RAM and zram enabled OOM is unlikely

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
