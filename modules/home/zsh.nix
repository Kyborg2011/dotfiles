{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [
        "git"
        "alias-finder"
        "command-not-found"
        "common-aliases"
        "copyfile"
        "copypath"
        "dnf"
        "fzf"
        "genpass"
        "kitty"
      ];
    };

    initExtra = ''
      # Wayland specific configuration
      if [[ "$XDG_SESSION_DESKTOP" =~ ^(sway|i3|Hyprland|hyprland)$ ]]; then
        export _JAVA_AWT_WM_NONREPARENTING=1
        export SDL_VIDEODRIVER=wayland
        export SAL_USE_VCLPLUGIN=gtk3
        export ELECTRON_OZONE_PLATFORM_HINT=auto
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export QT_QPA_PLATFORM=wayland
        export QT_QPA_PLATFORMTHEME=qt6ct
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_WAYLAND_FORCE_DPI=physical
        export JAVA_TOOL_OPTIONS='-Djdk.gtk.version=2.2'
        export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
        export CLUTTER_BACKEND=wayland
        export XCURSOR_SIZE=24
        export NIXOS_OZONE_WL=1
        export GDK_BACKEND=wayland
      fi

      # History configuration
      export HIST_STAMPS="dd.mm.yyyy"

      # Path configurations
      export PATH="$HOME/Android/Sdk/platform-tools:$PATH"
      export PATH="$HOME/Android/Sdk/emulator:$PATH"
      export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
      export PATH="$HOME/.yarn/bin:$PATH"

      # Hledger configuration
      export LEDGER_FILE="$HOME/Dropbox/09 Business/06 Ledger/main.journal"

      # Load z tool
      #source ${pkgs.z-lua}/share/z.lua/z.lua

      bindkey "''${key[Up]}" up-line-or-search
      bindkey "''${key[Down]}" down-line-or-search
    '';

    shellAliases = {
      zshconfig = "vim ~/.zshrc";
      ohmyzsh = "vim ~/.oh-my-zsh";
      night = "killall -q hyprsunset; hyprsunset -t 4900 &";
      night-off = "killall -q hyprsunset; hyprsunset -t 6000 &";
    };
  };

  # FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}