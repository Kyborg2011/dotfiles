# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, pkgs, ... }:

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
      open = false; # For old GPUs like Nvidia Quadro M1200!
      nvidiaSettings = true;
      # Force Intel GPU for display:
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        # Use one of the following options:
        sync.enable = true;  # for perfomance
        # offload.enable = true;  # for powersave
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
      #"systemd.log_level=debug" 
      #"systemd.log_target=console"
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
      ];
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 8080 631 ];
      allowedUDPPorts = [ 53 631 ];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
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
      enableExtensionPack = false; # Disable autostart of services
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
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    npm = {
      enable = true;
      package = pkgs.nodejs;
    };
    system-config-printer.enable = true;
    dconf.enable = true;
    xfconf.enable = true;
    file-roller.enable = true;
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
    zsh.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    ydotool.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          # missing libraries here, e.g.: `pkgs.libepoxy`
        ];
      };
    };
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
    openssh = {
      enable = true;
      # require public key authentication for better security
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        #PermitRootLogin = "yes";
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
    };
    nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/" = {
          return = "200 '<html><body>It works</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };
      };
    };
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us,ru,ua";
        options = "grp:win_space_toggle";
      };
      videoDrivers = [ "modesetting" "nvidia" ];
      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
        xfce.enable = true;
      };
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      enableJIT = true;
    };
  };

  # Enable the NixOS printing service for HP printers:
  services.printing = {
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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
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
    ];
  };

  xdg.icons.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    usbutils sysstat bandwhich hwinfo lm_sensors lsof pciutils ethtool dnsutils unixtools.netstat
    lshw-gui lshw wget curl
    telegram-desktop chromium transmission_4-gtk
    qtcreator ffmpeg-full sox vlc libreoffice-fresh inkscape gparted tor-browser
    wine winetricks winePackages.fonts keepassxc seahorse krusader
    calibre mu dropbox yt-dlp zip unzip gnupg gnumake
    watchman steam hledger-ui hledger-web
    obs-studio direnv fontforge discord jadx ghidra
    gnome-builder puffin tree git vim mullvad-vpn
    blueman hledger yarn jdk z-lua kile bottles obsidian ventoy-full
    gnucash digikam
    ffuf protonvpn-cli protonvpn-gui
    dconf-editor xdg-utils util-linux networkmanagerapplet
    gimp3-with-plugins jupyter-all
    texliveFull loupe sushi code-nautilus
    vesktop fractal
    rhythmbox darktable pidgin audacity sublime4
    nix-index systemd libsecret xorg.xhost polkit_gnome
    desktop-file-utils iotop iftop
    kdePackages.marble kdePackages.qtwayland qgis
    nixfmt-rfc-style kdePackages.okular qalculate-gtk
    speedtest-cli neomutt poppler
    yubikey-manager yubikey-personalization yubioath-flutter yubico-piv-tool
    lynx universal-ctags ddd

    # Python3 environment with some other pkgs (including jupyterlab):
    (python3.withPackages(ps: [
      ps.python-lsp-server
      ps.pylsp-mypy ps.pyls-isort
      ps.pydocstyle ps.pylint
      ps.jupyterlab ps.jupyterlab-lsp
      ps.numpy ps.pandas ps.matplotlib
      ps.scipy ps.sympy ps.plotly
    ]))

    (google-chrome.override {
      # enable video encoding and hardware acceleration, along with several
      # suitable for my configuration
      # change it if you have any issues
      # note the spaces, they are required
      # Vulkan is not stable, likely because of drivers
      commandLineArgs = ""
        + " --enable-accelerated-video-decode"
        + " --enable-accelerated-mjpeg-decode"
        + " --enable-gpu-compositing"
        + " --enable-gpu-rasterization" # dont enable in about:flags
        + " --enable-native-gpu-memory-buffers"
        + " --enable-raw-draw"
        + " --enable-zero-copy" # dont enable in about:flags
        + " --ignore-gpu-blocklist" # dont enable in about:flags
        # + " --use-vulkan"
        + " --enable-features="
            + "VaapiVideoEncoder,"
            + "CanvasOopRasterization,"
            # + "Vulkan"
        ;
    })

    # Virtualization:
    distrobox boxbuddy

    # Markdown editors:
    typora apostrophe kdePackages.ghostwriter

    # Wallpaper managers on Wayland:
    swww waypaper

    # Utilities:
    jq killall ripgrep fd bat wirelesstools dust

    # OPSEC (from Kali Linux distribution):
    recon-ng theharvester maltego dmitry fierce openvas-scanner
    burpsuite zap commix reaverwps armitage mimikatz
    # Network discovery and scanning
    nmap masscan
    # DNS and domain reconnaissance  
    dnsrecon fierce
    # Vulnerability scanning
    nikto lynis
    # Web application testing
    dirb gobuster wfuzz sqlmap
    # Wireless security
    aircrack-ng pixiewps wifite2 kismet macchanger
    mdbtools gnuradio gqrx inspectrum
    # Exploitation frameworks
    metasploit
    # Password cracking
    john johnny hashcat thc-hydra medusa
    # Digital forensics
    binwalk foremost sleuthkit volatility2-bin yara volatility3
    # Network analysis
    wireshark tcpdump tcpflow tcpreplay netsniff-ng
    # Network tools
    netcat-gnu socat proxychains
    # Reverse engineering
    radare2 cutter apktool
    # SDR and radio
    hackrf kalibrate-rtl multimon-ng
    # RFID/NFC
    libnfc mfoc mfcuk
    # Fuzzing
    aflplusplus spike
    # Misc security tools
    chkrootkit ssdeep hashdeep exiv2 steghide
    # Network services
    sipp sipsak
    # Load testing
    siege
    # SSL/TLS tools
    sslscan ssldump sslsplit
    # Database tools
    sqlitebrowser
    # Archive tools
    fcrackzip pdfcrack unrar
    # System tools
    gparted ddrescue safecopy extundelete testdisk
    # Development tools
    gdb nasm

    # Gnome related apps + extensions for Gnome Shell:
    gnome-control-center gnome-tweaks gnome-shell-extensions evolution
    gnomeExtensions.dash-to-dock
    gnomeExtensions.applications-menu
    gnomeExtensions.workspace-indicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine

    # Firefox Developer Edition wrapper to use with profile:
    (writeShellScriptBin "firefox-dev" ''
      exec ${firefox-devedition}/bin/firefox-devedition --profile /home/anthony/.mozilla/firefox/dev-edition-default "$@"
    '')
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

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
    '';

  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.pathsToLink = [ "/share/zsh" ];

  # System-wide environment variables:
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    GDM_LANG = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    XDG_RUNTIME_DIR = "/run/user/$UID";
    PATH = [
      "/home/anthony/.local/share/JetBrains/Toolbox/scripts"
    ];
  };
  # System-wide session environment variables:
  environment.sessionVariables = {
    GNOME_KEYRING_CONTROL = "/run/user/$UID/keyring";
    SSH_AUTH_SOCK = "/run/user/$UID/keyring/ssh";
    GNOME_KEYRING_PID = "";
    TERMINAL = "kitty";
  };

  # System-level ZSH configuration
  environment.shells = with pkgs; [ zsh nushell ];

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
      jdk17
      uutils-coreutils-noprefix
      xorg.xorgserver
      gtk3
      libglibutil
      glib
      glibc
      javaPackages.openjfx17
      fuse
      xorg.libxcb

      # For Android Studio through JetBrains Toolbox:
      libsecret
      gnome-keyring
      glib
      dbus
      libGL
      libxkbcommon
      wayland
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      fontconfig
      freetype
    ];
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
