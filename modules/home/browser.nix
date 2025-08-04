{ config, pkgs, inputs, ... }:

let
  profile_path = "dev-edition-default";
  ff = ".mozilla/firefox";
in {
  home.file = {
    "${ff}/${profile_path}/chrome/userChrome.css".source = "${inputs.firefox-mod-blur}/userChrome.css";
    "${ff}/${profile_path}/chrome/userContent.css".source = "${inputs.firefox-mod-blur}/userContent.css";
    "${ff}/${profile_path}/chrome/ASSETS".source = "${inputs.firefox-mod-blur}/ASSETS";
    "${ff}/${profile_path}/chrome/spill-style-part1-file.css".source = "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part1-file.css";
    "${ff}/${profile_path}/chrome/spill-style-part2-file.css".source = "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part2-file.css";
    "${ff}/${profile_path}/chrome/min-max-close_buttons.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Min-max-close control buttons/Right side MacOS style buttons/min-max-close_buttons.css";
    "${ff}/${profile_path}/chrome/only_show_list-all-tabs_when_tabs_overflowing.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Hide list-all-tabs button/only_show_list-all-tabs_when_tabs_overflowing.css";
    "${ff}/${profile_path}/chrome/colored_soundplaying_tab.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Tabs Bar Mods/Colored sound playing tab/colored_soundplaying_tab.css";
    "${ff}/${profile_path}/chrome/icons_in_main_menu.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Icons in main menu/icons_in_main_menu.css";
    "${ff}/${profile_path}/chrome/cleaner_extensions_menu.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Compact extensions menu/Style 2/cleaner_extensions_menu.css";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles = {
      default = {
        isDefault = true;
        path = profile_path;
        settings = {
          "browser.tabs.loadInBackground" = true;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "browser.fullscreen.autohide" = false;
        };
      };
    };
  };
}