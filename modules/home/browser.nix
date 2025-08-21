{ config, pkgs, inputs, ... }:

let
  profile_path = "dev-edition-default";
  ff = ".mozilla/firefox";
in {
  home.file = {
    "${ff}/${profile_path}/chrome/userChrome.css".source = "${inputs.firefox-mod-blur}/userChrome.css";
    "${ff}/${profile_path}/chrome/userContent.css".source = "${inputs.firefox-mod-blur}/userContent.css";
    "${ff}/${profile_path}/chrome/ASSETS".source = "${inputs.firefox-mod-blur}/ASSETS";
    "${ff}/${profile_path}/chrome/wallpaper-edition.css".source = "${inputs.firefox-mod-blur}/EXTRA THEMES/Wallpaper Edition/Style 2/wallpaper-edition.css";
    "${ff}/${profile_path}/chrome/bookmarks_bar_same_color_as_toolbar.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Bookmarks bar same color as toolbar/bookmarks_bar_same_color_as_toolbar.css";
    "${ff}/${profile_path}/chrome/only_show_list-all-tabs_when_tabs_overflowing.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Hide list-all-tabs button/only_show_list-all-tabs_when_tabs_overflowing.css";
    "${ff}/${profile_path}/chrome/colored_soundplaying_tab.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Tabs Bar Mods/Colored sound playing tab/colored_soundplaying_tab.css";
    "${ff}/${profile_path}/chrome/icons_in_main_menu.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Icons in main menu/icons_in_main_menu.css";
    "${ff}/${profile_path}/chrome/cleaner_extensions_menu.css".source = "${inputs.firefox-mod-blur}/EXTRA MODS/Compact extensions menu/Style 2/cleaner_extensions_menu.css";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profileVersion = null;
    profiles = {
      default = {
        id = 0;
        isDefault = true;
        path = profile_path;
        settings = {
          "browser.fullscreen.autohide" = false;
          "browser.search.region" = "UA";
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.tabs.loadInBackground" = true;
          "browser.tabs.insertAfterCurrent" = true;
          "distribution.searchplugins.defaultLocale" = "ru-UA";
          "general.useragent.locale" = "ru-UA";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
        };
      };
    };
  };

  xdg.desktopEntries."firefox-dev" = {
    name = "Firefox Developer Edition";
    comment = "Firefox Developer Edition with custom profile";
    exec = "firefox-dev";
    categories = [ "Network" "WebBrowser" ];
    terminal = false;
  };
}