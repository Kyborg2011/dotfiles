{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
      case-sensitive = false;
      cycle = true;
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "#ebdbb2";
          gruvbox-dark-bg0-hard = mkLiteral "#1d2021";
          gruvbox-dark-bg0 = mkLiteral "#282828";
          gruvbox-dark-bg2 = mkLiteral "#504945";
          gruvbox-dark-fg0 = mkLiteral "#fbf1c7";
          gruvbox-dark-fg1 = mkLiteral "#ebdbb2";
          gruvbox-dark-red-dark = mkLiteral "#cc241d";
          gruvbox-dark-red-light = mkLiteral "#fb4934";
          gruvbox-dark-yellow-dark = mkLiteral "#d79921";
          gruvbox-dark-yellow-light = mkLiteral "#fabd2f";
          gruvbox-dark-gray = mkLiteral "#a89984";
        };

        "window" = {
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          fullscreen = false;
          width = mkLiteral "600px";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";
          border-radius = mkLiteral "12px";
          cursor = mkLiteral "default";
          background-color = mkLiteral "@gruvbox-dark-bg0";
          border = mkLiteral "2px solid";
          border-color = mkLiteral "@gruvbox-dark-bg2";
        };

        "mainbox" = {
          spacing = mkLiteral "0px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "vertical";
          children = mkLiteral "[ \"inputbar\", \"listbox\" ]";
        };

        "inputbar" = {
          spacing = mkLiteral "10px";
          padding = mkLiteral "15px";
          border-radius = mkLiteral "0px";
          border-color = mkLiteral "@gruvbox-dark-bg2";
          background-color = mkLiteral "@gruvbox-dark-bg0";
          text-color = mkLiteral "@gruvbox-dark-fg1";
          children = mkLiteral "[ \"textbox-prompt-colon\", \"entry\" ]";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = mkLiteral "\" \"";
          padding = mkLiteral "12px 16px";
          border-radius = mkLiteral "100%";
          background-color = mkLiteral "@gruvbox-dark-yellow-dark";
          text-color = mkLiteral "@gruvbox-dark-bg0";
        };

        "entry" = {
          expand = true;
          width = mkLiteral "300px";
          padding = mkLiteral "12px 16px";
          border-radius = mkLiteral "12px";
          background-color = mkLiteral "@gruvbox-dark-bg2";
          text-color = mkLiteral "@gruvbox-dark-fg1";
          cursor = mkLiteral "text";
          placeholder-color = mkLiteral "@gruvbox-dark-gray";
        };

        "listbox" = {
          spacing = mkLiteral "0px";
          padding = mkLiteral "0px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "vertical";
          children = mkLiteral "[ \"listview\" ]";
        };

        "listview" = {
          columns = 1;
          lines = 8;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = true;
          spacing = mkLiteral "0px";
          padding = mkLiteral "10px";
          margin = mkLiteral "0px";
          background-color = mkLiteral "transparent";
        };

        "element" = {
          spacing = mkLiteral "15px";
          padding = mkLiteral "8px";
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@gruvbox-dark-fg1";
          cursor = mkLiteral "pointer";
        };

        "element normal.normal" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "@gruvbox-dark-red-dark";
          text-color = mkLiteral "@gruvbox-dark-fg0";
        };

        "element normal.active" = {
          background-color = mkLiteral "@gruvbox-dark-yellow-dark";
          text-color = mkLiteral "@gruvbox-dark-bg0";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@gruvbox-dark-bg2";
          text-color = mkLiteral "@gruvbox-dark-fg0";
        };

        "element selected.urgent" = {
          background-color = mkLiteral "@gruvbox-dark-red-light";
          text-color = mkLiteral "@gruvbox-dark-fg0";
        };

        "element selected.active" = {
          background-color = mkLiteral "@gruvbox-dark-yellow-light";
          text-color = mkLiteral "@gruvbox-dark-bg0";
        };

        "element-icon" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "32px";
          cursor = mkLiteral "inherit";
        };

        "element-text" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };

        "error-message" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@gruvbox-dark-bg0";
          text-color = mkLiteral "@gruvbox-dark-fg1";
        };

        "textbox" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@gruvbox-dark-bg2";
          text-color = mkLiteral "@gruvbox-dark-fg1";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
      };

    terminal = "${pkgs.kitty}/bin/kitty";
  };
}
