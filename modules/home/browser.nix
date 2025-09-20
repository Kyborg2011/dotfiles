{ config, pkgs, pkgs-unstable, inputs, ... }:

let
  concatFilesContent = sourceSubstr: targetSubstr: files:
    builtins.replaceStrings [ sourceSubstr ] [ targetSubstr ] (
      builtins.concatStringsSep "\n" (
        map (p: builtins.readFile p) files
      )
    );
  profile_path = "dev-edition-default";
  ff = ".mozilla/firefox";
  userContent = concatFilesContent "ASSETS" "file://${inputs.firefox-mod-blur}/ASSETS" [
    "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part2-file.css"
    "${inputs.firefox-mod-blur}/userContent.css"
  ];
  userChrome = concatFilesContent "ASSETS" "file://${inputs.firefox-mod-blur}/ASSETS" [
    "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part1-file.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Menu icon change/menu_icon_change_to_firefox.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/uBlock icon change/ublock-icon-change.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Tabs Bar Mods/Pinned Tabs - no background color/pinned_tabs_no_bg_color.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Popout bookmarks bar/popout_bookmarks_bar_on_hover.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Remove folder icons from bookmars/remove_folder_icons_from_bookmarks.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Bookmarks Bar Mods/Transparent bookmarks bar/transparent_bookmarks_bar.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Hide list-all-tabs button/only_show_list-all-tabs_when_tabs_overflowing.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Tabs Bar Mods/Colored sound playing tab/colored_soundplaying_tab.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Icon and Button Mods/Icons in main menu/icons_in_main_menu.css"
    "${inputs.firefox-mod-blur}/EXTRA MODS/Compact extensions menu/Style 2/cleaner_extensions_menu.css"
    "${inputs.firefox-mod-blur}/userChrome.css"
  ];
  userChromeBugFix = ''
    /* Fix bug in context menu (dark mode): */
    @media (prefers-color-scheme: dark) {
      menu,
      menuitem {
        &:where([_moz-menuactive]:not([disabled="true"])) {
          color: rgba(255, 255, 255, 0.9) !important;
        }
      }
    }
  '';
in {
  home.file = {
    "${ff}/${profile_path}/chrome/userChrome.css".text = userChrome + userChromeBugFix;
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
          "general.useragent.locale" = "ru-UA";
          "browser.search.region" = "UA";
          "browser.fullscreen.autohide" = false;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.tabs.loadInBackground" = true;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.translations.automaticallyPopup" = false;
          "browser.translations.neverTranslateLanguages" = "ru,en";
          "browser.translation.neverForLanguages" = "ru,en";
          "distribution.searchplugins.defaultLocale" = "ru-UA";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "widget.gtk.native-context-menus" = false;
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
