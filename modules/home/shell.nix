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

    initContent = ''
      SHELL=${pkgs.zsh}/bin/zsh

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

      bindkey "''${key[Up]}" up-line-or-search
      bindkey "''${key[Down]}" down-line-or-search
      
      zstyle ':completion:*' menu select
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # Disable arrow autocompletion:
      bindkey "^[[C" forward-char
      bindkey "^[OC" forward-char
      # Use Ctrl+Tab for autocompletion instead:
      bindkey "^X^I" expand-or-complete
      
      # Autocompletion settings:
      setopt NO_AUTO_MENU
      setopt NO_MENU_COMPLETE
      setopt AUTO_LIST
      
      # Disable ctrl+shift+v emphasizing:
      zle_highlight+=(paste:none)

      unsetopt BEEP
    '';

    shellAliases = {
      zshconfig = "vim ~/.zshrc";
      ohmyzsh = "vim ~/.oh-my-zsh";
      night = "killall -q hyprsunset; hyprsunset -t 4900 &";
      night-off = "killall -q hyprsunset; hyprsunset -t 6000 &";
      firefox = "firefox-devedition --profile ~/.mozilla/firefox/dev-edition-default";
      tree = "eza --tree";
      ll = "eza --group-directories-first --icons -al";
      l = "ls";
      ":q" = "exit";
      q = "exit";
      gs = "git status";
      gc = "git commit";
      ga = "git add";
      gr = "git reset --soft HEAD~1";
      gp = "git push";
    };
  };

  # Interesting option for learning:
  programs.nushell.enable = true;

  # FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Z-Lua integration
  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "fzf"
      "enhanced"
    ];
  };
}