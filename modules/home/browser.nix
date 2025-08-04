{ config, pkgs, inputs, ... }:

let
  profile_path = "dev-edition-default";
in {
  home.file = [
    ".mozilla/firefox/${profile_path}/chrome/userChrome.css".source = "${inputs.firefox-mod-blur}/userChrome.css";
    firefox-mod-blur-user-content = {
      target = ".mozilla/firefox/${profile_path}/chrome/userContent.css";
      source = "${inputs.firefox-mod-blur}/userContent.css";
    };
    firefox-mod-blur-assets = {
      target = ".mozilla/firefox/${profile_path}/chrome/ASSETS";
      source = "${inputs.firefox-mod-blur}/ASSETS";
    };
    firefox-mod-blur-spill1 = {
      target = ".mozilla/firefox/${profile_path}/chrome/spill-style-part1-file.css";
      source = "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part1-file.css";
    };
    firefox-mod-blur-spill2 = {
      target = ".mozilla/firefox/${profile_path}/chrome/spill-style-part2-file.css";
      source = "${inputs.firefox-mod-blur}/EXTRA THEMES/Spill/spill-style-part2-file.css";
    };
  ];

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