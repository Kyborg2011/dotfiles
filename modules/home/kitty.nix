{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "InputMono Nerd Font";
      size = 12; # You might need to adjust this based on the +8px cell height
    };
    settings = {
      cursor = "#fbf1c7";
      scrollback_pager_history_size = 100;
      enable_audio_bell = "no";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_separator = " ┇";
      wayland_titlebar_color = "background";
      
      # Monokai theme colors
      background = "#272822";
      foreground = "#f8f8f2";
      selection_background = "#f8f8f2";
      selection_foreground = "#272822";
      active_tab_background = "#75715e";
      active_tab_foreground = "#272822";
      active_border_color = "#75715e";
      inactive_tab_background = "#272822";
      inactive_tab_foreground = "#75715e";
      inactive_border_color = "#75715e";
      url_color = "#f8f8f2";

      # 16 Color Space
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
      color15 = "#f8f8f2";

      remember_window_size = "yes";
      initial_window_width = 640;
      initial_window_height = 400;
    };
    
    # Open actions configuration
    extraConfig = ''
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
