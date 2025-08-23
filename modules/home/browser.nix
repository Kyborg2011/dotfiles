{ config, pkgs, inputs, ... }:

let
  profile_path = "dev-edition-default";
  ff = ".mozilla/firefox";
  userContent = builtins.replaceStrings [ "ASSETS" ] [ "file://${inputs.firefox-mod-blur}/ASSETS" ]
    (
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part2-file.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/userContent.css")
    );
  userChrome = builtins.replaceStrings [ "ASSETS" ] [ "file://${inputs.firefox-mod-blur}/ASSETS" ]
    (
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part1-file.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Menu icon change/menu_icon_change_to_firefox.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/uBlock icon change/ublock-icon-change.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Tabs Bar Mods/Pinned Tabs - no background color/pinned_tabs_no_bg_color.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Popout bookmarks bar/popout_bookmarks_bar_on_hover.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Remove folder icons from bookmars/remove_folder_icons_from_bookmarks.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Transparent bookmarks bar/transparent_bookmarks_bar.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Hide list-all-tabs button/only_show_list-all-tabs_when_tabs_overflowing.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Tabs Bar Mods/Colored sound playing tab/colored_soundplaying_tab.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Icons in main menu/icons_in_main_menu.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/EXTRA MODS/Compact extensions menu/Style 2/cleaner_extensions_menu.css") + "\n" +
      (builtins.readFile "${inputs.firefox-mod-blur}/userChrome.css") + ''
        /* Fix bug in context menu (dark mode): */
        @media (prefers-color-scheme: dark) {
          menu,
          menuitem {
            &:where([_moz-menuactive]:not([disabled="true"])) {
              color: rgba(255, 255, 255, 0.9) !important;
            }
          }
        }
      ''
    );
in {
  home.file = {
    "${ff}/${profile_path}/chrome/userChrome.css".text = userChrome;
    "${ff}/${profile_path}/chrome/userContent.css".text = userContent;
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