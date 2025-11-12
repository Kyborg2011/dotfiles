{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "InputMono Nerd Font";
      size = 11.0;
    };
    
    settings = {
      scrollback_pager_history_size = 10;
      scrollback_lines = 10000;
      enable_audio_bell = "no";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_separator = " ┇";
      wayland_titlebar_color = "background";
      remember_window_size = "yes";
      initial_window_width = 800;
      initial_window_height = 400;
      modify_font = "cell_height 130%";
      hide_window_decorations = "no";
      notify_on_cmd_finish = "invisible";

      # Animating cursor tail (grabbed from https://itsfoss.com/kitty-customization/):
      #cursor_trail = 200;
      #cursor_trail_decay = "0.1 0.4";
      #cursor_trail_start_threshold = 2;

      # <Monokai Soda> theme colors:
      background = "#191919";
      foreground = "#c4c4b5";
      cursor = "#f6f6ec";
      selection_background = "#343434";
      color0 = "#191919";
      color8 = "#615e4b";
      color1 = "#f3005f";
      color9 = "#f3005f";
      color2 = "#97e023";
      color10 = "#97e023";
      color3 = "#fa8419";
      color11 = "#dfd561";
      color4 = "#9c64fe";
      color12 = "#9c64fe";
      color5 = "#f3005f";
      color13 = "#f3005f";
      color6 = "#57d1ea";
      color14 = "#57d1ea";
      color7 = "#c4c4b5";
      color15 = "#f6f6ee";
      selection_foreground = "#191919";
      active_tab_foreground = "#eeeeee";
      active_tab_background = "#343434";
      inactive_tab_foreground = "#c4c4b5";
      inactive_tab_background = "#141414";

      # <Monokai> theme colors:
      /*background = "#272822";
      foreground = "#f8f8f2";
      cursor = "#f8f8f2";
      selection_background = "#f8f8f2";
      selection_foreground = "#272822";
      active_tab_background = "#75715e";
      active_tab_foreground = "#272822";
      active_border_color = "#75715e";
      inactive_tab_background = "#272822";
      inactive_tab_foreground = "#75715e";
      inactive_border_color = "#75715e";
      url_color = "#f8f8f2";
      color0 = "#272822";
      color8 = "#75715e";
      color1 = "#f92672";
      color9 = "#f92672";
      color2 = "#a6e22e";
      color10 = "#a6e22e";
      color3 = "#e6db74";
      color11 = "#e6db74";
      color4 = "#66d9ef";
      color12 = "#66d9ef";
      color5 = "#fd971f";
      color13 = "#fd971f";
      color6 = "#ae81ff";
      color14 = "#ae81ff";
      color7 = "#f8f8f2";
      color15 = "#f8f8f2";*/
    };
    
    # Open actions configuration
    extraConfig = ''
      # Instead of ctrl+shift+home:
      map ctrl+shift+h scroll_home

      # Open a new tab with the shell's working directory:
      map ctrl+shift+t launch --cwd=current --type=tab

      # Middle-click to paste from selection action:
      mouse_map middle release ungrabbed paste_from_selection

      # Tail a log file (*.log) in a new OS Window and reduce its font size
      protocol file
      ext log
      action launch --title ''${FILE} --type=os-window tail -f ''${FILE_PATH}
      action change_font_size current -2

      # Open any file with a fragment in the editor
      protocol file
      fragment_matches [0-9]+
      action launch --type=overlay $EDITOR +$FRAGMENT $FILE_PATH

      # Open text files without fragments in the editor
      protocol file
      mime text/*
      action launch --type=overlay $EDITOR $FILE_PATH

      # Open image files in an overlay window with icat
      protocol file
      mime image/*
      action launch --type=overlay kitty +kitten icat --hold $FILE_PATH

      protocol filelist
      action send_text all ''${FRAGMENT}
    '';
  };
}
