# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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
    nvidia.open = false;
  };

  ##################### BOOTLOADER ##########################
  boot.kernelPackages = pkgs.linuxPackages_6_13;

  boot = {
    #kernelPackages = inputs.nixpkgs-stable.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
    kernelParams = [
      "usbcore.autosuspend=-1"
    ];
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

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 8080 ];
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

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us,ru,ua";
      options = "grp:win_space_toggle";
    };
    videoDrivers = [ "nvidia" ];
  };

  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.virt-manager.enable = true;

  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
    podman.enable = true;
    libvirtd.enable = true;
  };

  programs.kdeconnect.enable = true;

  security = {
    polkit.enable = true;
    pam.services.astal-auth = {};
    rtkit.enable = true;
  };

  # List services that you want to enable:
  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    openssh.enable = true;
    tumbler.enable = true;
    libinput.enable = true;
    flatpak.enable = true;
    pulseaudio.enable = false;
    printing.enable = true;
    blueman.enable = true;
    mullvad-vpn.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      localsearch.enable = true;
      tinysparql.enable = true;
    };
  };

  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  hardware.graphics.extraPackages = [
    pkgs.intel-compute-runtime
    pkgs.intel-vaapi-driver
    pkgs.intel-media-driver
  ];

  programs = {
    dconf.enable = true;
    nm-applet.enable = true;
    gamemode.enable = true;
    firefox.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    npm = {
      enable = true;
      package = pkgs.nodejs;
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableJIT = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "03:15";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };
  };
  documentation.nixos.enable = true;

  xdg.icons.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anthony = {
    isNormalUser = true;
    description = "Anthony";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
    ];
    packages = with pkgs; [
      google-chrome
      kdePackages.okular
    ];
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    usbutils sysstat bandwhich hwinfo lm_sensors lsof pciutils unixtools.netstat wget curl telegram-desktop
    chromium qutebrowser eclipses.eclipse-sdk transmission_4-qt android-studio python312Packages.jupyterlab
    qtcreator ffmpeg sox audacity vlc mpv pidgin libreoffice-fresh gimp inkscape gparted tor-browser
    wine winetricks winePackages.fonts keepassxc seahorse htop btop krusader
    calibre mu rhythmbox dropbox yt-dlp zip unzip gnupg gnumake cmake
    watchman rustc steam hledger-ui hledger-web
    obs-studio emacs direnv gnucash fontforge discord sublime4 jadx ghidra
    gnome-builder joplin-desktop puffin tree bat git vim mullvad-vpn go cargo rustup
    blueman hledger yarn jdk23 z-lua zap kile bottles obsidian

    # Digikam - there is build failure!

    # Cyber Sec
    nmap burpsuite wireshark john hashcat ffuf protonvpn-cli
    
    # Gnome related apps + extensions for Gnome Shell
    gnome-control-center gnome-tweaks gnome-shell-extensions evolution
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.applications-menu
    gnomeExtensions.workspace-indicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
  ];

  programs.xfconf.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
    thunar-archive-plugin
    thunar-media-tags-plugin
  ];

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

  # System-wide environment variables
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    GDM_LANG = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };

  # System-level ZSH configuration
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    jdk17
    uutils-coreutils-noprefix
    xorg.xorgserver
    xorg.libX11
    gtk3
    libglibutil
    glib
    glibc
    javaPackages.openjfx17
    freetype
    libxkbcommon
    wayland
    fontconfig
    xorg.libXtst
    xorg.libXi
    xorg.libXrender
    xorg.libXext
  ];

  users.defaultUserShell = pkgs.zsh;

  # Config taken from here: https://github.com/pfaj/nixos-config/blob/master/modules/nixos/zram.nix
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;
  boot.kernel.sysctl."vm.swappiness" = 180; # zram is relatively cheap, prefer swap
  boot.kernel.sysctl."vm.page-cluster" = 0; # zram is in memory, no need to readahead
  boot.kernel.sysctl."vm.dirty_background_bytes" = 128 * 1024 * 1024; # Start asynchronously writing at 128 MiB dirty memory
  boot.kernel.sysctl."vm.dirty_ratio" = 50; # Start synchronously writing at 50% dirty memory
  boot.kernel.sysctl."vm.dirty_bytes" = 64 * 1024 * 1024;
  boot.kernel.sysctl."vm.vfs_cache_pressure" = 500;
  systemd.oomd.enable = false; # With 32 GiB of RAM and zram enabled OOM is unlikely

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
